# Módulo Relatorias

Este módulo é responsável por baixar e processar os dados de relatorias das proposições monitoradas pelo Leggo.

Para exportar esses dados, é necessário estar neste diretório e executar o script abaixo:

```
  Rscript export_relatorias.R -o <output_filepath>
```

O argumento **<output_filepath>** é o caminho destino do csv. O valor default é `data/relatorias/relatorias.csv`