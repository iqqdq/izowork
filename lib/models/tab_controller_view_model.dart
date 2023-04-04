import 'package:flutter/material.dart';
import 'package:izowork/components/loading_status.dart';
import 'package:izowork/repositories/chat_repository.dart';

class TabControllerViewModel with ChangeNotifier {
  LoadingStatus loadingStatus = LoadingStatus.completed;

  int _messageCount = 0;

  int get messageCount {
    return _messageCount;
  }

  TabControllerViewModel() {
    getUnreadMessageCount();
  }

  // MARK: -
  // MARK: - API CALLS

  Future getUnreadMessageCount() async {
    await ChatRepository().getUnreadMessageCount().then((response) => {
          if (response is int) {_messageCount = response, notifyListeners()}
        });
  }

  // MARK: -
  // MARK: - FUNCTIONS

  void clearMessageBadge() {
    _messageCount = 0;
    notifyListeners();
  }
}
