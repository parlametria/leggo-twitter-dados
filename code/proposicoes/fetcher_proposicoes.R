#' @title Baixa as proposições por agenda
#' @description Recebe uma agenda e retorna as proposições monitoradas pelo
#' Leggo com essa agenda.
#' @param agenda Agenda de interesse (obs: sem acentos e espaços,
#' ex: reforma-tributaria)
#' @return Dataframe com informações das proposições de uma agenda.
fetch_proposicoes_by_agenda <-
  function(agenda = "congresso-remoto") {
    library(tidyverse)

    print(paste0("Baixando proposições da agenda ", agenda, "..."))
    
    url <-
      paste0("https://api.leggo.org.br/proposicoes/?interesse=",
             agenda)
    
    df <-
      RCurl::getURL(url, .encoding = "UTF-8") %>%
      jsonlite::fromJSON()
    
    proposicoes <- tibble(
      id_proposicao = df$id_leggo,
      interesse = df$interesse,
      etapas = df$etapas
    ) %>%
      unnest(cols = c(interesse, etapas)) %>%
      unnest(cols = c(temas, slug_temas))
    
    proposicoes <- proposicoes %>%
      select(
        id_proposicao,
        interesse_slug = interesse,
        interesse_nome = nome_interesse,
        temas_nome = temas,
        temas_slug = slug_temas,
        sigla,
        casa,
        casa_origem
      )
    
    return(proposicoes)
  }

#' @title Baixa as proposições para todas as agendas do Leggo Proposições
#' @description Retorna as proposições monitoradas pelas agendas do Leggo
#' @return Dataframe com informações das proposições.
fetch_proposicoes_todas_agendas <- function() {
  library(tidyverse)
  
  agendas <- RCurl::getURL("https://api.leggo.org.br/interesses") %>% 
    jsonlite::fromJSON() %>% 
    select(interesse)
  
  proposicoes <- purrr::map_df(agendas$interesse, 
                               ~ fetch_proposicoes_by_agenda(.x))
  return(proposicoes)
}
