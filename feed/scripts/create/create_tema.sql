DROP TABLE IF EXISTS tema;

CREATE TABLE IF NOT EXISTS "tema" (    
    "id" VARCHAR(32),
    "nome" VARCHAR(80),
    "slug" VARCHAR(80),
    PRIMARY KEY("id")
);
