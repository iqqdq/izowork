import 'package:dio/dio.dart';

abstract class WebServiceInterface {
  Future<dynamic> get(String url);

  Future<dynamic> post(
    String url,
    Object object,
  );

  Future<dynamic> postFormData(
    String url,
    FormData formData,
  );

  Future<dynamic> patch(
    String url,
    Object object,
    String? queryParameters,
  );

  Future<dynamic> put(
    String url,
    Object object,
  );

  Future<dynamic> delete(
    String url,
    Object? object,
  );

  Future<dynamic> upload(
    String url,
    FormData formData,
  );
}
