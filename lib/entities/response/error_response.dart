import 'dart:convert';

ErrorResponse errorResponseFromJson(String str) =>
    ErrorResponse.fromJson(json.decode(str));

class ErrorResponse {
  ErrorResponse({
    required this.statusCode,
    this.message,
  });

  int statusCode;
  String? message;

  factory ErrorResponse.fromJson(Map<String, dynamic> json) => ErrorResponse(
        statusCode: json["status_code"],
        message: json["message"] ?? '',
      );
}
