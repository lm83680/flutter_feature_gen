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
flutter_feature_gen feature_name
```

This will generate:

```
lib/features/feature_name/
├── data/
│   ├── datasources/
│   ├── models/
│   └── repositories/
├── domain/
│   ├── entities/
│   ├── repositories/
│   └── usecases/
├── presentation/
│   ├── controller/
│   ├── screens/
│   └── widgets/
```

Each folder includes boilerplate Dart files (models, repositories, use cases, screens, widgets, etc.).

### 🧠 Smart Naming

- Converts `meal-plan`, `meal_plan`, or `Meal Plan` → `MealPlanModel`, `MealPlanRepository`, etc.
- Folder: `lib/features/meal_plan/`
- Class Names: `MealPlanScreen`, `MealPlanModel`, etc.

---

## 💡 Example

```bash
flutter_feature_gen meal-plan
```

Creates:
- `lib/features/meal_plan/`
- `meal_plan_model.dart`
- `meal_plan_repository.dart`
- `meal_plan_screen.dart`
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

## 📄 License

MIT License © 2025 [Your Name]
