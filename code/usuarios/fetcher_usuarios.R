library(tidyverse)

#'@title Baixa a planilha de usuários monitorados
#'@description A partir de uma url, baixa os usuários monitorados. 
#'Esta planilha deve ter pelo menos os campos 
#'username, nome, id_parlamentar_parlametria
fetch_usuarios <- function() {
  source(here::here("code/usuarios/constants_usuarios.R"))
  
  usuarios <- read_csv(URL_USERNAMES_TWITTER) %>% 
    mutate(casa = if_else(casa == "câmara", "camara", casa))
  
  return(usuarios)
}
