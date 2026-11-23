/// Supported application flavors.
enum AppFlavor {
  dev('dev', 'Imigongo Dev', '.dev'),
  prod('prod', 'Imigongo', '');

  final String name;
  final String appTitle;
  final String applicationIdSuffix;

  const AppFlavor(this.name, this.appTitle, this.applicationIdSuffix);

  bool get isDev => this == AppFlavor.dev;
  bool get isProd => this == AppFlavor.prod;
}

/// Global environment configuration holder.
class AppConfig {
  static AppFlavor flavor = AppFlavor.prod;

  static void initialize(AppFlavor targetFlavor) {
    flavor = targetFlavor;
  }
}

