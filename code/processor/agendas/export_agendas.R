.export_agendas <-
  function(output_folderpath = here::here("data/bd/")) {
    source(here::here("code/processor/agendas/processor_agendas.R"))
    
    message("Iniciando processamento e exportação dos dados de agendas...")
    message("Processando dados...")
    
    agendas <- process_agendas()
    
    message("Salvando dados...")
    write_csv(agendas,
              paste0(output_folderpath, "agendas.csv"))
    
    message("Feito!")
  }

.export_agendas_proposicoes <-
  function(output_folderpath = here::here("data/bd/")) {
    source(here::here("code/processor/agendas/processor_agendas.R"))
    
    message("Iniciando processamento e exportação dos dados de agendas e proposições...")
    message("Processando dados...")
    
    agendas <- process_agendas_proposicoes()
    
    message("Salvando dados...")
    write_csv(agendas,
              paste0(output_folderpath, "agendas_proposicoes.csv"))
    
    message("Feito!")
  }
