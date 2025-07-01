// This is a minimal usage example for flutter_feature_gen
// Note: This is a CLI tool. You normally run it via terminal, not inside Dart code.
import 'dart:io';
import 'package:flutter_feature_gen/flutter_feature_gen.dart' as generator;

void main() {
  try {
    if (bool.fromEnvironment('dart.vm.full', defaultValue: false)) {
      full();
    } else {
      simple();
    }
  } catch (e, st) {
    print('===============\n ❌ Failed to generate feature:\n$e\n$st');
  }
}

void simple() {
  Directory.current = Directory('./example');
  generator.main(['meal plan', '--riverpod']);
}

/// you must run this in the terminal with
/// ```
/// dart run example/main.dart --dart-define=dart.vm.full=true
/// ```
void full() async {
  final List<String> args = [];
  stdout.write('\nPlease enter a feature name (e.g., meal-plan): ');
  final featureName = stdin.readLineSync();
  if (featureName == null || featureName.trim().isEmpty) {
    print('❌ Feature name cannot be empty.');
    return;
  }
  args.add(featureName);

  print('📦 Please select a state management option (optional):');
  print('1️⃣  Riverpod');
  print('2️⃣  Bloc');
  print('3️⃣  Cubit');
  stdout.write('\nEnter the number (1, 2, or 3), or press Enter to skip: ');

  final input = stdin.readLineSync();
  switch (input) {
    case '1':
      args.add('--riverpod');
      break;
    case '2':
      args.add('--bloc');
      break;
    case '3':
      args.add('--cubit');
      break;
    default:
      print('Skipping state management selection.');
      break;
  }

  stdout.write('\nDo you want to use freezed? (y/N), or press Enter to skip: ');
  final freezedInput = stdin.readLineSync();
  if (freezedInput != null && freezedInput.toLowerCase() == 'y') {
    args.add('--freezed');
  }

  stdout.write('\nDo you want to generate test files? (y/N), or press Enter to skip: ');
  final testInput = stdin.readLineSync();
  if (testInput != null && testInput.toLowerCase() == 'y') {
    args.add('--test');
  }

  Directory.current = Directory('./example');
  try {
    generator.main(args);
    print('✅ Feature generated successfully!');
  } catch (e, st) {
    print('❌ Failed to generate feature:\n$e\n$st');
  }
}
