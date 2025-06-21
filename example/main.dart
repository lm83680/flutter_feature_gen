// This is a minimal usage example for flutter_feature_gen
// Note: This is a CLI tool. You normally run it via terminal, not inside Dart code.

import 'dart:io';

void main() async {
  // Simulating a CLI call (for example/testing purposes)
  final result = await Process.run(
    'flutter_feature_gen',
    ['meal-plan'],
  );

  if (result.exitCode == 0) {
    print('✅ Feature generated successfully!');
  } else {
    print('❌ Failed to generate feature:\n${result.stderr}');
  }
}
