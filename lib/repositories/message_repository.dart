import 'package:izowork/components/pagination.dart';
import 'package:izowork/entities/response/error_response.dart';
import 'package:izowork/entities/response/message.dart';
import 'package:izowork/services/urls.dart';
import 'package:izowork/services/web_service.dart';

class MessageRepository {
  Future<dynamic> getMessages(
      {required Pagination pagination, required String id}) async {
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
}
