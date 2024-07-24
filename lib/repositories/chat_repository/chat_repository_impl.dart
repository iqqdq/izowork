import 'package:izowork/components/components.dart';
import 'package:izowork/injection_container.dart';
import 'package:izowork/models/models.dart';
import 'package:izowork/api/api.dart';
import 'package:izowork/services/services.dart';

import 'chat_repository.dart';

class ChatRepositoryImpl implements ChatRepositoryInterface {
  @override
  Future<dynamic> getChats({
    required Pagination pagination,
    required String search,
    List<String>? params,
  }) async {
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

    dynamic json = await sl<WebServiceInterface>().get(url);
    List<Chat> chats = [];

    try {
      json['chats'].forEach((element) {
        chats.add(Chat.fromJson(element));
      });
      return chats;
    } catch (e) {
      return ErrorResponse.fromJson(json);
    }
  }

  @override
  Future<dynamic> getUnreadMessageCount() async {
    dynamic json = await sl<WebServiceInterface>().get(unreadMessageUrl);

    try {
      return json["count"] as int;
    } catch (e) {
      return ErrorResponse.fromJson(json);
    }
  }

  @override
  Future<dynamic> createDmChat({required ChatDmRequest chatDmRequest}) async {
    dynamic json = await sl<WebServiceInterface>().post(
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
