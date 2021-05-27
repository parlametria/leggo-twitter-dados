library(tidyverse)
source(here::here("code/usuarios/fetcher_usuarios.R"))

if(!require(optparse)){
  install.packages("optparse")
  suppressWarnings(suppressMessages(library(optparse)))
}

args = commandArgs(trailingOnly=TRUE)

message("Use --help para mais informações\n")

option_list = list(
  make_option(c("-o", "--out"), type="character", default=here::here("data/usuarios/usuarios.csv"), 
              help="nome do arquivo de saída [default= %default]", metavar="character")
  
) 

opt_parser = OptionParser(option_list=option_list)
opt = parse_args(opt_parser)

saida <- opt$out


export_usuarios <- function(saida = here::here("data/usuarios/usuarios.csv")) {
  message("Iniciando processamento de usuários monitorados")
  message("Baixando dados...")
  usuarios <- fetch_usuarios()
  
  message(paste0("Salvando o resultado em ", saida))
  write_csv(usuarios, saida)
  
  message("Concluído!")
}

if (!interactive()) {
  export_usuarios(saida)
}

