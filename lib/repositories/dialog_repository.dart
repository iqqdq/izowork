import 'package:izowork/components/components.dart';
import 'package:izowork/entities/requests/requests.dart';
import 'package:izowork/entities/responses/responses.dart';
import 'package:izowork/api/api.dart';
import 'package:izowork/services/web_service.dart';

class DialogRepository {
  Future<dynamic> getMessages({
    required Pagination pagination,
    required String id,
  }) async {
    var url = messageUrl +
        '?&offset=${pagination.offset}&limit=${pagination.size}&chat_id=$id';

    dynamic json = await WebService().get(url);
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

  Future<dynamic> readChatMessages(
      MessageReadRequest messageReadRequest) async {
    await WebService().patch(
      messageReadUrl,
      messageReadRequest.toJson(),
      null,
    );
  }

  Future addChatFile(MessageFileRequest messageFileRequest) async {
    await WebService().postFormData(
      chatFileUrl,
      await messageFileRequest.toFormData(),
    );
  }
}
