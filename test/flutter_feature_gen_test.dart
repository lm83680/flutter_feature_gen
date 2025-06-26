import 'package:flutter_feature_gen/utils/string_utils.dart';
import 'package:test/test.dart';

void main() {
  test('toSnakeCase', () {
    expect(toSnakeCase('App Name'), 'app_name');
  });
   test('toPascalCase', () {
    expect(toPascalCase('app_name'), 'AppName');
  });
}
