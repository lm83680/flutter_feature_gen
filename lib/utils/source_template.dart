class SourceTemplate {
  final String className;
  final String featureName;
  final bool useFreezed;

  SourceTemplate({
    required this.className,
    required this.featureName,
    this.useFreezed = false,
  });

  String getRemoteDataSourceTemplate() {
    return '''
import '../models/${featureName}_model.dart';

abstract class ${className}RemoteDataSource {
  Future<${className}Model> fetchData();
}
''';
  }

  String getRemoteDataSourceImplTemplate() {
    return '''
import 'package:dio/dio.dart';
import '${featureName}_remote_datasource.dart';
import '../models/${featureName}_model.dart';

class ${className}RemoteDataSourceImpl implements ${className}RemoteDataSource {
  final Dio dio;

  ${className}RemoteDataSourceImpl(this.dio);

  @override
  Future<${className}Model> fetchData() async {
    final response = await dio.get('https://api.example.com/$featureName');
    return ${className}Model.fromJson(response.data);
  }
}
''';
  }

  String getLocalDataSourceTemplate() {
    return '''
import '../models/${featureName}_model.dart';

abstract class ${className}LocalDataSource {
  Future<${className}Model?> fetchCachedData();
  Future<void> cacheData(${className}Model data);
}
''';
  }

  String getLocalDataSourceImplTemplate() {
    return '''
import '${featureName}_local_datasource.dart';
import '../models/${featureName}_model.dart';

class ${className}LocalDataSourceImpl implements ${className}LocalDataSource {
  @override
  Future<${className}Model?> fetchCachedData() async {
    // TODO: Implement actual cached data retrieval
    return null;
  }

  @override
  Future<void> cacheData(${className}Model data) async {
    // TODO: Implement caching logic
  }
}
''';
  }

  String getModelTemplate() {
    if (useFreezed) {
      return getFreezedModelTemplate();
    } else {
      return getRegularModelTemplate();
    }
  }

  String getRegularModelTemplate() {
    return '''
class ${className}Model {
  final String id;

  const ${className}Model({required this.id});

  factory ${className}Model.fromJson(Map<String, dynamic> json) =>
      ${className}Model(id: json['id']);

  Map<String, dynamic> toJson() => {'id': id};
}
''';
  }

  String getFreezedModelTemplate() {
    return '''
import 'package:freezed_annotation/freezed_annotation.dart';

part '${featureName}_model.freezed.dart';
part '${featureName}_model.g.dart';

@freezed
abstract class ${className}Model with _\$${className}Model {
  const factory ${className}Model({
    required String id,
    String? name,
    String? description,
  }) = _${className}Model;

  factory ${className}Model.fromJson(Map<String, dynamic> json) =>
      _\$${className}ModelFromJson(json);
}
''';
  }

  String getEntityTemplate() {
    if (useFreezed) {
      return getFreezedEntityTemplate();
    } else {
      return getRegularEntityTemplate();
    }
  }

  String getRegularEntityTemplate() {
    return '''
class ${className}Entity {
  final String id;

  const ${className}Entity({required this.id});
}
''';
  }

  String getFreezedEntityTemplate() {
    return '''
import 'package:freezed_annotation/freezed_annotation.dart';

part '${featureName}_entity.freezed.dart';

@freezed
abstract class ${className}Entity with _\$${className}Entity {
  const factory ${className}Entity({
    required String id,
    String? name,
    String? description,
  }) = _${className}Entity;
}
''';
  }

  String getRepositoryImplTemplate() {
    return '''
import '../../domain/repositories/${featureName}_repository.dart';
import '../datasources/${featureName}_remote_datasource.dart';
import '../datasources/${featureName}_local_datasource.dart';
import '../models/${featureName}_model.dart';
import '../../domain/entities/${featureName}_entity.dart';

class ${className}RepositoryImpl implements ${className}Repository {
  final ${className}RemoteDataSource remoteDataSource;
  final ${className}LocalDataSource localDataSource;

  ${className}RepositoryImpl(
    this.remoteDataSource,
    this.localDataSource,
  );

  @override
  Future<${className}Entity> fetchData() async {
    try {
      final model = await remoteDataSource.fetchData();
      await localDataSource.cacheData(model);
      return _modelToEntity(model);
    } catch (e) {
      final cachedModel = await localDataSource.fetchCachedData();
      if (cachedModel != null) {
        return _modelToEntity(cachedModel);
      }
      rethrow;
    }
  }

  ${className}Entity _modelToEntity(${className}Model model) {
    return ${className}Entity(
      id: model.id,
      ${useFreezed ? '''name: model.name,
      description: model.description,''' : ''}
    );
  }
}
''';
  }

  String getRepositoryTemplate() {
    return '''
import '../entities/${featureName}_entity.dart';

abstract class ${className}Repository {
  Future<${className}Entity> fetchData();
}
''';
  }

  String getUseCaseTemplate() {
    return '''
import '../repositories/${featureName}_repository.dart';
import '../entities/${featureName}_entity.dart';

class Get${className}UseCase {
  final ${className}Repository repository;

  Get${className}UseCase(this.repository);

  Future<${className}Entity> call() async {
    return await repository.fetchData();
  }
}
''';
  }

  String getScreenTemplate() {
    return '''
import 'package:flutter/material.dart';

class ${className}Screen extends StatelessWidget {
  const ${className}Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('$className')),
      body:  Center(child: Text('$className Screen')),
    );
  }
}
''';
  }

  String getWidgetTemplate() {
    return '''
import 'package:flutter/material.dart';
${useFreezed ? "import '../../domain/entities/${featureName}_entity.dart';" : ''}

class ${className}Card extends StatelessWidget {
  final String title;
  ${useFreezed ? 'final ${className}Entity? entity;' : ''}

  const ${className}Card({
    super.key, 
    required this.title,
    ${useFreezed ? 'this.entity,' : ''}
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: ${useFreezed ? '''
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            if (entity != null) ...[
              const SizedBox(height: 8),
              Text('ID: \${entity!.id}'),
              if (entity!.name != null)
                Text('Name: \${entity!.name}'),
              if (entity!.description != null)
                Text('Description: \${entity!.description}'),
            ],
          ],
        )''' : 'Text(title)'},
      ),
    );
  }
}
''';
  }

  /// Additional method to get the list of files that need to be generated
  Map<String, String> getFileTemplates(String basePath) {
    final templates = <String, String>{
      // Data Sources
      '$basePath/data/datasources/${featureName}_remote_datasource.dart':
          getRemoteDataSourceTemplate(),

      '$basePath/data/datasources/${featureName}_remote_datasource_impl.dart':
          getRemoteDataSourceImplTemplate(),

      '$basePath/data/datasources/${featureName}_local_datasource.dart':
          getLocalDataSourceTemplate(),

      '$basePath/data/datasources/${featureName}_local_datasource_impl.dart':
          getLocalDataSourceImplTemplate(),

      // Models
      '$basePath/data/models/${featureName}_model.dart': getModelTemplate(),

      // Repository Implementation
      '$basePath/data/repositories/${featureName}_repository_impl.dart':
          getRepositoryImplTemplate(),

      // Domain
      '$basePath/domain/entities/${featureName}_entity.dart':
          getEntityTemplate(),

      '$basePath/domain/repositories/${featureName}_repository.dart':
          getRepositoryTemplate(),

      '$basePath/domain/usecases/get_${featureName}_usecase.dart':
          getUseCaseTemplate(),

      // Presentation
      '$basePath/presentation/screens/${featureName}_screen.dart':
          getScreenTemplate(),

      '$basePath/presentation/widgets/${featureName}_card.dart':
          getWidgetTemplate(),
    };

    return templates;
  }
}
