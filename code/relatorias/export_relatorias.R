library(tidyverse)
source(here::here("code/relatorias/fetcher_relatorias.R"))

if(!require(optparse)){
  install.packages("optparse")
  suppressWarnings(suppressMessages(library(optparse)))
}

args = commandArgs(trailingOnly=TRUE)

message("Use --help para mais informações\n")

option_list = list(
  make_option(c("-o", "--out"), type="character", default=here::here("data/relatorias/relatorias.csv"), 
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

export_relatorias <- function(api_url = "https://api.parlametria.org.br",
                              saida = here::here("data/relatorias/relatorias.csv")) {
  message("Iniciando processamento de relatorias...")
  message("Baixando dados...")
  relatorias <- fetch_relatores_proposicoes_todas_agendas(api_url)
  
  message(paste0("Salvando o resultado em ", saida))
  write_csv(relatorias, saida)
  
  message("Concluído!")
}

if (!interactive()) {
  export_relatorias(api_url, saida)
}


