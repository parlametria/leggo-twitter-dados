.extract_sigla <- function(df) {
  library(tidyverse)
  library(stringr)
  
  df %>%
    mutate(text_sem_links = str_remove_all(text, "http[s]?://(?:[a-zA-Z]|[0-9]|[$-_@.&+]|[!*\\(\\),]|(?:%[0-9a-fA-F][0-9a-fA-F]))+")) %>%
    mutate(sigla = str_extract(tolower(text_sem_links), "(pl(n|s|p|)|pec|mp(v|)|pdl|pdc|prc) ?n?º? ?\\d*\\.?\\d+\\/?\\d*")) %>%
    mutate(sigla_processada = gsub("º| |\\.", "", sigla) %>% tolower()) %>%
    mutate(sigla_processada = gsub("mpv", "mp", sigla_processada)) %>% 
    separate(sigla_processada, c("sigla_nome", "ano"), sep = "/") %>%  
    mutate(ano = case_when(
      nchar(ano) == 4 ~ ano,
      as.integer(ano) > 70 ~ paste0("19", ano),
      as.integer(ano) <= 70 ~ paste0("20", ano),
      TRUE ~ ""
    )) %>% 
    mutate(sigla_processada = if_else(ano == "", sigla_nome, paste0(sigla_nome, "/", ano)))
}

.process_sigla_proposicao <- function(df) {
  library(tidyverse)
  library(stringr)
  
  df %>%
    mutate(sigla_processada = tolower(str_remove_all(sigla, " ")))
}

.remover_ano_sigla <- function(df) {
  library(tidyverse)
  library(stringr)
  
  df %>%
    mutate(sigla_processada = stringr::str_remove(sigla, "/.*") %>% tolower()) %>% 
    mutate(sigla_processada = str_remove_all(sigla_processada, " "))
}

.mapeia_citadas_sem_ano_para_id <- function(tweets, proposicoes) {
  proposicoes_sem_ano <- .remover_ano_sigla(proposicoes)
  tweets_proposicoes_sem_ano <- tweets %>%
    filter(!stringr::str_detect(sigla_processada, "/")) %>%
    left_join(proposicoes_sem_ano, by = "sigla_processada") %>%
    group_by(sigla_processada) %>%
    mutate(siglas_diferentes = n_distinct(sigla.y)) %>%
    ungroup() %>%
    mutate(ambigua = siglas_diferentes > 1) %>%
    filter(!is.na(id_proposicao), !ambigua)
  
  return(tweets_proposicoes_sem_ano)
}

processa_tweets <- function(tweets_datapath, proposicoes_datapath) {
  library(tidyverse)
  
  tweets <- read_csv(tweets_datapath)
  tweets <- .extract_sigla(tweets)
  tweets <- tweets %>%  
    filter(!is.na(sigla_processada))
  proposicoes <- read_csv(proposicoes_datapath) %>% 
    distinct(id_proposicao, sigla)
  proposicoes <- .process_sigla_proposicao(proposicoes)
  
  tweets_proposicoes_com_ano <- tweets %>%
    left_join(proposicoes, by = "sigla_processada") %>%
    filter(!is.na(id_proposicao))
  
  tweets_proposicoes_sem_ano <- .mapeia_citadas_sem_ano_para_id(tweets, proposicoes)
  
  tweets_com_mencoes <- tweets_proposicoes_com_ano %>%
    bind_rows(tweets_proposicoes_sem_ano) %>% 
    distinct(id_tweet, id_proposicao, .keep_all = TRUE) %>% 
    select(id_tweet, id_proposicao, username, text, date, url, reply_count, retweet_count, like_count, quote_count, sigla_processada)
  
  return(tweets_com_mencoes)
}
