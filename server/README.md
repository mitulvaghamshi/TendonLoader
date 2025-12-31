# Tendon Loader API

A server app built using [Shelf](https://pub.dev/packages/shelf).

## Running with the Dart SDK

Run with the [Dart SDK](https://dart.dev/get-dart).

### For in-memory empty database:

```ps
$ dart -DPORT=3001 -DUSER_SQL_PATH=db/user.sql -DSETTINGS_SQL_PATH=db/settings.sql -DEXERCISE_SQL_PATH=db/exercise.sql -DPRESCRIPTION_SQL_PATH=db/prescription.sql bin/server.dart
$ Server listening on port 3001...
```

### For database file:

```ps
$ dart -DPORT=3001 -DUSER_SQL_PATH=db/user.sql -DSETTINGS_SQL_PATH=db/settings.sql -DEXERCISE_SQL_PATH=db/exercise.sql -DPRESCRIPTION_SQL_PATH=db/prescription.sql -DDB_PATH=db/tendonloader.db bin/server.dart
$ Server listening on port 3001...
```

### Test from a second terminal:

```ps
# GET: Root
$ curl -X GET http://localhost:3001

# GET: Select all items
$ curl -X GET http://localhost:3001/path

# GET: Select one item by id
$ curl -X GET http://localhost:3001/path/1

# GET: Search by given 'term'
$ curl -X GET http://localhost:3001/path/search/term

# POST: Insert a record
$ curl -X POST http://localhost:3001/path -H 'Content-Type: application/json' -d '{}'

# PATCH: Update a record by given id
$ curl -X PATCH http://localhost:3001/path/1 -H 'Content-Type: application/json' -d '{}'

# DELETE: Delete a record by given id
$ curl -X DELETE http://localhost:3001/path/1
```

Find process by port and kill'em, incase your desired port is occupied.

```sh
$ lsof -i tcp:3001
$ kill -9 PID
```
