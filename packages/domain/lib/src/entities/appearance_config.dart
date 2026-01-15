enum AppThemeMode { system, light, dark }

enum AppDensity { comfortable, compact }

enum AppAccent { a, b, c }

class AppearanceConfig {
  const AppearanceConfig({
    this.themeMode = AppThemeMode.system,
    this.density = AppDensity.comfortable,
    this.accent = AppAccent.a,
  });

  final AppThemeMode themeMode;
  final AppDensity density;
  final AppAccent accent;
}
