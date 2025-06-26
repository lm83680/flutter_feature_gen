# 🛠️ flutter_feature_gen

A simple Dart CLI tool to instantly scaffold Clean Architecture feature folders in your Flutter project.

Save time, stay consistent, and generate complete feature modules with one command!

---

## 🚀 Installation

Install it globally via [pub.dev](https://pub.dev/packages/flutter_feature_gen):

```bash
dart pub global activate flutter_feature_gen
```

Make sure Dart's pub global bin is in your PATH (usually `~/.pub-cache/bin`).  
If not, add this to your `.bashrc` / `.zshrc`:

```bash
export PATH="$HOME/.pub-cache/bin:$PATH"
```

---

## ✅ Usage

```bash
flutter_feature_gen <feature_name> [state_management] [options]
```

### State Management Options
- `--riverpod` - Riverpod Notifier
- `--bloc` - Bloc pattern (Event + State + Bloc)
- `--cubit` - Cubit pattern (simplified Bloc)

### Feature Options
- `--freezed` - Use Freezed for immutable models and state classes
- `--test` - Generate comprehensive test files


## 🏗️ Generated Structure

```
lib/features/your_feature/
├── data/
│   ├── datasources/
│   │   ├── your_feature_remote_datasource.dart
│   │   ├── your_feature_remote_datasource_impl.dart
│   │   ├── your_feature_local_datasource.dart
│   │   └── your_feature_local_datasource_impl.dart
│   ├── models/
│   │   └── your_feature_model.dart
│   └── repositories/
│       └── your_feature_repository_impl.dart
├── domain/
│   ├── entities/
│   │   └── your_feature_entity.dart
│   ├── repositories/
│   │   └── your_feature_repository.dart
│   └── usecases/
│       └── get_your_feature_usecase.dart
└── presentation/
    ├── controller/
    │   └── [state_management_files]
    ├── screens/
    │   └── your_feature_screen.dart
    └── widgets/
        └── your_feature_card.dart
```

Each folder includes boilerplate Dart files (models, repositories, use cases, screens, widgets, etc.).

### 🧠 Smart Naming

- Converts `meal-plan`, `meal_plan`, or `Meal Plan` → `MealPlanModel`, `MealPlanRepository`, etc.
- Folder: `lib/features/meal_plan/`
- Class Names: `MealPlanScreen`, `MealPlanModel`, etc.

---

## 💡 Example

### Social Media App Features

```bash
# User feed with advanced state management
flutter_feature_gen "Social Feed" --riverpod --freezed --test

# Profile management
flutter_feature_gen "User Profile" --bloc --test

# Chat system
flutter_feature_gen "Chat" --cubit --freezed
```

Creates:
- `lib/features/chat/`
- `chat_model.dart`
- `chat_repository.dart`
- `chat_screen.dart`
- And more...

---

## ⚡ Optional: Use `cf` as Shortcut

Add this to your `.zshrc` or `.bashrc`:

```bash
alias cf='flutter_feature_gen'
```

Then use:

```bash
cf workout_tracker
```

---

## 🧪 Test Generation

When using `--test`, the script generates:

- **Unit Tests**: For all business logic components
- **Widget Tests**: For UI components
- **Integration Tests**: For complete workflows
- **Mock Classes**: Using Mocktail for clean testing

Example test structure:
```
test/features/your_feature/
├── data/
│   ├── datasources/
│   ├── models/
│   └── repositories/
├── domain/
│   ├── entities/
│   ├── repositories/
│   └── usecases/
└── presentation/
    ├── controller/
    ├── screens/
    └── widgets/
```

## 📦 Dependencies

The script automatically adds the required dependencies based on your choices:

### Core Dependencies
```yaml
dependencies:
  dio: ^5.3.2
  flutter_riverpod:   # if --riverpod
  flutter_bloc:       # if --bloc or --cubit
  freezed_annotation: # if --freezed
  json_annotation: 
```

### Dev Dependencies
```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  mocktail: 
  bloc_test:           # if --bloc or --cubit
  build_runner:        # if using Freezed
  freezed:             # if --freezed
  json_serializable: 
```

## 🔧 Advanced Usage

### Custom Feature Names
The script intelligently handles various naming conventions:

```bash
cf "user profile"      # → user_profile (snake_case files)
cf "UserProfile"       # → user_profile (snake_case files)  
cf "User-Profile"      # → user_profile (snake_case files)
cf "User Profile API"  # → user_profile_api (handles multiple words)
```

### Build Runner Integration
For Freezed-based features, don't forget to run:
```bash
dart dart run build_runner build --delete-conflicting-outputs

```

## 🎨 Customization

The script generates production-ready code with:

- ✅ Proper error handling
- ✅ Type safety
- ✅ Null safety compliance
- ✅ Clean separation of concerns
- ✅ Testable architecture
- ✅ Industry best practices

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request


## 📄 License

MIT License © 2025 Jamal Sfenjeh


## 🙏 Acknowledgments

- Inspired by Clean Architecture principles by Robert C. Martin
- Flutter community best practices
- Modern state management patterns

## 🐛 Issues & Support

Found a bug or have a feature request? Please [open an issue](https://github.com/jamal-and/flutter_feature_gen/issues).

---

<div align="center">
  <p>Made with ❤️ for the Flutter community</p>
  <p>⭐ Star this repo if it helped you!</p>
