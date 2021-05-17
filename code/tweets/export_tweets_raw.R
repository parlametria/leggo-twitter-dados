library(tidyverse)
source(here::here("code/tweets/fetcher_tweets.R"))

if(!require(optparse)){
  install.packages("optparse")
  suppressWarnings(suppressMessages(library(optparse)))
}

args = commandArgs(trailingOnly=TRUE)

message("Use --help para mais informações\n")

option_list = list(
  make_option(c("-o", "--out"), type="character", default=here::here("data/tweets/tweets_raw.csv"), 
              help="nome do arquivo de saída [default= %default]", metavar="character")
) 

opt_parser = OptionParser(option_list=option_list)
opt = parse_args(opt_parser)

saida <- opt$out

export_tweets <- function(saida = here::here("data/tweets/tweets_raw.csv")) {
  message("Recuperando tweets Raw do banco de dados...")
  tweets <- fetch_tweets_raw()
  
  message(paste0("Salvando o resultado em ", saida))
  write_csv(tweets, saida)
  
  message("Concluído!")
}

if (!interactive()) {
  export_tweets(saida)
}
