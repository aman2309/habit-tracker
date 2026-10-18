// Development-only Firestore seeder.
//
// Creates the sample habits and a short completion history for the documented
// development identity. It never deletes or overwrites: documents that already
// exist are skipped, so running it repeatedly is safe and idempotent.
//
// Usage (see README for details):
//   FIRESTORE_EMULATOR_HOST=localhost:8080 dart run tool/seed_dev_data.dart --emulator
//   dart run tool/seed_dev_data.dart --dry-run
//   dart run tool/seed_dev_data.dart --allow-live
//
// Live mode uses your existing `firebase login` session (or FIREBASE_ACCESS_TOKEN)
// and refuses to write unless --allow-live is passed.
//
// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'seed_plan.dart';

const String _defaultProject = 'hiicampus-habit-tracker';

Future<void> main(List<String> args) async {
  final options = _Options.parse(args);
  if (options.help) {
    _printUsage();
    return;
  }

  final project =
      options.project ?? await _projectFromConfig() ?? _defaultProject;
  final emulatorHost = options.emulator
      ? 'localhost:8080'
      : Platform.environment['FIRESTORE_EMULATOR_HOST'];
  final useEmulator = emulatorHost != null && emulatorHost.isNotEmpty;

  if (!useEmulator && !options.allowLive && !options.dryRun) {
    _fail(
      'Refusing to write to the live project "$project" without --allow-live.',
    );
  }

  String? token;
  if (!useEmulator && !options.dryRun) {
    token = _accessToken();
    if (token == null) {
      _fail(
        'No valid Firebase CLI session found. Run `firebase login` or set '
        'FIREBASE_ACCESS_TOKEN, then retry.',
      );
    }
  }

  final base = useEmulator
      ? Uri.parse('http://$emulatorHost')
      : Uri.parse('https://firestore.googleapis.com');
  final databaseRoot = '/v1/projects/$project/databases/(default)/documents';

  final today = DateTime.now();
  final plan = buildSeedPlan(userId: options.user, today: today);

  print('=== HiiCampus habit tracker - DEVELOPMENT SEED ===');
  print('projectId : $project');
  print(
    'target    : ${useEmulator ? 'emulator ($emulatorHost)' : 'LIVE Firestore'}',
  );
  print('user      : ${options.user}');
  print('root      : users/${options.user}/habits/{habitId}');
  print('date key  : local calendar day yyyy-MM-dd (today = ${dayKey(today)})');
  print('documents : ${plan.length} planned');
  print('dry run   : ${options.dryRun}');
  print('');

  final client = _Client(base, token);

  final existing = <String>{};
  for (final document in plan) {
    if (await client.documentExists(databaseRoot, document.path)) {
      existing.add(document.path);
    }
  }
  final missing = missingDocuments(plan: plan, existingPaths: existing);

  print('already present : ${existing.length} (left untouched)');
  print('to create       : ${missing.length}');
  print('');

  var created = 0;
  var skipped = 0;
  for (final document in missing) {
    if (options.dryRun) {
      print('  [dry-run] would create ${document.path}');
      continue;
    }
    final result = await client.createIfAbsent(databaseRoot, document);
    switch (result) {
      case _CreateResult.created:
        created += 1;
        print('  + created ${document.path}');
      case _CreateResult.alreadyExists:
        skipped += 1;
        print('  = skipped ${document.path}');
      case _CreateResult.failed:
        _fail('Failed to create ${document.path}');
    }
  }

  if (options.dryRun) {
    print('\nDry run complete. Nothing was written.');
    return;
  }

  print('');
  print('Verifying by reading every planned document back...');
  final problems = <String>[];
  for (final document in plan) {
    final fields = await client.readDocument(databaseRoot, document.path);
    if (fields == null) {
      problems.add('missing: ${document.path}');
      continue;
    }
    final mismatch = _verify(document, fields);
    if (mismatch != null) {
      problems.add('$mismatch (${document.path})');
    }
  }

  print('');
  print('created : $created');
  print('skipped : $skipped (already existed)');
  print('verified: ${plan.length - problems.length}/${plan.length}');
  if (problems.isEmpty) {
    print('READ-BACK OK - seeded data is present in $project.');
  } else {
    for (final problem in problems) {
      print('  ! $problem');
    }
    exitCode = 1;
  }
}

/// Returns a description of a mismatch, or `null` when the document is fine.
String? _verify(SeedDocument document, Map<String, Object?> fields) {
  if (document.path.contains('/completions/')) {
    if (fields['completed'] != true) {
      return 'expected completed=true';
    }
    return null;
  }
  if ((fields['name'] as String?)?.isEmpty ?? true) {
    return 'expected a non-empty name';
  }
  if (fields['points'] is! int) {
    return 'expected an integer points field';
  }
  return null;
}

Future<String?> _projectFromConfig() async {
  final file = File('.firebaserc');
  if (!file.existsSync()) return null;
  try {
    final json = jsonDecode(await file.readAsString()) as Map<String, dynamic>;
    final projects = json['projects'] as Map<String, dynamic>?;
    return projects?['default'] as String?;
  } catch (_) {
    return null;
  }
}

/// Reads a still-valid access token from the Firebase CLI session, or the
/// `FIREBASE_ACCESS_TOKEN` override. The token is never printed.
String? _accessToken() {
  final override = Platform.environment['FIREBASE_ACCESS_TOKEN'];
  if (override != null && override.isNotEmpty) return override;

  final home = Platform.environment['HOME'];
  if (home == null) return null;
  final file = File('$home/.config/configstore/firebase-tools.json');
  if (!file.existsSync()) return null;
  try {
    final json = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
    final tokens = json['tokens'] as Map<String, dynamic>?;
    final token = tokens?['access_token'] as String?;
    final expiresAt = tokens?['expires_at'];
    final nowMillis = DateTime.now().millisecondsSinceEpoch;
    if (token != null &&
        token.isNotEmpty &&
        expiresAt is int &&
        expiresAt > nowMillis + 30000) {
      return token;
    }
  } catch (_) {
    return null;
  }
  return null;
}

