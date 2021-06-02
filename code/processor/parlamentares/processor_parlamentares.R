library(tidyverse)

#' @title Gera a coluna id_parlamentar_parlametria
#' @description Recebe um dataframe contendo as colunas 'casa' e 'id_parlamentar' e
#' retorna o dataframe com nova colunaid_parlamentar_parlametria
#' @param df Dataframe contendo as colunas 'casa' e 'id_parlamentar'
#' @return Dataframe com nova coluna id_parlamentar_parlametria
.generate_id_parlamentar_parlametria <- function(df) {
  df <- df %>%
    mutate(casa_enum = if_else(casa == "camara", 1, 2)) %>%
    mutate(id_parlamentar_parlametria = if_else(
      !is.na(id_parlamentar),
      paste0(casa_enum, id_parlamentar),
      NA_character_
    )) %>%
    select(-casa_enum)
  
  return(df)
}

#' @title Processa os dados dos parlamentares no formato do banco.
#' @description Retorna os dados dos parlamentares processados.
#' @param parlamentares_datapath Caminho para o csv dos parlamentares
#' @return Dataframe com informações processada dos parlamentares.
process_parlamentares <-
  function(parlamentares_datapath = here::here("data/parlamentares/parlamentares.csv")) {
    parlamentares <-
      read_csv(parlamentares_datapath, col_types = cols(.default = "c"))
    
    parlamentares <- parlamentares %>%
      mutate(id_parlamentar = substring(id_parlamentar_parlametria, 2)) %>% 
      select(id_parlamentar_parlametria, id_parlamentar, casa) %>%
      distinct()
    
    return(parlamentares)
  }
