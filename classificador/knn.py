from os import system
from os import listdir
from os.path import isfile, exists
import numpy as np
import pandas as pd
from tqdm import tqdm


def calculate_distances(path, file_list):
    for filename in tqdm(file_list):
        filepath = path + filename
        if isfile(filepath) and not exists(filepath):
            parts = filename.split('_')
            pl = parts[0]
            number = parts[1]
            base_type = parts[2].split('.')[0]
            print(pl, number, base_type)
            outfile = 'distancias/distancias_' + base_type + '_' + \
                pl + '_' + number + '.csv'
            if not exists(outfile):
                system('python src/wmd/wmd.py --dataset ' + path +
                       filename + ' --out ' + path + outfile)


def create_distances_dict(path):
    distances_path = path + '/distancias'
    files = [e for e in listdir(distances_path)
             if e.split('_')[0] == 'distancias']
    distances_dict = {}
    for filename in files:
        parts = filename.split('_')
        base_type = parts[1]
        pl = parts[2]
        number = parts[3].split('.')[0]
        if (pl + ' ' + number) not in distances_dict:
            distances_dict[pl + ' ' + number] = {base_type: filename}
        else:
            distances_dict[pl + ' ' + number][base_type] = filename
    return distances_dict


def mode(x):
    vals, counts = np.unique(x, return_counts=True)
    index = np.argmax(counts)
    return vals[index]


def stats(df):
    tp_rows = df.apply(lambda x: (x['rotulo_1'] == 1) & (x['previsto'] == 1),
                       axis=1)
    tp = len(tp_rows[tp_rows].index)

    fp_rows = df.apply(lambda x: (x['rotulo_1'] == 0) & (x['previsto'] == 1),
                       axis=1)
    fp = len(fp_rows[fp_rows].index)

    tn_rows = df.apply(lambda x: (x['rotulo_1'] == 0) & (x['previsto'] == 0),
                       axis=1)
    tn = len(tn_rows[tn_rows].index)

    fn_rows = df.apply(lambda x: (x['rotulo_1'] == 1) & (x['previsto'] == 0),
                       axis=1)
    fn = len(fn_rows[fn_rows].index)

    return (tp, fp, fn, tn)


def evaluate(df):
    tp, fp, fn, tn = stats(df)
    precisao = tp / (tp + fp) if (tp + fp) != 0 else 0
    recall = tp / (tp + fn) if (tp + fn) != 0 else 0
    acuracia = (tp + tn) / (tp + tn + fp + fn)
    f1 = (2 * ((precisao * recall) / (precisao + recall))
          if (precisao + recall) != 0 else 0)
    fpr = fp / (fp + tn)
    metricas = {
        'precisao': precisao,
        'recall': recall,
        'acuracia': acuracia,
        'f1': f1,
        'fpr': fpr
    }
    return metricas


def classify_with_knn(path_csvs, distances_dict):
    resultado = {}
    best_results = {}
    dfs = {}
    final = {}
    for pl, caminhos in distances_dict.items():
        vizinhos = [x for x in range(1, 30, 2)]
        distancias = pd.read_csv(path_csvs + 'distancias/' +
                                 caminhos['treino'])
        print(f'Estimando k para {pl}')
        metricas_avaliacao = {}
        for k in vizinhos:
            tops = (distancias.groupby('id_tweet_1')
                    .apply(lambda x: x.nlargest(k, ['wmd']))
                    .reset_index(drop=True))
            tops['previsto'] = (tops.groupby('id_tweet_1')['rotulo_2']
                                .transform(mode))
            previsoes = (tops[['id_tweet_1', 'rotulo_1', 'previsto']]
                         .drop_duplicates().reset_index(drop=True))
            resultados = evaluate(previsoes)
            metricas_avaliacao[k] = resultados
        resultado[pl] = metricas_avaliacao
        best_k, metrics = max(metricas_avaliacao.items(),
                              key=lambda x: x[1]['f1'])
        best_results[pl] = (best_k, metrics)
        f1 = metrics['f1']
        print(f'Para k = {best_k}, f1 = {f1}')
        teste = pd.read_csv(path_csvs + 'distancias/' + caminhos['teste'])
        teste_tops = (teste.groupby('id_tweet_1')
                      .apply(lambda x: x.nlargest(best_k, ['wmd']))
                      .reset_index(drop=True))
        teste_tops['previsto'] = (teste_tops.groupby('id_tweet_1')['rotulo_2']
                                  .transform(mode))
        previsoes_teste = (teste_tops[['id_tweet_1', 'rotulo_1', 'previsto']]
                           .drop_duplicates().reset_index(drop=True))
        dfs[pl] = previsoes_teste
        resultados_teste = evaluate(dfs[pl])
        final[pl] = resultados_teste
        print(resultados_teste)

        return (resultado, best_results, dfs, final)


if __name__ == "__main__":
    path_csvs = './src/data/experimento_classificador/muitas_proposicoes' + \
       '/novos_dados/bases/'
    file_list = listdir(path_csvs)
    calculate_distances(path_csvs, file_list)
    distances_dict = create_distances_dict(path_csvs)
    resultado, best_results, dfs, final = classify_with_knn(path_csvs,
                                                            distances_dict)
