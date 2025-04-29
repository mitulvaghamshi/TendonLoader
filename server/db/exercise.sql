-- 1: Create Table
CREATE TABLE IF NOT EXISTS "Exercise" (
    "id"              INTEGER NOT NULL CONSTRAINT "PK_Exercise" PRIMARY KEY AUTOINCREMENT,
    "completed"       INTEGER NOT NULL,
    "data"            TEXT    NOT NULL,
    "datetime"        TEXT    NOT NULL,
    "mvc_value"       REAL        NULL,
    "pain_score"      REAL    NOT NULL,
    "prescription_id" INTEGER     NULL,
    "progressor_id"   TEXT    NOT NULL,
    "tolerable"       TEXT    NOT NULL,
    "user_id"         INTEGER NOT NULL
);

-- 2: Select All
SELECT "id", "completed", "data", "datetime", "mvc_value", "pain_score", "prescription_id", "progressor_id", "tolerable", "user_id"
FROM   "Exercise";

-- 3: Select by id
SELECT "id", "completed", "data", "datetime", "mvc_value", "pain_score", "prescription_id", "progressor_id", "tolerable", "user_id"
FROM   "Exercise"
WHERE  "id" = (:id);

-- 4 Search
SELECT "id", "completed", "data", "datetime", "mvc_value", "pain_score", "prescription_id", "progressor_id", "tolerable", "user_id"
FROM   "Exercise"
WHERE  "id"              LIKE '%' || (:q) || '%'
OR     "user_id"         LIKE '%' || (:q) || '%'
OR     "prescription_id" LIKE '%' || (:q) || '%'
OR     "datetime"        LIKE '%' || (:q) || '%';

-- 5 Insert
INSERT INTO "Exercise"
            ("completed", "data", "datetime", "mvc_value", "pain_score", "prescription_id", "progressor_id", "tolerable", "user_id")
VALUES      (:completed, :data, :datetime, :mvc_value, :pain_score, :prescription_id, :progressor_id, :tolerable, :user_id);

-- 6 Update
UPDATE "Exercise"
SET
        "completed"       = (:completed),
        "data"            = (:data),
        "datetime"        = (:datetime),
        "mvc_value"       = (:mvc_value),
        "pain_score"      = (:pain_score),
        "prescription_id" = (:prescription_id),
        "progressor_id"   = (:progressor_id),
        "tolerable"       = (:tolerable),
        "user_id"         = (:user_id)
WHERE   "id"              = (:id);

-- 7 Delete
DELETE FROM "Exercise"
WHERE       "id" = (:id);
