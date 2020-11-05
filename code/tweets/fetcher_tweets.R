#' @title Prepara dataframe de tweets
#' @description Prepara colunas do dataframe de tweets para mescla
#' @return Dataframe formatado
.preprocess_tweets <- function(df, selected_columns) {
  names(df) <- names(df) %>% 
    tolower()
  
  df <- df %>% 
    select(selected_columns) %>% 
    mutate(casa = iconv(casa, to="ASCII//TRANSLIT"))
  return(df)
}

#' @title Cria uma coluna com o id do tweet
#' @description Cria uma coluna com o id do tweet, retirando da coluna status_url
#' @return Dataframe adicionado do id_tweet
.get_id_tweet <- function(df) {
  df <- df %>% 
    rowwise(.) %>% 
    mutate(id_tweet = str_split(status_url, "/")[[1]][6])
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
  
  tweets_todos <- read_csv(here::here("data/tweets/tweets_parlamentares_todos.zip"), col_types = cols(.default = "c")) %>% 
    .preprocess_tweets(c("id_parlamentar", "casa", "username", "created_at", "text", "interactions", "status_url")) %>% 
    .get_id_tweet()
  tweets_com_mencoes <- read_csv(.URL_MENCOES_CR, col_types = cols(.default = "c")) %>% 
    .preprocess_tweets(c("id_parlamentar", "casa", "username", "created_at", "text", "interactions", "status_url", "id_tweet", "citadas"))
  
  tweets <- bind_rows(tweets_todos, tweets_com_mencoes)
  
  return(tweets)
}
