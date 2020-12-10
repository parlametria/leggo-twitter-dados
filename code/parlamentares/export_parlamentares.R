library(tidyverse)
source(here::here("code/parlamentares/fetcher_parlamentares.R"))

if(!require(optparse)){
  install.packages("optparse")
  suppressWarnings(suppressMessages(library(optparse)))
}

args = commandArgs(trailingOnly=TRUE)

message("Use --help para mais informações\n")

option_list = list(
  make_option(c("-o", "--out"), type="character", default=here::here("data/parlamentares/parlamentares.csv"), 
              help="nome do arquivo de saída [default= %default]", metavar="character"),
  make_option(c("-u", "--url"), type="character", default="https://dev.api.leggo.org.br", 
              help="url da api do parlametria [default= %default]", metavar="character")
) 

opt_parser = OptionParser(option_list=option_list)
opt = parse_args(opt_parser)

saida <- opt$out
api_url <- opt$url


export_parlamentares <- function(api_url = "https://dev.api.leggo.org.br", 
                                 saida = here::here("data/parlamentares/parlamentares.csv")) {
  message("Iniciando processamento de parlamentares...")
  message("Baixando dados...")
  parlamentares <- fetch_parlamentares_em_exercicio(api_url)
  
  message(paste0("Salvando o resultado em ", saida))
  write_csv(parlamentares, saida)
  
  message("Concluído!")
}

if (!interactive()) {
  export_parlamentares(api_url, saida)
}

