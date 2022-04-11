library(tidyverse)

if(!require(optparse)){
  install.packages("optparse")
  suppressWarnings(suppressMessages(library(optparse)))
}

args = commandArgs(trailingOnly=TRUE)

message("Use --help para mais informações\n")

option_list = list(
  make_option(c("-o", "--out"), type="character", default=here::here("data/proposicoes/proposicoes.csv"), 
              help="nome do arquivo de saída [default= %default]", metavar="character"),
  make_option(c("-u", "--url"), type="character", default="https://api.parlametria.org.br", 
              help="url da api do parlametria [default= %default]", metavar="character"),
  make_option(c("-p", "--prop"), type="character", default=NULL, 
              help="caminho para o csv de proposições [default= %default]")
) 

opt_parser = OptionParser(option_list=option_list)
opt = parse_args(opt_parser)

saida <- opt$out
api_url <- opt$url
proposicoes_datapath <- opt$prop

export_proposicoes <- function(api_url = "https://api.parlametria.org.br", 
                               proposicoes_datapath = NULL,
                               saida = here::here("data/proposicoes/proposicoes.csv")) {
  message("Iniciando processamento de proposições...")
  if (is.null(proposicoes_datapath) || proposicoes_datapath == "") {
    message("Baixando dados...")
    source(here::here("code/proposicoes/fetcher_proposicoes.R"))
    proposicoes <- fetch_proposicoes_todas_agendas(api_url = api_url)
  } else {
    source(here::here("code/proposicoes/process_proposicoes.R"))
    proposicoes <- processa_proposicoes(proposicoes_datapath)
  }
  
  message(paste0("Salvando o resultado em ", saida))
  write_csv(proposicoes, saida)
  
  message("Concluído!")
}

if (!interactive()) {
  export_proposicoes(api_url, proposicoes_datapath, saida)
}

