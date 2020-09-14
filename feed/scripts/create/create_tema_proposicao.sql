DROP TABLE IF EXISTS tema_proposicao;

CREATE TABLE IF NOT EXISTS "tema_proposicao" (    
    "id_proposicao_leggo" VARCHAR(40),
    "id_tema" VARCHAR(32),
    PRIMARY KEY("id_proposicao_leggo", "id_tema"),
    FOREIGN KEY ("id_proposicao_leggo") REFERENCES proposicao ("id_proposicao_leggo") ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY ("id_tema") REFERENCES tema ("id") ON DELETE CASCADE ON UPDATE CASCADE
);
