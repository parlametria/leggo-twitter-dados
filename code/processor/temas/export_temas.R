.export_temas <-
  function(output_folderpath = here::here("data/bd/")) {
    source(here::here("code/processor/temas/processor_temas.R"))
    
    message("Iniciando processamento e exportação dos dados de temas...")
    message("Processando dados...")
    
    temas <- process_temas()
    
    message("Salvando dados...")
    write_csv(temas,
              paste0(output_folderpath, "temas.csv"))
    
    message("Feito!")
  }

.export_temas_proposicoes <-
  function(output_folderpath = here::here("data/bd/")) {
    source(here::here("code/processor/temas/processor_temas.R"))
    
    message("Iniciando processamento e exportação dos dados de temas e proposições...")
    message("Processando dados...")
    
    temas <- process_temas_proposicoes()
    
    message("Salvando dados...")
    write_csv(temas,
              paste0(output_folderpath, "temas_proposicoes.csv"))
    
    message("Feito!")
  }
