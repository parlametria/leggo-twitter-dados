# Módulo Parlamentares

Este módulo é responsável por baixar e processar os dados dos parlamentares utilizados pelo Leggo Twitter. 

Para exportar esses dados, é necessário estar neste diretório e executar o script abaixo:

```
  Rscript export_parlamentares.R -o <output_filepath>
```

O argumento **<output_filepath>** é o caminho destino do csv. O valor default é `data/parlamentares/parlamentares.csv`