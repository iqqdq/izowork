import 'package:izowork/components/components.dart';
import 'package:izowork/models/models.dart';

abstract class ChatRepositoryInterface {
  Future<dynamic> getChats({
    required Pagination pagination,
    required String search,
    List<String>? params,
  });

  Future<dynamic> getUnreadMessageCount();

  Future<dynamic> createDmChat({required ChatDmRequest chatDmRequest});
}
