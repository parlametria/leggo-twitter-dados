library(tidyverse)
source(here::here("code/tweets/process_tweets.R"))

if(!require(optparse)){
  install.packages("optparse")
  suppressWarnings(suppressMessages(library(optparse)))
}

args = commandArgs(trailingOnly=TRUE)

message("Use --help para mais informações\n")

option_list = list(
  make_option(c("-o", "--out"), type="character", default=here::here("data/tweets/tweets.csv"), 
              help="nome do arquivo de saída [default= %default]", metavar="character"),
  make_option(c("-u", "--url"), type="character", default="https://dev.api.parlametria.org.br", 
              help="url da api do parlametria [default= %default]", metavar="character"),
  make_option(c("-p", "--prop"), type="character", default=NULL, 
              help="caminho para o csv de proposições [default= %default]")
) 

opt_parser = OptionParser(option_list=option_list)
opt = parse_args(opt_parser)

saida <- opt$out

export_tweets <- function(tweets_to_process_datapath = here::here("data/tweets/tweets_to_process.csv"),
                          proposicoes_datapath = here::here("data/proposicoes/proposicoes.csv"),
                          tweets_processados_datapath = here::here("data/tweets/tweets_processados.csv"),
                          saida = here::here("data/tweets/tweets.csv")) {
  message("Iniciando processamento de tweets...")
  message("Recuperando tweets...")
  tweets_com_mencoes <- processa_tweets(tweets_to_process_datapath, proposicoes_datapath)
  
  tweets_recem_processados <-
    read_csv(tweets_to_process_datapath,
             col_types = cols(id_tweet = col_character()))
  tweets_processados <-
    read_csv(tweets_processados_datapath,
             col_types = cols(id_tweet = col_character())) %>%
    bind_rows(tweets_recem_processados) %>%
    distinct(id_tweet)
  
  message(paste0("Salvando ids de tweets processados em ", tweets_processados_datapath))
  write_csv(tweets_processados, tweets_processados_datapath)
  
  tweets <-
    read_csv(saida,
             col_types = cols(id_tweet = col_character(),
                              id_proposicao = col_character(),
                              username = col_character(),
                              text = col_character(),
                              date = col_datetime(),
                              url = col_character(),
                              sigla_processada = col_character(),
                              .default = col_number())) %>% 
    bind_rows(tweets_com_mencoes) %>%
    distinct(id_tweet, id_proposicao, .keep_all = TRUE)
  
  message(paste0("Salvando o resultado em ", saida))
  write_csv(tweets, saida)
  
  message("Concluído!")
}

if (!interactive()) {
  export_tweets(saida = saida)
}
