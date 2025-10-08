import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> init() async => await dotenv.load(fileName: ".env");

// Root URL
const String rootUrl = 'https://crudcrud.com/api/';

// Base URL
String get baseUrl {
  final apiKey = dotenv.env['API_KEY'] ?? '';
  if (apiKey.isEmpty) {
    throw Exception('API_KEY missing — add it to .env');
  }
  return '$rootUrl$apiKey/';
}
