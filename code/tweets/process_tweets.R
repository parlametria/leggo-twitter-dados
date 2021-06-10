#' @title Extrair sigla de texto do tweet
#' @description A partir do texto do tweet, cria uma sigla com a menção de alguma proposição no formato plxxx/yyyy
#' @param df Data frame com tweets com ao menos o campo `text`
#' @return Dataframe com a nova coluna `sigla_processada`
.extract_sigla <- function(df) {
  library(tidyverse)
  library(stringr)
  
  df %>%
    mutate(text_sem_links = str_remove_all(text, "(http[s]?://(?:[a-zA-Z]|[0-9]|[$-_@.&+]|[!*\\(\\),]|(?:%[0-9a-fA-F][0-9a-fA-F]))+)|(@[A-Za-z0-9_]+)")) %>%
    mutate(sigla = str_extract_all(tolower(text_sem_links), "(pl(n|s|p|)|pec|mp(v|)|pdl|pdc|prc) ?n?º? ?\\d*\\.?\\d+\\/?\\d*")) %>%
    unnest(sigla) %>% 
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

#' @title Processa sigla de proposição
#' @description Transforma a sigla de uma proposição no formato padrão para comparação
#' @param df Data frame com proposições com ao menos o campo `sigla`
#' @return Dataframe com a nova coluna `sigla_processada`
.process_sigla_proposicao <- function(df) {
  library(tidyverse)
  library(stringr)
  
  df %>%
    mutate(sigla_processada = tolower(str_remove_all(sigla, " "))) %>%
    mutate(sigla_processada = gsub("mpv", "mp", sigla_processada)) 
}

#' @title Remove ano da sigla
#' @description Remove o ano da sigla de uma proposição
#' @param df Data frame com proposições com ao menos o campo `sigla`
#' @return Dataframe com a nova coluna `sigla_processada`
.remover_ano_sigla <- function(df) {
  library(tidyverse)
  library(stringr)
  
  df %>%
    mutate(sigla_processada = stringr::str_remove(sigla, "/.*") %>% tolower()) %>% 
    mutate(sigla_processada = str_remove_all(sigla_processada, " "))
}

#' @title Mapeia siglas que não apresentam ano (i.e. PL32) entre tweets e proposições
#' @description Remove o ano das siglas para comparar com tweets que não mencionaram o ano
#' @param tweets Data frame com tweets com ao menos o campo `sigla_processada`
#' @param proposicoes Data frame com proposições com ao menos o campo `sigla`
#' @return Dataframe com tweets que mencionaram proposições sem usar o ano
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

#' @title Processa tweets
#' @description Realiza o processamento de tweets verificando menções à proposições
#' @param tweets_to_process_datapath Caminho para o csv de tweets a serem processados
#' @param proposicoes_datapath Caminho para o csv de todas as proposições
#' @return Dataframe com tweets que mencionaram proposições monitoradas
processa_tweets <- function(tweets_to_process_datapath, proposicoes_datapath) {
  library(tidyverse)
  
  tweets <- read_csv(tweets_to_process_datapath, col_types = cols(id_tweet = col_character()))
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
