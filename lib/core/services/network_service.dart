import 'package:dio/dio.dart';
import 'package:todo/core/config/app_config.dart';

class NetworkService {
  final Dio dio = Dio();

  static Future<bool> checkConnection() async {
    return true;
  }

  Future<dynamic> getRequest({required String endPoint}) async {
    Response response = await dio.get('$baseUrl$endPoint');
    print(
      'Get Response From Network Service::::::::::::::::::::::::::::::::::::::::::::::::${response.data}',
    );
    return response.data;
  }
}
