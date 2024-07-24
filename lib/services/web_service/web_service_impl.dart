import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:izowork/injection_container.dart';
import 'package:izowork/repositories/local_storage_repository/local_storage_repository_interface.dart';
import 'package:izowork/services/web_service/web_service_interface.dart';

class WebServiceImpl implements WebServiceInterface {
  final Dio dio;

  WebServiceImpl({required this.dio});

  @override
  Future<dynamic> get(String url) async {
    debugPrint(url);

    try {
      Response response = await dio.get(
        url,
        options: await _options(),
      );

      if (response.statusCode == 200) {
        return response.data;
      }
    } catch (e) {
      if (e is DioException) {
        return e.response?.data;
      }
    }
  }

  @override
  Future<dynamic> post(
    String url,
    Object object,
  ) async {
    try {
      Response response = await dio.post(
        url,
        data: object,
        options: await _options(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
      }
    } catch (e) {
      if (e is DioException) {
        return e.response?.data;
      }
    }
  }

  @override
  Future<dynamic> postFormData(
    String url,
    FormData formData,
  ) async {
    try {
      Response response = await dio.post(
        url,
        data: formData,
        options: await _multipartOptions(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
      }
    } catch (e) {
      if (e is DioException) {
        return e.response?.data;
      }
    }
  }

  @override
  Future<dynamic> patch(
    String url,
    Object object,
    String? queryParameters,
  ) async {
    try {
      Response response = await dio.patch(
        url,
        data: object,
        options: await _options(),
        queryParameters:
            queryParameters == null ? null : jsonDecode(queryParameters),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
      }
    } catch (e) {
      if (e is DioException) {
        return e.response?.data;
      }
    }
  }

  @override
  Future<dynamic> put(
    String url,
    Object object,
  ) async {
    try {
      Response response = await dio.put(
        url,
        data: object,
        options: await _options(),
      );

      if (response.statusCode == 200) {
        return response.data ?? true;
      }
    } catch (e) {
      if (e is DioException) {
        return e.response?.data;
      }
    }
  }

  @override
  Future<dynamic> delete(
    String url,
    Object? object,
  ) async {
    try {
      Response response = await dio.delete(
        url,
        data: object,
        options: await _options(),
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        return true;
      }
    } catch (e) {
      if (e is DioException) {
        return e.response?.data;
      }
    }
  }

  @override
  Future<dynamic> upload(
    String url,
    FormData formData,
  ) async {
    try {
      Response response = await dio.post(
        url,
        data: formData,
        options: await _multipartOptions(),
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        return response.data;
      }
    } catch (e) {
      if (e is DioException) {
        return e.response?.data;
      }
    }
  }

  Future<Options> _options() async {
    String? token = await sl<LocalStorageRepositoryInterface>().getToken();

    return Options(
      headers: token == null
          ? {
              'Accept': 'application/json',
              'Content-Type': 'application/json',
            }
          : {
              'Accept': 'application/json',
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token'
            },
      followRedirects: false,
    );
  }

  Future<Options> _multipartOptions() async {
    String? token = await sl<LocalStorageRepositoryInterface>().getToken();

    return Options(
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'multipart/form-data',
        'Authorization': 'Bearer $token'
      },
      followRedirects: false,
    );
  }
}
