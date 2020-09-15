DROP TABLE IF EXISTS proposicao;

CREATE TABLE IF NOT EXISTS "proposicao" (
    "id_proposicao_leggo" VARCHAR(40),
    "casa" VARCHAR(20),
    "casa_origem" VARCHAR(20),
    "sigla" VARCHAR(40),
    PRIMARY KEY("id_proposicao_leggo")
);
