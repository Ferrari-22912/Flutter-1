/// ALPHA BUILD configuration.
///
/// Login, ingredients, recipes, search history and the Chef Bhai chat all
/// come from built-in sample data, so the app works with no accounts, API
/// keys or backend.
abstract final class AppConfig {
  /// True: the app uses only built-in sample data.
  static const bool useMockData = true;

  static const String demoEmail = 'chef@threebhai.app';
  static const String demoPassword = 'Chef1234';
}
