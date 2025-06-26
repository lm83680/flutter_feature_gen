import 'dart:io';

Future<void> writeTest(String path, String content) async {
  final file = File('test/features/$path');
  final directory = file.parent;
  // bool log = false;

  if (!await directory.exists()) {
    await directory.create(recursive: true);
    // if (log) print('📁 Created directory: ${directory.path}');
  }

  await file.writeAsString(content);
  // if (log) print('✅ Created test: ${file.path}');
}

void runBuildRunner() {
  try {
    print('🔧 Running build_runner...');
    final result = Process.runSync('dart', [
      'run',
      'build_runner',
      'build',
      '--delete-conflicting-outputs',
    ], runInShell: true);
    stdout.write(result.stdout);
    stderr.write(result.stderr);
  } catch (e) {
    print('⚠️ Failed to run build_runner: $e');
  }
}
