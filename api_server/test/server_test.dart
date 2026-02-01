import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:test/test.dart';

void main() {
  const host = 'http://localhost:3001/api';
  late Process process;

  setUp(() async {
    process = await Process.start(
      'dart',
      ['bin/server.dart'],
      environment: {'DB_PATH': 'db/tendonloader.db'},
    );
    // Wait for server to start and print to stdout.
    await process.stdout.first;
  });

  tearDown(() => process.kill());

  test('Root', () async {
    final res = await http.get(.parse(host));
    expect(res.statusCode, 200);
    expect(res.body, '<h2>TendonLoader API v1.0</h2>\n');
  });

  test('404', () async {
    final res = await http.get(.parse('$host/foobar'));
    expect(res.statusCode, 404);
  });

  test('Get record at id: 1', () async {
    final res = await http.get(.parse('$host/users/1'));
    expect(res.statusCode, 200);
    expect(
      res.body,
      '[{"id":1,"animal":"Dog","description":'
      '"Wags tail when happy","age":2,"price":250.0}]',
    );
  });

  test('Search record with: "dog"', () async {
    final res = await http.get(.parse('$host/users/search/dog'));
    expect(res.statusCode, 200);
    expect(
      res.body,
      '[{"id":1,"animal":"Dog","description":'
      '"Wags tail when happy","age":2,"price":250.0}]',
    );
  });

  test('Insert a record', () async {
    final res = await http.post(
      .parse('$host/users'),
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      body: jsonEncode({
        'username': 'Jaguar',
        'password': 'Beware, its dangerous.',
      }),
    );
    expect(res.statusCode, 200);
    expect(res.body, 'Inserted successfully');
  });

  test('Update record at id: 2', () async {
    final res = await http.patch(
      .parse('$host/users/2'),
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      body: jsonEncode({
        'username': 'Elephant',
        'password': 'A giant and heavy creature',
      }),
    );
    expect(res.statusCode, 200);
    expect(res.body, 'Updated successfully');
  });

  test('Delete record at id: 1', () async {
    final res = await http.delete(.parse('$host/users/1'));
    expect(res.statusCode, 200);
    expect(res.body, 'Deleted successfully');
  });
}
