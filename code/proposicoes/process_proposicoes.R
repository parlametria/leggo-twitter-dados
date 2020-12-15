#' @title Processa temas
#' @description Realiza o processamento de temas, criando um slug sem acentos, espaços, etc.
#' @param tema Tema a ser processado
#' @return Tema processado, sem acentos ou espaços.
#' @example
#' tema_slug <- .processa_tema("Primeira infância; Educação")
.processa_tema <- function(tema) {
  tema_processado <- tema %>%
    tolower() %>%
    iconv(., from="UTF-8", to="ASCII//TRANSLIT") %>%
    gsub(x = ., " ", "-")
  
  return(tema_processado)
}

#' @title Processa proposições
#' @description Realiza o processamento das proposições provenientes de csv
#' (formato igual ao da planilha de uma agenda)
#' @param proposicoes_datapath Caminho para o csv de proposições
#' @return Dataframe com campos padronizados.
processa_proposicoes <- function(proposicoes_datapath) {
  library(tidyverse)
  
  proposicoes <- read_csv(proposicoes_datapath) %>%
    rowwise(.) %>% 
    mutate(id_proposicao = digest::digest(
      paste0(id_camara , " ", id_senado),
      algo = "md5",
      serialize = F
    )) %>%
    ungroup() %>% 
    mutate(temas_slug = .processa_tema(tema)) %>%
    mutate(casa = if_else(!is.na(id_camara), "camara", "senado")) %>% 
    mutate(interesse_slug = NA,
           interesse_nome = NA,
           casa_origem = NA) %>%
    select(id_proposicao,
           interesse_slug,
           interesse_nome,
           temas_nome = tema,
           temas_slug,
           sigla = proposicao,
           casa,
           casa_origem)
  
  return(proposicoes)
  
}