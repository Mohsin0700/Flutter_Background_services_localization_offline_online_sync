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

  Future<bool> postRequest({
    required String endPoint,
    required Map<String, dynamic> data,
  }) async {
    Response response = await dio.post('$baseUrl$endPoint', data: data);

    print(
      'Post Response From Network Service::::::::::::::::::::::::::::::::::::::::::::::::${response.data}',
    );
    if (response.statusCode! >= 200 && response.statusCode! < 300) {
      return true;
    } else {
      return false;
    }
  }
}
