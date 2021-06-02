library(tidyverse)

if(!require(optparse)){
  install.packages("optparse")
  suppressWarnings(suppressMessages(library(optparse)))
}

args = commandArgs(trailingOnly=TRUE)

message("Use --help para mais informações\n")

option_list = list(
  make_option(c("-o", "--out"), type="character", default=here::here("data/bd/"), 
              help="nome do diretório de saída [default= %default]", metavar="character")
) 

opt_parser = OptionParser(option_list=option_list)
opt = parse_args(opt_parser)

saida <- opt$out

source(here::here("code/processor/parlamentares/export_parlamentares.R"))
source(here::here("code/processor/proposicoes/export_proposicoes.R"))
source(here::here("code/processor/temas/export_temas.R"))
source(here::here("code/processor/agendas/export_agendas.R"))
source(here::here("code/processor/tweets/export_tweets.R"))

.export_parlamentares(saida)
.export_proposicoes(saida)
.export_temas(saida)
.export_temas_proposicoes(saida)
.export_agendas(saida)
.export_agendas_proposicoes(saida)
.export_tweets(saida)
.export_tweets_proposicoes(saida)
.export_tweets_raw_info(saida)

message("Concluído!")
