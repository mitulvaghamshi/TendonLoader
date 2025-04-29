-- 1: Create Table
CREATE TABLE IF NOT EXISTS "User" (
    "id"       INTEGER NOT NULL CONSTRAINT "PK_User" PRIMARY KEY AUTOINCREMENT,
    "username" TEXT    NOT NULL,
    "password" TEXT    NOT NULL
);

-- 2: Select All
SELECT "id", "username", "password"
FROM   "User";

-- 3: Select by id
SELECT "id", "username", "password"
FROM   "User"
WHERE  "id" = (:id);

-- 4 Search
SELECT "id", "username", "password"
FROM   "User"
WHERE  "username" LIKE '%' || (:q) || '%';

-- 5 Insert
INSERT INTO "User"
            ("username", "password")
VALUES      (:username, :password);

-- 6 Update
UPDATE "User"
SET
       "username" = (:username),
       "password" = (:password)
WHERE  "id"       = (:id);

-- 7 Delete
DELETE FROM "User"
WHERE       "id" = (:id);

-- 8 Search
SELECT "id", "username", "password"
FROM   "User"
WHERE  "username" = (:username)
AND    "password" = (:password);
