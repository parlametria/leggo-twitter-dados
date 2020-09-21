DROP TABLE IF EXISTS agenda;

CREATE TABLE IF NOT EXISTS "agenda" (    
    "id" VARCHAR(32),
    "nome" VARCHAR(32),
    "slug" VARCHAR(32),
    PRIMARY KEY("id")
);
