import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:test/test.dart';

void main() {
  const host = 'http://localhost:3001';
  late Process process;

  setUp(() async {
    process = await Process.start('dart', [
      '-DDB_PATH=db/tendonloader.db',
      'bin/server.dart',
    ]);
    // Wait for server to start and print to stdout.
    await process.stdout.first;
  });

  tearDown(() => process.kill());

  test('Root', () async {
    final response = await http.get(Uri.parse(host));
    expect(response.statusCode, 200);
    expect(response.body, '<h2>TendonLoader API v1.0</h2>\n');
  });

  test('404', () async {
    final response = await http.get(Uri.parse('$host/foobar'));
    expect(response.statusCode, 404);
  });

  test('Get record at id: 1', () async {
    final response = await http.get(Uri.parse('$host/users/1'));
    expect(response.statusCode, 200);
    expect(
      response.body,
      '[{"id":1,"animal":"Dog","description":'
      '"Wags tail when happy","age":2,"price":250.0}]',
    );
  });

  test('Search record with: "dog"', () async {
    final response = await http.get(Uri.parse('$host/users/search/dog'));
    expect(response.statusCode, 200);
    expect(
      response.body,
      '[{"id":1,"animal":"Dog","description":'
      '"Wags tail when happy","age":2,"price":250.0}]',
    );
  });

  test('Insert a record', () async {
    final response = await http.post(
      Uri.parse('$host/users'),
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      body: jsonEncode({
        'username': 'Jaguar',
        'password': 'Beware, its dangerous.',
      }),
    );
    expect(response.statusCode, 200);
    expect(response.body, 'Inserted successfully');
  });

  test('Update record at id: 2', () async {
    final response = await http.patch(
      Uri.parse('$host/users/2'),
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      body: jsonEncode({
        'username': 'Elephant',
        'password': 'A giant and heavy creature',
      }),
    );
    expect(response.statusCode, 200);
    expect(response.body, 'Updated successfully');
  });

  test('Delete record at id: 1', () async {
    final response = await http.delete(Uri.parse('$host/users/1'));
    expect(response.statusCode, 200);
    expect(response.body, 'Deleted successfully');
  });
}
