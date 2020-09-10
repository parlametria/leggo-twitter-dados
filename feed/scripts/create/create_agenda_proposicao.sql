DROP TABLE IF EXISTS agenda_proposicao;

CREATE TABLE IF NOT EXISTS "agenda_proposicao" (    
    "id_agenda" VARCHAR(32),
    "id_proposicao_leggo" VARCHAR(40),
    PRIMARY KEY("id_agenda", "id_proposicao_leggo"),
    FOREIGN KEY ("id_agenda") REFERENCES agenda ("id") ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY ("id_proposicao_leggo") REFERENCES proposicao ("id_proposicao_leggo") ON DELETE CASCADE ON UPDATE CASCADE
);
