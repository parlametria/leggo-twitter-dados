import argparse
import pandas as pd
import numpy as np
import re
import time
import nltk

from nltk.corpus import stopwords
from tqdm import tqdm

from gensim.models import KeyedVectors

from gensim.corpora import Dictionary
from gensim.models import TfidfModel

from sklearn.feature_extraction.text import CountVectorizer
from sklearn.metrics import euclidean_distances

from pyemd import emd

nltk.download('stopwords')
stop_words = set(stopwords.words("portuguese"))
stop_words.update(
    ['que', 'até', 'esse', 'de', 'do', 'essa', 'pro', 'pra', 'oi', 'lá']
)

pattern = "(?u)\\b[\\w-]+\\b"


def select_valid_words(text, stop_words=stop_words):
    """
        filter invalid words from the text
    """
    valid = []
    for string in text.split():
        try:  # search for embedding vector
            _ = W[vocab_dict[string]]
            valid.append(string)
        except BaseException:
            continue
    valid = [w for w in valid if w not in stop_words]
    return " ".join(valid)


def calc_wmd(text, lexicon, pattern=pattern):
    """
        Calculates the Word Mover's Distance between a piece of text and a
        lexicon, generating a score.
    """
    vect = CountVectorizer(
        token_pattern=pattern, strip_accents=None
    ).fit([lexicon, text])
    v_1, v_2 = vect.transform([lexicon, text])
    v_1 = v_1.toarray().ravel()
    v_2 = v_2.toarray().ravel()
    W_ = W[[vocab_dict[w] for w in vect.get_feature_names()]]
    D_ = euclidean_distances(W_)
    v_1 = v_1.astype(np.double)
    v_2 = v_2.astype(np.double)
    v_1 /= v_1.sum()
    v_2 /= v_2.sum()
    D_ = D_.astype(np.double)
    D_ /= D_.max()
    distance = emd(v_1, v_2, D_)
    return 1 - distance


WORD = re.compile(r'\w+')


def regTokenize(text):
    words = WORD.findall(text)
    return words


def tfidf_filter(doc_list, threshold):
    tokens = []
    print('tokenizing documents...')
    for doc in doc_list:
        # doc = clean_text(doc)
        tokenize = regTokenize(doc)
        tokens.append(tokenize)
    print('creating dictionary...')
    dct = Dictionary(tokens)
    corpus = [dct.doc2bow(line) for line in tokens]
    print(len(corpus))
    print('creating tf-idf model...')
    model = TfidfModel(corpus, id2word=dct)
    low_value_words = []
    medias = []
    for bow in corpus:
        medias.append(np.mean([value for _, value in model[bow]]))
        low_value_words += [id for id, value in model[bow]
                            if (value < threshold)]
    print(np.mean(medias))
    print(len(low_value_words))
    dct.filter_tokens(bad_ids=low_value_words)
    new_corpus = [dct.doc2bow(doc) for doc in tokens]
    print(len(new_corpus))
    corp = []
    for doc in new_corpus:
        corp.append([dct[id] for id, value in doc])
    return corp


