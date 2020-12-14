#' @title Baixa as proposições por agenda
#' @description Recebe uma agenda e retorna as proposições monitoradas pelo
#' Leggo com essa agenda.
#' @param agenda Agenda de interesse (obs: sem acentos e espaços,
#' ex: reforma-tributaria)
#' @param api_url URL da api do Parlametria. (Não incluir a '/' ao final do domínio).
#' @return Dataframe com informações das proposições de uma agenda.
fetch_proposicoes_by_agenda <-
  function(agenda = "congresso-remoto",
           api_url = "https://dev.api.leggo.org.br") {
    library(tidyverse)

    print(paste0("Baixando proposições da agenda ", agenda, "..."))
    
    url <-
      paste0(api_url, 
             "/proposicoes/?interesse=",
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
#' @param api_url URL da api do Parlametria. (Não incluir a '/' ao final do domínio).
#' @return Dataframe com informações das proposições.
fetch_proposicoes_todas_agendas <- function(api_url = "https://dev.api.leggo.org.br") {
  library(tidyverse)
  
  agendas <- RCurl::getURL(paste0(api_url, "/interesses")) %>% 
    jsonlite::fromJSON() %>% 
    select(interesse)
  
  proposicoes <- purrr::map_df(agendas$interesse, 
                               ~ fetch_proposicoes_by_agenda(.x, api_url))
  return(proposicoes)
}
