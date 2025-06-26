/// String utility functions
extension StringUtils on String {
  /// Converts input like "meal-plan" or "meal plan" into snake_case.
  String toSnakeCase() {
    return trim().toLowerCase().replaceAll(RegExp(r'[\s\-]+'), '_');
  }

  /// Converts snake_case into PascalCase (e.g., "meal_plan" → "MealPlan").
  String toPascalCase() {
    return split(
      '_',
    ).map((part) => part[0].toUpperCase() + part.substring(1)).join();
  }
}

/// Converts input like "meal-plan" or "meal plan" into snake_case.
String toSnakeCase(String input) {
  return input.toSnakeCase();
}

/// Converts snake_case into PascalCase (e.g., "meal_plan" → "MealPlan").
String toPascalCase(String input) {
  return input.toPascalCase();
}
