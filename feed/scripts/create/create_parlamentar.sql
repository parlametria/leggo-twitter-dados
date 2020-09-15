DROP TABLE IF EXISTS parlamentar;

CREATE TABLE IF NOT EXISTS "parlamentar" (    
    "id_parlamentar_parlametria" VARCHAR(32),
    "id_parlamentar" VARCHAR(32),
    "casa" VARCHAR(10),
    PRIMARY KEY("id_parlamentar_parlametria")
);
