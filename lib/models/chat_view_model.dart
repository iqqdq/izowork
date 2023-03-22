// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:flutter/material.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/loading_status.dart';
import 'package:izowork/components/pagination.dart';
import 'package:izowork/entities/request/chat_dm_request.dart';
import 'package:izowork/entities/response/chat.dart';
import 'package:izowork/repositories/chats_repository.dart';
import 'package:izowork/screens/chat/chat_filter_sheet/chat_filter_page_view_widget.dart';
import 'package:izowork/screens/dialog/dialog_screen.dart';
import 'package:izowork/screens/staff/staff_screen.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ChatViewModel with ChangeNotifier {
  LoadingStatus loadingStatus = LoadingStatus.searching;

  final List<Chat> _chats = [];

  List<Chat> get chats {
    return _chats;
  }

  ChatViewModel() {
    getChatList(pagination: Pagination(offset: 50, size: 0), search: '');
  }

  // MARK: -
  // MARK: - API CALL

  Future getChatList(
      {required Pagination pagination, required String search}) async {
    if (pagination.offset == 0) {
      loadingStatus = LoadingStatus.searching;
      _chats.clear();

      Future.delayed(Duration.zero, () async {
        notifyListeners();
      });
    }
    await ChatsRepository()
        .getChats(
          pagination: pagination,
          search: search,
          // params: _chatsFilter?.params
        )
        .then((response) => {
              if (response is List<Chat>)
                {
                  if (_chats.isEmpty)
                    {
                      response.forEach((chat) {
                        _chats.add(chat);
                      })
                    }
                  else
                    {
                      response.forEach((newChat) {
                        bool found = false;

                        _chats.forEach((chat) {
                          if (newChat.id == chat.id) {
                            found = true;
                          }
                        });

                        if (!found) {
                          _chats.add(newChat);
                        }
                      })
                    },
                  loadingStatus = LoadingStatus.completed
                }
              else
                loadingStatus = LoadingStatus.error,
              notifyListeners()
            });
  }

  // MARK: -
  // MARK: - PUSH

  void showDialogScreen(BuildContext context, int index) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DialogScreenWidget(
                chat: _chats[index],
                onPop: (message) => {
                      _chats.forEach((element) {
                        if (element.id == message.chatId) {
                          element.lastMessage = message;
                          notifyListeners();
                        }
                      })
                    })));
  }

  void showStaffScreen(BuildContext context) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const StaffScreenWidget()));
  }

  void showMapFilterSheet(BuildContext context) {
    showCupertinoModalBottomSheet(
        topRadius: const Radius.circular(16.0),
        barrierColor: Colors.black.withOpacity(0.6),
        backgroundColor: HexColors.white,
        context: context,
        builder: (context) => ChatFilterPageViewWidget(
            onApplyTap: () => {Navigator.pop(context)},
            onResetTap: () => {Navigator.pop(context)}));
  }
}
