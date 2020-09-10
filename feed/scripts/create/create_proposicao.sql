DROP TABLE IF EXISTS proposicao;

CREATE TABLE IF NOT EXISTS "proposicao" (
    "id_proposicao_leggo" VARCHAR(40),
    "sigla" VARCHAR(10),
    "casa" VARCHAR(10),
    "casa_origem" VARCHAR(10),
    PRIMARY KEY("id_proposicao_leggo")
);
