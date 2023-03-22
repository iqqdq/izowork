// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:flutter/material.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/loading_status.dart';
import 'package:izowork/components/pagination.dart';
import 'package:izowork/components/user_params.dart';
import 'package:izowork/entities/response/chat.dart';
import 'package:izowork/entities/response/message.dart';
import 'package:izowork/repositories/message_repository.dart';
import 'package:izowork/screens/dialog/views/dialog_add_task_widget.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:socket_io_client/socket_io_client.dart';

class DialogViewModel with ChangeNotifier {
  final Chat chat;

  LoadingStatus loadingStatus = LoadingStatus.searching;

  String? token;
  String? userId;

  Socket? _socket;

  final List<Message> _messages = [];

  Socket? get socket {
    return _socket;
  }

  List<Message> get messages {
    return _messages;
  }

  DialogViewModel(this.chat);

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
  // MARK: - API CALL

  Future getMessageList({required Pagination pagination}) async {
    if (pagination.offset == 0) {
      loadingStatus = LoadingStatus.searching;
      _messages.clear();

      Future.delayed(Duration.zero, () async {
        notifyListeners();
      });
    }
    await MessageRepository()
        .getMessages(pagination: pagination, id: chat.id)
        .then((response) => {
              if (response is List<Message>)
                {
                  if (_messages.isEmpty)
                    {
                      response.forEach((message) {
                        _messages.add(message);
                      })
                    }
                  else
                    {
                      response.forEach((newMessage) {
                        bool found = false;

                        _messages.forEach((message) {
                          if (newMessage.id == message.id) {
                            found = true;
                          }
                        });

                        if (!found) {
                          _messages.add(newMessage);
                        }
                      })
                    },
                  loadingStatus = LoadingStatus.completed
                }
              else
                {
                  loadingStatus = LoadingStatus.error,
                }
            })
        .then((value) => notifyListeners());
  }

  // MARK: -
  // MARK: - FUNCTIONS

  Future getUserParams() async {
    UserParams userParams = UserParams();
    token = await userParams.getToken();
    userId = await userParams.getUserId();
  }

  // MARK: -
  // MARK: - PUSH

  void showAddTaskSheet(BuildContext context, bool isMine, bool isFile,
      bool isAudio, bool isGroupLastMessage, String text, DateTime dateTime) {
    showCupertinoModalBottomSheet(
        topRadius: const Radius.circular(16.0),
        barrierColor: Colors.black.withOpacity(0.6),
        backgroundColor: HexColors.white,
        context: context,
        builder: (context) => DialogAddTaskWidget(
            isMine: isMine,
            isFile: isFile,
            isAudio: isAudio,
            isGroupLastMessage: isGroupLastMessage,
            dateTime: dateTime,
            text: text,
            onTap: () => {
                  // TODO ADD MAP OBJECT
                  Navigator.pop(context)
                }));
  }
}
