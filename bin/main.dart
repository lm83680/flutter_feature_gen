import 'dart:io';

void main(List<String> args) {
  if (args.isEmpty) {
    print('❌ Usage: flutter_feature_gen <feature-name>');
    exit(1);
  }

  final rawName = args.first;
  final featureName = _toSnakeCase(rawName);
  final className = _toPascalCase(featureName);
  final base = 'lib/features/$featureName';

  // Folder structure
  final folders = [
    '$base/data/datasources',
    '$base/data/models',
    '$base/data/repositories',
    '$base/domain/entities',
    '$base/domain/repositories',
    '$base/domain/usecases',
    '$base/presentation/screens',
    '$base/presentation/widgets',
    '$base/presentation/controller',
  ];

  for (final folder in folders) {
    Directory(folder).createSync(recursive: true);
    print('📁 Created $folder');
  }

  // File templates
  final files = {
    '$base/data/datasources/${featureName}_remote_datasource.dart': '''
abstract class ${className}RemoteDataSource {
  Future<String> fetchData();
}
''',

    '$base/data/datasources/${featureName}_remote_datasource_impl.dart': '''
import '${featureName}_remote_datasource.dart';

class ${className}RemoteDataSourceImpl implements ${className}RemoteDataSource {
  @override
  Future<String> fetchData() async {
    // TODO: Implement
    return 'remote_$featureName';
  }
}
''',

    '$base/data/datasources/${featureName}_local_datasource.dart': '''
abstract class ${className}LocalDataSource {
  Future<String> fetchCachedData();
}
''',

    '$base/data/datasources/${featureName}_local_datasource_impl.dart': '''
import '${featureName}_local_datasource.dart';

class ${className}LocalDataSourceImpl implements ${className}LocalDataSource {
  @override
  Future<String> fetchCachedData() async {
    // TODO: Implement
    return 'local_$featureName';
  }
}
''',

    '$base/data/models/${featureName}_model.dart': '''
class ${className}Model {
  final String id;

  ${className}Model({required this.id});

  factory ${className}Model.fromJson(Map<String, dynamic> json) =>
      ${className}Model(id: json['id']);

  Map<String, dynamic> toJson() => {'id': id};
}
''',

    '$base/data/repositories/${featureName}_repository_impl.dart': '''
import '../../domain/repositories/${featureName}_repository.dart';
import '../datasources/${featureName}_remote_datasource.dart';

class ${className}RepositoryImpl implements ${className}Repository {
  final ${className}RemoteDataSource remoteDataSource;

  ${className}RepositoryImpl(this.remoteDataSource);

  @override
  void fetchData() {
    remoteDataSource.fetchData();
  }
}
''',

    '$base/domain/entities/${featureName}_entity.dart': '''
class ${className}Entity {
  final String id;

  const ${className}Entity({required this.id});
}
''',

    '$base/domain/repositories/${featureName}_repository.dart': '''
abstract class ${className}Repository {
  void fetchData();
}
''',

    '$base/domain/usecases/get_${featureName}_usecase.dart': '''
import '../repositories/${featureName}_repository.dart';

class Get${className}UseCase {
  final ${className}Repository repository;

  Get${className}UseCase(this.repository);

  void call() {
    repository.fetchData();
  }
}
''',

    '$base/presentation/screens/${featureName}_screen.dart': '''
import 'package:flutter/material.dart';

class ${className}Screen extends StatelessWidget {
  const ${className}Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('$className')),
      body: Center(child: Text('$className Screen')),
    );
  }
}
''',

    '$base/presentation/widgets/${featureName}_card.dart': '''
import 'package:flutter/material.dart';

class ${className}Card extends StatelessWidget {
  final String title;

  const ${className}Card({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(title),
      ),
    );
  }
}
'''
  };

  for (final entry in files.entries) {
    File(entry.key).writeAsStringSync(entry.value);
    print('✅ Created ${entry.key}');
  }

  print('\n🚀 Feature "$featureName" generated successfully!');
}

String _toSnakeCase(String input) {
  return input.trim().toLowerCase().replaceAll(RegExp(r'[\s\-]+'), '_');
}

String _toPascalCase(String input) {
  return input
      .split('_')
      .map((part) => part[0].toUpperCase() + part.substring(1))
      .join();
}
