#' @title Prepara dataframe de tweets
#' @description Prepara colunas do dataframe de tweets para mescla
#' @return Dataframe formatado
.preprocess_tweets <- function(df, selected_columns) {
  names(df) <- names(df) %>% 
    tolower()
  
  df <- df %>% 
    select(all_of(selected_columns)) %>% 
    mutate(casa = iconv(casa, to="ASCII//TRANSLIT"))
  return(df)
}

#' @title Cria uma coluna com o id do tweet
#' @description Cria uma coluna com o id do tweet, retirando da coluna status_url
#' @return Dataframe adicionado do id_tweet
.get_id_tweet <- function(df) {
  df <- df %>% 
    rowwise(.) %>% 
    mutate(id_tweet = str_split(status_url, "/")[[1]][6]) %>% 
    ungroup()
  return(df)
}

#' @title Baixa os tweets da versão inicial
#' @description Retorna os dados de tweets da versão inicial do leggo 
#' twitter
#' @return Dataframe com informações de tweets da versão inicial do leggo 
#' twitter
fetch_tweets <- function() {
  library(tidyverse)
  source(here::here("code/tweets/constants_tweets.R"))
  
  tweets_todos <- read_csv(here::here("data/tweets/tweets_todos.zip"), col_types = cols(.default = "c")) %>% 
    .preprocess_tweets(c("id_parlamentar", "casa", "username", "created_at", "text", "interactions", "status_url")) %>% 
    .get_id_tweet() %>% 
    distinct(id_tweet, .keep_all = TRUE)
  
  tweets_com_mencoes <- read_csv(.URL_MENCOES_CR, col_types = cols(.default = "c")) %>% 
    .preprocess_tweets(c("id_parlamentar", "casa", "username", "created_at", "text", "interactions", "status_url", "id_tweet", "citadas"))
  
  tweets <- bind_rows(tweets_todos, tweets_com_mencoes) %>% 
    distinct(id_tweet, citadas, .keep_all = TRUE)
  
  tweets_filtrados <- tweets %>% 
    filter(!is.na(id_tweet))
  
  message(str_glue("Tweets sem id ignorados: {tweets %>% filter(is.na(id_tweet)) %>% nrow()}"))

  return(tweets_filtrados)
}


#' @title Recupera os tweets baixados pelo crawler do repositório
#' @description Realiza a consulta para baixar os dados de tweets do banco de dados
#' @return Dataframe com os tweets
fetch_tweets_raw <- function() {
  library(tidyverse)
  source(here::here("code/tweets/constants_tweets.R"))
  
  tryCatch({
    con <- DBI::dbConnect(RPostgres::Postgres(),
                          dbname = POSTGRES_TWEETS_DATABASE, 
                          host = POSTGRES_TWEETS_HOST, 
                          port = POSTGRES_TWEETS_PORT,
                          user = POSTGRES_TWEETS_USER,
                          password = POSTGRES_TWEETS_PASS)
    message("Acesso criado ao BD dos tweets com sucesso")
    }, 
    error = function(e) stop(paste0("Erro ao tentar se conectar ao BD doss tweets: ",e))
  )
  
  res <- DBI::dbGetQuery(con, "SELECT * from tweet_raw;")
  
  return(res)
}
