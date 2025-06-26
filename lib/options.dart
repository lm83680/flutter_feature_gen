import 'dart:io';

class FeatureOptions {
  String? stateMgmt; // 'riverpod', 'bloc', or 'cubit'
  bool useFreezed = false;
  bool generateTests = false;
  String? featureName;
}

FeatureOptions parseArguments(List<String> args) {
  final options = FeatureOptions();
  final featureParts = <String>[];

  for (final arg in args) {
    switch (arg) {
      case '--riverpod':
      case '--bloc':
      case '--cubit':
        if (options.stateMgmt != null) {
          _exitWithError(
            'Multiple state management flags provided: '
            "'--${options.stateMgmt}' and '$arg'",
          );
        }
        options.stateMgmt = arg.replaceFirst('--', '');
        break;
      case '--freezed':
        options.useFreezed = true;
        break;
      case '--test':
        options.generateTests = true;
        break;
      default:
        if (arg.startsWith('--')) {
          _exitWithError("Unknown flag: '$arg'");
        } else if (arg.startsWith('-')) {
          _exitWithError(
            "Invalid flag: '$arg'\n"
            '💡 Did you mean one of these?\n'
            '   State management: --riverpod, --bloc, --cubit\n'
            '   Feature flags: --freezed, --test',
          );
        } else {
          featureParts.add(arg);
        }
    }
  }

  if (featureParts.isEmpty) {
    _exitWithError(
      'Missing feature name.\nUsage: flutter_feature_gen feature_name [flags]',
    );
  }

  options.featureName = featureParts.join('_');
  return options;
}

Never _exitWithError(String message) {
  print('❌ $message');
  exit(1);
}
