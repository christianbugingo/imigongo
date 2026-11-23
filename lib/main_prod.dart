import 'core/config/app_flavor.dart';
import 'main.dart';

void main() {
  AppConfig.initialize(AppFlavor.prod);
  runImigongoApp();
}
