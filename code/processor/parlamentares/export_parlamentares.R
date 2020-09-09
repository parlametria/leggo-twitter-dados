.export_parlamentares <-
  function(output_folderpath = here::here("data/bd/")) {
    source(here::here("code/processor/parlamentares/processor_parlamentares.R"))
    
    message("Iniciando processamento e exportação dos dados de parlamentares...")
    message("Processando dados...")
    
    parlamentares <- process_parlamentares()
    
    message("Salvando dados...")
    write_csv(parlamentares,
              paste0(output_folderpath, "parlamentares/parlamentares.csv"))
    
    message("Feito!")
  }
