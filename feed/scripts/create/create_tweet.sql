DROP TABLE IF EXISTS tweet;

CREATE TABLE IF NOT EXISTS "tweet" (    
    "id_tweet" VARCHAR(32),
    "id_parlamentar_parlametria" VARCHAR(32),
    "username" VARCHAR(32),
    "created_at" DATE,
    "text" TEXT,
    "interactions" REAL,
    "url" TEXT,
    "outrage" REAL,
    "vagueness" REAL,
    "argumentation" REAL,
    "modalization" REAL,
    "valuation" REAL,
    "sentiment" REAL,
    "presupposition" REAL,
    PRIMARY KEY("id_tweet"),
    FOREIGN KEY ("id_parlamentar_parlametria") REFERENCES parlamentar ("id_parlamentar_parlametria") ON DELETE CASCADE ON UPDATE CASCADE
);