def main(args):
    df = pd.read_csv(args.dataset)
    emoji_pattern = re.compile(
        "["
        u"\U0001F600-\U0001F64F"  # emoticons
        u"\U0001F300-\U0001F5FF"  # symbols & pictographs
        u"\U0001F680-\U0001F6FF"  # transport & map symbols
        u"\U0001F1E0-\U0001F1FF"  # flags (iOS)
        "]+", flags=re.UNICODE)

    df['clean_tweets'] = [
        re.sub(r"(?:\@|https?\://)\S+", '', str(x)) for x in df[args.col]
    ]
    MENTION_PATTERN = "(lei|Lei|nº|Nº|no)\s+([0-9]{1,2}(\.)*[0-9]{3})"
    df['clean_tweets'] = [
        re.sub("(\\d|\\W)+|\w*\d\w*", " ", str(x))
        if not re.search(re.compile(MENTION_PATTERN, re.IGNORECASE), str(x))
        else re.sub(
            re.compile(MENTION_PATTERN, re.IGNORECASE),
            r"\1_\2", str(x)
        )
        for x in df['clean_tweets']
    ]
    df['clean_tweets'] = [
        emoji_pattern.sub(r'', str(x)) for x in df['clean_tweets']
    ]
    df['clean_tweets'] = [
        re.sub("(\\d|\\W)+|\w*\d\w*", " ", str(x)) for x in df['clean_tweets']
    ]
    df['clean_tweets'] = [
        re.sub(r"\b[a-zA-Z]\b", "", str(x)) for x in df['clean_tweets']
    ]
    df['clean_tweets'] = [x.lower() for x in df['clean_tweets']]

    df['tf_idf'] = [' '.join(e)
                    for e in tfidf_filter(df['clean_tweets'], 0.05)]

    indexes = {}
    for i, row in df.iterrows():
        id_tweet = row['id_tweet']
        indexes[i] = id_tweet

    inicio = time.time()
    distancias = {
        'id_tweet_1': [],
        'rotulo_1': [],
        'id_tweet_2': [],
        'rotulo_2': [],
        'wmd': []
    }
    for i, row in tqdm(df.iterrows()):
        atual = select_valid_words(row['tf_idf'])
        for j, other_row in df.iterrows():
            if i != j:
                other = select_valid_words(other_row['tf_idf'])
                try:
                    distancia = calc_wmd(atual, other)
                except ValueError:
                    print(atual, other)
                    break
                distancias['id_tweet_1'].append(row['id_tweet'])
                distancias['rotulo_1'].append(row['rotulo'])
                distancias['id_tweet_2'].append(other_row['id_tweet'])
                distancias['rotulo_2'].append(other_row['rotulo'])
                distancias['wmd'].append(distancia)
    fim = time.time() - inicio
    print(f'Distancia entre pares calculadas em {fim}s')
    print('Criando e salvando csv')
    print(len(distancias['id_tweet_1']))
    print(len(distancias['id_tweet_2']))
    print(len(distancias['wmd']))

    novo = pd.DataFrame(distancias)
    novo.to_csv(args.out, index=False)

    print("executou")

    return


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--dataset",
        type=str, help='csv dataset'
    )
    parser.add_argument(
        "--col", default='removido', type=str, help='text column in csv file'
    )
    parser.add_argument(
        "--emb",
        default='./data/glove_w2v.txt',
        type=str,
        help='embedding file which can be loaded via gensim\'s KeyedVectors'
    )
    parser.add_argument(
        "--bin",
        default=0,
        type=int, help='embedding file is in the binary format or not'
    )
    parser.add_argument(
        "--out",
        default='./data/experimento_classificador/muitas_proposicoes/' +
                'distancias_teste_pec_6_2.csv',
        type=str, help='name of generated output'
    )

    args = parser.parse_args()
    args.bin = bool(args.bin)
    wv = KeyedVectors.load_word2vec_format(
        args.emb, binary=args.bin, unicode_errors="ignore"
    )
    wv.init_sims()
    fp = np.memmap(
        "embed.dat", dtype=np.double, mode='w+', shape=wv.vectors_norm.shape
    )
    fp[:] = wv.vectors_norm[:]

    with open("embed.vocab", "w") as f:
        for _, w in sorted((voc.index, word)
                           for word, voc in wv.vocab.items()):
            print(w, file=f)
    shape = (len(wv.index2word), wv.vector_size)
    del fp, wv

    W = np.memmap("embed.dat", dtype=np.double, mode="r+", shape=shape)
    with open("embed.vocab") as f:
        vocab_list = map(str.strip, f.readlines())
    vocab_dict = {w: k for k, w in enumerate(vocab_list)}
    main(args)
