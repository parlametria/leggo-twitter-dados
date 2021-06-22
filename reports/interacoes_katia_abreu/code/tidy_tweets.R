library(tidyverse)
library(data.table)

#' @title Processa tweets capturados pelo crawler durante um período de tempo
#' @description Processa e salva lotes do arquivo bruto de tweets
#' @param datapath Caminho para diretório onde fica o arquivo bruto de tweets nomeado tweets-gps-ideologico.csv. 
#' Deve ter o "/" no final. Exemplo: datapath="data/"
process_tweets_raw <- function(datapath) {
  
  sequencia <- seq(0, 10e6, 1e6)
  
  header <-  c("id_tweet",
               "username",
               "text",
               "date",
               "url",
               "reply_count",
               "retweet_count",
               "like_count",
               "quote_count")
  
  tweets <- pmap_df(list(sequencia),
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
  
  tweet_raw_datapath <- paste0(datapath, "data.csv")
  
  tweets <- data.table::fread(tweet_raw_datapath, nrows = 1e6, skip = skip, header = F)
  
  names(tweets) <- header
  
  tweets <- tweets %>% 
    filter(username == "katiaabreu" | stringr::str_detect(tolower(text), "@katiaabreu"))
  
  write_csv(tweets, paste0(datapath, "tweet_skip_", skip, ".csv"))
  return(tibble())
}


files = list.files(here::here("data/tweets/katia/"), "tweet_skip_.*", full.names = T)

df <- purrr::map_df(files, ~ read_csv(.x))
write_csv(df, here::here("reports/interacoes_katia_abreu/data/tweets_to_process_all.csv"))

