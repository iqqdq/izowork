import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:izowork/api/urls.dart';
import 'package:izowork/services/web_service.dart';

class FcmTokenRepository {
  Future<dynamic> sendDeviceToken(String deviceToken) async {
    dynamic json = await WebService().patch(
      fcmTokenUrl,
      [],
      jsonEncode({"token": deviceToken}),
    );

    if (json != null) {
      debugPrint('SEND DEVICE TOKEN ERROR:\n${jsonEncode(json)}');
    }
  }
}
