// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:flutter/material.dart';
import 'package:izowork/components/loading_status.dart';
import 'package:izowork/components/pagination.dart';
import 'package:izowork/components/user_params.dart';
import 'package:izowork/entities/response/chat.dart';
import 'package:izowork/repositories/chat_repository.dart';
import 'package:izowork/screens/dialog/dialog_screen.dart';
import 'package:izowork/screens/staff/staff_screen.dart';
import 'package:socket_io_client/socket_io_client.dart';

class ChatViewModel with ChangeNotifier {
  LoadingStatus loadingStatus = LoadingStatus.empty;

  String? token;

  Socket? _socket;

  final List<Chat> _chats = [];

  Socket? get socket {
    return _socket;
  }

  List<Chat> get chats {
    return _chats;
  }

  // MARK: -
  // MARK: - API CALL

  Future getChatList(
      {required Pagination pagination, required String search}) async {
    if (pagination.offset == 0 && loadingStatus == LoadingStatus.empty) {
      loadingStatus = LoadingStatus.searching;
      _chats.clear();

      Future.delayed(Duration.zero, () async {
        notifyListeners();
      });
    }
    await ChatRepository()
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
              if (_chats.isNotEmpty)
                {
                  _chats.removeWhere((element) => element.lastMessage == null),
                  if (_chats.isNotEmpty)
                    {
                      _chats.sort((a, b) => b.lastMessage!.createdAt
                          .toLocal()
                          .compareTo(a.lastMessage!.createdAt.toLocal()))
                    }
                },
              notifyListeners()
            });
  }

  Future connectSocket() async {
    _socket = io(
        'http://185.116.194.234/',
        OptionBuilder()
            .setTransports(['websocket']) // for Flutter or Dart VM
            .disableAutoConnect() // disable auto-connection
            .build());

    _socket?.connect();
  }

  // MARK: -
  // MARK: - FUNCTIONS

  Future getUserParams() async {
    UserParams userParams = UserParams();
    token = await userParams.getToken();
  }

  void clearChats() {
    _chats.clear();
  }

  // MARK: -
  // MARK: - PUSH

  void showDialogScreen(BuildContext context, int index) {
    // CLEAR UNREAD MESSAGE COUNT
    _chats[index].unreadCount = 0;
    notifyListeners();

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DialogScreenWidget(
                socket: _socket,
                chat: _chats[index],
                onPop: (message) => {
                      // REPLACE LAST MESSAGE
                      _chats.forEach((element) {
                        if (element.id == message.chatId) {
                          element.lastMessage = message;
                        }
                      }),
                       Future.delayed(Duration.zero, () => notifyListeners())
                    })));
  }

  void showStaffScreen(BuildContext context) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const StaffScreenWidget()));
  }

  // void showMapFilterSheet(BuildContext context) {
  //  showCupertinoModalBottomSheet(
  // enableDrag: false,
  //     topRadius: const Radius.circular(16.0),
  //     barrierColor: Colors.black.withOpacity(0.6),
  //     backgroundColor: HexColors.white,
  //     context: context,
  //     builder: (context) => ChatFilterPageViewWidget(
  //         onApplyTap: () => {Navigator.pop(context)},
  //         onResetTap: () => {Navigator.pop(context)}));
  // }
}
