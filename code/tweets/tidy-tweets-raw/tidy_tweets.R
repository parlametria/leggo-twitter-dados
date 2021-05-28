library(tidyverse)
library(data.table)

#' @title Processa tweets capturados pelo crawler durante um período de tempo
#' @description Processa e salva lotes do arquivo bruto de tweets
#' @param datapath Caminho para diretório onde fica o arquivo bruto de tweets nomeado tweets-gps-ideologico.csv. 
#' Deve ter o "/" no final. Exemplo: datapath="data/"
process_tweets_raw <- function(datapath) {
  
  header <-
    c(
      "id",
      "username",
      "text",
      "like_count",
      "reply_count",
      "retweet_count",
      "interactions",
      "status_url",
      "created_at"
    )
  
  sequencia <- seq(0, 10e6, 1e6)
  
  usernames <- pmap_df(list(sequencia),
                       ~ clean_tweets(..1, datapath, header))
  
  usernames_alt <- usernames %>% 
    group_by(username) %>% 
    summarise(updated = max(last_tweet)) %>% 
    ungroup()
  
  write_csv(usernames_alt, paste0(datapath, "log_update_tweets.csv"))
  
}

#' @title Processa um subconojunto dos tweets capturados salvando em csv
#' @description Processa e salva lotes do arquivo bruto de tweets
#' @param skip Número de linhas para pular na leitura do csv de tweets
#' @param datapath Caminho para diretório de leitura do csv de tweets brutos e de salvamento do csv processado
#' @param header Array com nome das colunas
#' @return Dataframe de usernames com a data do último tweet capturado
clean_tweets <- function(skip, datapath, header) {
  message(skip)
  
  tweet_raw_datapath <- paste0(datapath, "tweets-gps-ideologico.csv")
  
  tweets <- data.table::fread(tweet_raw_datapath, nrows = 1e6, skip = skip, header = F) %>% 
    mutate(created_at = stringr::str_extract(V2, "\\d{4}-\\d{2}-\\d{2}")) %>% 
    mutate(V2 = stringr::str_remove(V2, "\\d{4}-\\d{2}-\\d{2}"))
  
  names(tweets) <- header
  
  tweets_alt <- tweets %>% 
    mutate(quote_count = NA_integer_) %>% 
    select(id_tweet = id, username, text, date = created_at, url = status_url, 
           reply_count, retweet_count, like_count, quote_count)
  
  usernames <- tweets_alt %>% 
    group_by(username) %>% 
    summarise(last_tweet = max(date)) %>% 
    ungroup()
  
  write_csv(tweets_alt, paste0(datapath, "tweets_skip_", skip, ".csv"))
  
  return(usernames)
}
