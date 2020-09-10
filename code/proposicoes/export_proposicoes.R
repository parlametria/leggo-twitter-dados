library(tidyverse)
source(here::here("code/proposicoes/fetcher_proposicoes.R"))

if(!require(optparse)){
  install.packages("optparse")
  suppressWarnings(suppressMessages(library(optparse)))
}

args = commandArgs(trailingOnly=TRUE)

message("Use --help para mais informações\n")

option_list = list(
  make_option(c("-o", "--out"), type="character", default=here::here("data/proposicoes/proposicoes.csv"), 
              help="nome do arquivo de saída [default= %default]", metavar="character")
) 

opt_parser = OptionParser(option_list=option_list)
opt = parse_args(opt_parser)

saida <- opt$out

message("Iniciando processamento...")
message("Baixando dados...")
proposicoes <- fetch_proposicoes_by_agenda()

message(paste0("Salvando o resultado em ", saida))
write_csv(proposicoes, saida)

message("Concluído!")
