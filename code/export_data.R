library(tidyverse)

message("Recupera, processa e exporta dados de parlamentares, proposições e tweets")

source(here::here("code/parlamentares/export_parlamentares.R"))
source(here::here("code/proposicoes/export_proposicoes.R"))
source(here::here("code/tweets/export_tweets.R"))
source(here::here("code/relatorias/export_relatorias.R"))

message("Concluído!")
