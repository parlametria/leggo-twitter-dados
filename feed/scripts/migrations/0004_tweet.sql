-- TWEET
BEGIN;

ALTER TABLE tweet
DROP COLUMN IF EXISTS "outrage";

COMMIT;