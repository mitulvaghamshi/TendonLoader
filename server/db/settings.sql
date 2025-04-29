-- 1: Create Table
CREATE TABLE IF NOT EXISTS "Settings" (
    "id"                    INTEGER NOT NULL CONSTRAINT "PK_Settings" PRIMARY KEY AUTOINCREMENT,
    "auto_upload"           INTEGER NOT NULL,
    "dark_mode"             INTEGER NOT NULL,
    "editable_prescription" INTEGER NOT NULL,
    "graph_scale"           REAL    NOT NULL,
    "prescription_id"       INTEGER     NULL,
    "user_id"               INTEGER NOT NULL
);

-- 2: Select All
SELECT "id", "auto_upload", "dark_mode", "editable_prescription", "graph_scale", "prescription_id", "user_id"
FROM   "Settings";

-- 3: Select by id
SELECT "id", "auto_upload", "dark_mode", "editable_prescription", "graph_scale", "prescription_id", "user_id"
FROM   "Settings"
WHERE  "id" = (:id);

-- 4 Search
SELECT "id", "auto_upload", "dark_mode", "editable_prescription", "graph_scale", "prescription_id", "user_id"
FROM   "Settings"
WHERE  "user_id" = (:q);

-- 5 Insert
INSERT INTO "Settings"
            ("auto_upload", "dark_mode", "editable_prescription", "graph_scale", "prescription_id", "user_id")
VALUES      (:auto_upload, :dark_mode, :editable_prescription, :graph_scale, :prescription_id, :user_id);

-- 6 Update
UPDATE "Settings"
SET
       "auto_upload"           = (:auto_upload),
       "dark_mode"             = (:dark_mode),
       "editable_prescription" = (:editable_prescription),
       "graph_scale"           = (:graph_scale),
       "prescription_id"       = (:prescription_id),
       "user_id"               = (:user_id)
WHERE  "id"                    = (:id);

-- 7 Delete
DELETE FROM "Settings"
WHERE       "id" = (:id);