Never _fail(String message) {
  print('ERROR: $message');
  exit(2);
}

void _printUsage() {
  print('''
HiiCampus habit tracker - development seeder.

Options:
  --emulator         Force the Firestore emulator (default host localhost:8080,
                     or set FIRESTORE_EMULATOR_HOST).
  --project=<id>     Firebase project id (default: .firebaserc / $_defaultProject).
  --user=<id>        Development user id (default: $seedUserId).
  --allow-live       Required to write to live Firestore.
  --dry-run          Show what would be created without writing.
  --help             Show this message.
''');
}

class _Options {
  const _Options({
    required this.project,
    required this.user,
    required this.emulator,
    required this.allowLive,
    required this.dryRun,
    required this.help,
  });

  final String? project;
  final String user;
  final bool emulator;
  final bool allowLive;
  final bool dryRun;
  final bool help;

  static _Options parse(List<String> args) {
    String? project;
    var user = seedUserId;
    var emulator = false;
    var allowLive = Platform.environment['ALLOW_LIVE_SEED'] == '1';
    var dryRun = false;
    var help = false;

    for (final arg in args) {
      if (arg == '--emulator') {
        emulator = true;
      } else if (arg == '--allow-live') {
        allowLive = true;
      } else if (arg == '--dry-run') {
        dryRun = true;
      } else if (arg == '--help' || arg == '-h') {
        help = true;
      } else if (arg.startsWith('--project=')) {
        project = arg.substring('--project='.length);
      } else if (arg.startsWith('--user=')) {
        user = arg.substring('--user='.length);
      }
    }

    return _Options(
      project: project,
      user: user,
      emulator: emulator,
      allowLive: allowLive,
      dryRun: dryRun,
      help: help,
    );
  }
}

enum _CreateResult { created, alreadyExists, failed }

class _Client {
  _Client(this.base, this.token);

  final Uri base;
  final String? token;

  Future<bool> documentExists(String root, String path) async {
    final response = await _send('GET', root, documentPath: path);
    if (response.status == 200) return true;
    if (response.status == 404) return false;
    _fail('Read failed for $path (HTTP ${response.status})');
  }

  Future<Map<String, Object?>?> readDocument(String root, String path) async {
    final response = await _send('GET', root, documentPath: path);
    if (response.status != 200) return null;
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final fields = json['fields'] as Map<String, dynamic>? ?? {};
    return {
      for (final entry in fields.entries)
        entry.key: _decodeValue(entry.value as Map<String, dynamic>),
    };
  }

  Future<_CreateResult> createIfAbsent(
    String root,
    SeedDocument document,
  ) async {
    final body = {
      'writes': [
        {
          'update': {
            'name': _documentName(root, document.path),
            'fields': _encodeFields(document.fields),
          },
          'currentDocument': {'exists': false},
        },
      ],
    };
    final response = await _send('POST', '$root:commit', body: body);
    if (response.status == 200) return _CreateResult.created;
    if (response.status == 400 &&
        response.body.contains('FAILED_PRECONDITION')) {
      return _CreateResult.alreadyExists;
    }
    return _CreateResult.failed;
  }

  Future<_Response> _send(
    String method,
    String root, {
    String? documentPath,
    Object? body,
  }) async {
    final path = documentPath == null ? root : '$root/$documentPath';
    final request = await HttpClient().openUrl(
      method,
      base.replace(path: path),
    );
    if (token != null) {
      request.headers.set(HttpHeaders.authorizationHeader, 'Bearer $token');
    }
    if (body != null) {
      request.headers.contentType = ContentType.json;
      request.write(jsonEncode(body));
    }
    final response = await request.close();
    final text = await response.transform(utf8.decoder).join();
    return _Response(response.statusCode, text);
  }

  String _documentName(String root, String path) =>
      'projects/${_projectFromRoot(root)}/databases/(default)/documents/$path';

  String _projectFromRoot(String root) {
    // root = /v1/projects/<id>/databases/(default)/documents
    final segments = root.split('/');
    final index = segments.indexOf('projects');
    return segments[index + 1];
  }

  Map<String, Object?> _encodeFields(Map<String, Object?> fields) => {
    for (final entry in fields.entries) entry.key: _encodeValue(entry.value),
  };

  Map<String, Object?> _encodeValue(Object? value) {
    if (value == null) return {'nullValue': null};
    if (value is bool) return {'booleanValue': value};
    if (value is int) return {'integerValue': '$value'};
    if (value is double) return {'doubleValue': value};
    if (value is DateTime) {
      return {'timestampValue': value.toUtc().toIso8601String()};
    }
    return {'stringValue': '$value'};
  }

  Object? _decodeValue(Map<String, dynamic> value) {
    if (value.containsKey('nullValue')) return null;
    if (value.containsKey('stringValue')) return value['stringValue'];
    if (value.containsKey('booleanValue')) return value['booleanValue'];
    if (value.containsKey('integerValue')) {
      return int.tryParse(value['integerValue'] as String);
    }
    if (value.containsKey('doubleValue')) {
      final raw = value['doubleValue'];
      return raw is num ? raw.toDouble() : null;
    }
    if (value.containsKey('timestampValue')) return value['timestampValue'];
    return null;
  }
}

class _Response {
  const _Response(this.status, this.body);

  final int status;
  final String body;
}
