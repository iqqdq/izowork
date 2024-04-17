import 'package:izowork/components/pagination.dart';
import 'package:izowork/entities/request/message_file_request.dart';
import 'package:izowork/entities/request/message_read_request.dart';
import 'package:izowork/entities/response/error_response.dart';
import 'package:izowork/entities/response/message.dart';
import 'package:izowork/services/urls.dart';
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
