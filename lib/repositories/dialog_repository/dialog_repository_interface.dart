import 'package:izowork/components/components.dart';
import 'package:izowork/models/models.dart';

abstract class DialogRepositoryInterface {
  Future<dynamic> getChat({required String id});

  Future<dynamic> getMessages({
    required String id,
    required Pagination pagination,
  });

  Future<dynamic> readChatMessages(MessageReadRequest messageReadRequest);

  Future addChatFile(MessageFileRequest messageFileRequest);
}
