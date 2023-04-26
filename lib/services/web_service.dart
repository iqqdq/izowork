import 'package:dio/dio.dart';
import 'package:izowork/components/user_params.dart';

class WebService {
  final _dio = Dio();

  Future<Options> _options() async {
    String token = await UserParams().getToken() ?? '';

    return Options(
        headers: token.isNotEmpty
            ? {
                'Accept': 'application/json',
                'Content-Type': 'application/json',
                'Authorization': 'Bearer $token'
              }
            : {
                'Accept': 'application/json',
                'Content-Type': 'application/json',
              },
        followRedirects: false);
  }

  Future<Options> _multipartOptions() async {
    String token = await UserParams().getToken() ?? '';

    return Options(headers: {
      'Accept': 'application/json',
      'Content-Type': 'multipart/form-data',
      'Authorization': 'Bearer $token'
    }, followRedirects: false);
  }

  Future<dynamic> get(String url) async {
    try {
      Response response = await _dio.get(url, options: await _options());

      if (response.statusCode == 200) {
        return response.data;
      }
    } catch (e) {
      if (e is DioError) {
        return e.response?.data;
      }
    }
  }

  Future<dynamic> post(String url, Object object) async {
    try {
      Response response =
          await _dio.post(url, data: object, options: await _options());

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
      }
    } catch (e) {
      if (e is DioError) {
        return e.response?.data;
      }
    }
  }

  Future<dynamic> postFormData(String url, FormData formData) async {
    try {
      Response response = await _dio.post(url,
          data: formData, options: await _multipartOptions());

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
      }
    } catch (e) {
      if (e is DioError) {
        return e.response?.data;
      }
    }
  }

  Future<dynamic> patch(String url, Object object) async {
    try {
      Response response =
          await _dio.patch(url, data: object, options: await _options());

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
      }
    } catch (e) {
      if (e is DioError) {
        return e.response?.data;
      }
    }
  }

  Future<dynamic> put(String url, Object object) async {
    try {
      Response response =
          await _dio.put(url, data: object, options: await _options());

      if (response.statusCode == 200) {
        return response.data ?? true;
      }
    } catch (e) {
      if (e is DioError) {
        return e.response?.data;
      }
    }
  }

  Future<dynamic> delete(String url, Object? object) async {
    try {
      Response response =
          await _dio.delete(url, data: object, options: await _options());

      if (response.statusCode == 200 || response.statusCode == 204) {
        return true;
      }
    } catch (e) {
      if (e is DioError) {
        return e.response?.data;
      }
    }
  }

  Future<dynamic> upload(String url, FormData formData) async {
    try {
      Response response = await _dio.post(url,
          data: formData, options: await _multipartOptions());

      if (response.statusCode == 200 || response.statusCode == 204) {
        return response.data;
      }
    } catch (e) {
      if (e is DioError) {
        return e.response?.data;
      }
    }
  }
}
