import 'package:izowork/components/components.dart';
import 'package:izowork/models/models.dart';
import 'package:izowork/api/api.dart';
import 'package:izowork/injection_container.dart';
import 'package:izowork/services/services.dart';

import 'dialog_repository.dart';

class DialogRepositoryImpl implements DialogRepositoryInterface {
  @override
  Future<dynamic> getChat({required String id}) async {
    dynamic json = await sl<WebServiceInterface>().get('$chatUrl?id=$id');

    try {
      return Chat.fromJson(json['chat']);
    } catch (e) {
      return ErrorResponse.fromJson(json);
    }
  }

  @override
  Future<dynamic> getMessages({
    required String id,
    required Pagination pagination,
  }) async {
    var url = messageUrl +
        '?&offset=${pagination.offset}&limit=${pagination.size}&chat_id=$id';

    dynamic json = await sl<WebServiceInterface>().get(url);
    List<Message> messages = [];

    try {
      json['messages'].forEach((element) {
        messages.add(Message.fromJson(element));
      });
      return messages;
    } catch (e) {
      return ErrorResponse.fromJson(json);
    }
  }

  @override
  Future<dynamic> readChatMessages(
          MessageReadRequest messageReadRequest) async =>
      await sl<WebServiceInterface>().patch(
        messageReadUrl,
        messageReadRequest.toJson(),
        null,
      );

  @override
  Future addChatFile(MessageFileRequest messageFileRequest) async =>
      await sl<WebServiceInterface>().postFormData(
        chatFileUrl,
        await messageFileRequest.toFormData(),
      );
}
