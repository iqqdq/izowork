import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:izowork/api/api.dart';
import 'package:izowork/services/web_service.dart';

class FcmTokenRepository {
  Future<dynamic> sendFcmToken(String fcmToken) async {
    dynamic json = await WebService().patch(
      fcmTokenUrl,
      [],
      jsonEncode({"token": fcmToken}),
    );

    if (json != null) {
      debugPrint('SEND DEVICE TOKEN ERROR:\n${jsonEncode(json)}');
    }
  }
}
