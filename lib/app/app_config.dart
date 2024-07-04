import 'package:moss_yoga/common/resources/urls.dart';

enum Environment {dev, staging, prod}

class AppConfig{
  AppConfig({
    required Environment environment,
    required String baseUrl,
}): _environment = environment, _baseUrl = baseUrl;

  AppConfig.dev():_environment=Environment.dev,_baseUrl = Urls.baseUrlDev;

  AppConfig.prod():_environment=Environment.prod,_baseUrl = Urls.baseUrlProd;

  final Environment _environment;
  final String _baseUrl;
  Environment get environment => _environment;
  String get baseUrl => _baseUrl;

}