DROP TABLE IF EXISTS tema;

CREATE TABLE IF NOT EXISTS "tema" (    
    "id" VARCHAR(32),
    "slug" VARCHAR(40),
    "nome" VARCHAR(40),
    PRIMARY KEY("id")
);
