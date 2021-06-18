library(tidyverse)

processa_usuarios_com_interacao <-
  function(filepath = "reports/interacoes_katia_abreu/data/tweets_to_process.csv") {
    interacoes_katia_abreu <-
      read_csv(filepath,
               col_types = cols(id_tweet = "c")) %>%
      mutate(mention = strsplit(mentions, ";")) %>%
      unnest(mention) %>%
      filter(!is.na(mention), mention != "") %>%
      mutate(mention = paste0("@", tolower(mention))) %>%
      select(-mentions) %>% 
      mutate(date =  format(as.Date(date), "%d/%m/%Y"))
    return(interacoes_katia_abreu)
  }
