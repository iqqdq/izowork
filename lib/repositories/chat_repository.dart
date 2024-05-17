import 'package:flutter/material.dart';
import 'package:izowork/components/components.dart';
import 'package:izowork/models/models.dart';
import 'package:izowork/api/api.dart';
import 'package:izowork/services/web_service.dart';

class ChatRepository {
  Future<dynamic> getChats(
      {required Pagination pagination,
      required String search,
      List<String>? params}) async {
    var url =
        chatsUrl + '?offset=${pagination.offset}&limit=${pagination.size}';

    if (search.isNotEmpty) {
      url += '&q=$search';
    }

    if (params != null) {
      for (var element in params) {
        url += element;
      }
    }

    dynamic json = await WebService().get(url);
    List<Chat> chats = [];

    try {
      json['chats'].forEach((element) {
        chats.add(Chat.fromJson(element));
      });
      return chats;
    } catch (e) {
      var err = ErrorResponse.fromJson(json);
      debugPrint(err.message);
      return ErrorResponse.fromJson(json);
    }
  }

  Future<dynamic> getUnreadMessageCount() async {
    dynamic json = await WebService().get(unreadMessageUrl);

    try {
      return json["count"] as int;
    } catch (e) {
      return ErrorResponse.fromJson(json);
    }
  }

  Future<dynamic> createDmChat({required ChatDmRequest chatDmRequest}) async {
    dynamic json = await WebService().post(
      chatDmUrl,
      chatDmRequest.toJson(),
    );

    try {
      return Chat.fromJson(json["chat"]);
    } catch (e) {
      return ErrorResponse.fromJson(json);
    }
  }
}
