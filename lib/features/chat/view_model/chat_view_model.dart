// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:flutter/material.dart';
import 'package:izowork/injection_container.dart';
import 'package:socket_io_client/socket_io_client.dart';

import 'package:izowork/components/components.dart';
import 'package:izowork/repositories/repositories.dart';

class ChatsViewModel with ChangeNotifier {
  LoadingStatus loadingStatus = LoadingStatus.searching;

  String? token;

  Socket? _socket;
  Socket? get socket => _socket;

  final List<Chat> _chats = [];
  List<Chat> get chats => _chats;

  // MARK: -
  // MARK: - API CALL

  Future connectSocket() async {
    _socket = io(
        'http://185.116.194.234/',
        OptionBuilder()
            .setTransports(['websocket']) // for Flutter or Dart VM
            .disableAutoConnect() // disable auto-connection
            .build());

    _socket?.connect();
  }

  Future getChatList({
    required Pagination pagination,
    required String search,
  }) async {
    if (pagination.offset == 0) {
      _chats.clear();

      if (search.isNotEmpty) {
        loadingStatus = LoadingStatus.searching;
        notifyListeners();
      }
    }

    await sl<ChatRepositoryInterface>()
        .getChats(
          pagination: pagination,
          search: search,
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
                {
                  loadingStatus = LoadingStatus.error,
                },
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
            })
        .whenComplete(() => notifyListeners());
  }

  // MARK: -
  // MARK: - FUNCTIONS

  Future getLocalStorageParams() async =>
      token = await sl<LocalStorageRepositoryInterface>().getToken();

  void clearUndreadMessageCount(int index) {
    _chats[index].unreadCount = 0;
    notifyListeners();
  }

  void replaceLastMassage(Message message) {
    for (var element in _chats) {
      if (element.id == message.chatId) {
        element.lastMessage = message;
        return;
      }
    }

    notifyListeners();
  }

  void clearChats() => _chats.clear();
}
