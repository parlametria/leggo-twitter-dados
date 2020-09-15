DROP TABLE IF EXISTS agenda_proposicao;

CREATE TABLE IF NOT EXISTS "agenda_proposicao" (    
    "id_proposicao_leggo" VARCHAR(40),
    "id_agenda" VARCHAR(32),
    PRIMARY KEY("id_proposicao_leggo", "id_agenda"),
    FOREIGN KEY ("id_proposicao_leggo") REFERENCES proposicao ("id_proposicao_leggo") ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY ("id_agenda") REFERENCES agenda ("id") ON DELETE CASCADE ON UPDATE CASCADE
);
