DROP TABLE IF EXISTS tema;

CREATE TABLE IF NOT EXISTS "tema" (    
    "id" VARCHAR(32),
    "nome" VARCHAR(300),
    "slug" VARCHAR(300),
    PRIMARY KEY("id")
);
