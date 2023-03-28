import 'package:izowork/components/pagination.dart';
import 'package:izowork/entities/request/chat_dm_request.dart';
import 'package:izowork/entities/response/chat.dart';
import 'package:izowork/entities/response/error_response.dart';
import 'package:izowork/services/urls.dart';
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
      return ErrorResponse.fromJson(json);
    }
  }

  Future<dynamic> createDmChat({required ChatDmRequest chatDmRequest}) async {
    dynamic json = await WebService().post(chatDmUrl, chatDmRequest);

    try {
      return Chat.fromJson(json["chat"]);
    } catch (e) {
      return ErrorResponse.fromJson(json);
    }
  }
}
