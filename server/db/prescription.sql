-- 1: Create Table
CREATE TABLE IF NOT EXISTS "Prescription" (
    "id"           INTEGER NOT NULL CONSTRAINT "PK_Prescription" PRIMARY KEY AUTOINCREMENT,
    "reps"         INTEGER NOT NULL,
    "sets"         INTEGER NOT NULL,
    "set_rest"     INTEGER NOT NULL,
    "hold_time"    INTEGER NOT NULL,
    "rest_time"    INTEGER NOT NULL,
    "mvc_duration" INTEGER NOT NULL,
    "target_load"  REAL    NOT NULL
);

-- 2: Select All
SELECT "id", "reps", "sets", "set_rest", "hold_time", "rest_time", "mvc_duration", "target_load"
FROM   "Prescription";

-- 3: Select by id
SELECT "id", "reps", "sets", "set_rest", "hold_time", "rest_time", "mvc_duration", "target_load"
FROM   "Prescription"
WHERE  "id" = (:id);

-- 4 Search
SELECT "id", "reps", "sets", "set_rest", "hold_time", "rest_time", "mvc_duration", "target_load"
FROM   "Prescription"
WHERE  "id" LIKE '%' || (:q) || '%';

-- 5 Insert
INSERT INTO "Prescription"
            ("reps", "sets", "set_rest", "hold_time", "rest_time", "mvc_duration", "target_load")
VALUES      (:reps, :sets, :set_rest, :hold_time, :rest_time, :mvc_duration, :target_load);

-- 6 Update
UPDATE "Prescription"
SET
       "reps"         = (:reps),
       "sets"         = (:sets),
       "set_rest"     = (:set_rest),
       "hold_time"    = (:hold_time),
       "rest_time"    = (:rest_time),
       "mvc_duration" = (:mvc_duration),
       "target_load"  = (:target_load)
WHERE  "id"           = (:id);

-- 7 Delete
DELETE FROM "Prescription"
WHERE       "id" = (:id);
