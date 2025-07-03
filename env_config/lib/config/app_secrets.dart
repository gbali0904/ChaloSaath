import 'package:envied/envied.dart';

part 'app_secrets.g.dart';


@Envied(path: '.env', obfuscate: true) // ✅ fixed path
abstract class AppSecrets {
  @EnviedField(varName: 'GOOGLE_MAP_API_KEY', obfuscate: true)
  static final String googleMapApiKey = _AppSecrets.googleMapApiKey;

  @EnviedField(varName: 'GOOGLE_MAP_API_URL')
  static final String googleMapApiUrl = _AppSecrets.googleMapApiUrl;

}
