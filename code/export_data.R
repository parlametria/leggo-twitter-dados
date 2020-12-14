library(tidyverse)

if(!require(optparse)){
  install.packages("optparse")
  suppressWarnings(suppressMessages(library(optparse)))
}

args = commandArgs(trailingOnly=TRUE)

message("Use --help para mais informações\n")

option_list = list(
  make_option(c("-u", "--url"), type="character", default="https://api.leggo.org.br", 
              help="url da api do parlametria [default= %default]"),
  make_option(c("-p", "--prop"), type="character", default="", 
              help="caminho para o csv de proposições [default= %default]")
)

opt_parser = OptionParser(option_list=option_list)
opt = parse_args(opt_parser)

api_url <- opt$url
proposicoes_datapath <- opt$prop

message("Recupera, processa e exporta dados de parlamentares, proposições e tweets")
source(here::here("code/parlamentares/export_parlamentares.R"))
source(here::here("code/proposicoes/export_proposicoes.R"))
source(here::here("code/tweets/export_tweets.R"))
source(here::here("code/relatorias/export_relatorias.R"))

message("Concluído!")
