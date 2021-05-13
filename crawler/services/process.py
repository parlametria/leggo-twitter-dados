import pandas as pd

def process_by_username(datapath):
    """
    Faz processamento para cada linha do df gerado
    ----------
    datapath : str
        Caminho para o csv
    """

    df = pd.read_csv(datapath).head(10)     # TODO: Remover o .HEAD(10)
    for index, row in df.iterrows():
        print(row['username'])              # TODO: Substituir por chamada de função