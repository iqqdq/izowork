// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/loading_status.dart';
import 'package:izowork/components/pagination.dart';
import 'package:izowork/components/titles.dart';
import 'package:izowork/components/toast.dart';
import 'package:izowork/components/user_params.dart';
import 'package:izowork/entities/request/message_file_request.dart';
import 'package:izowork/entities/request/message_read_request.dart';
import 'package:izowork/entities/response/chat.dart';
import 'package:izowork/entities/response/error_response.dart';
import 'package:izowork/entities/response/message.dart';
import 'package:izowork/repositories/dialog_repository.dart';
import 'package:izowork/screens/dialog/views/dialog_add_task_widget.dart';
import 'package:izowork/screens/participants/participants_screen.dart';
import 'package:izowork/screens/profile/profile_screen.dart';
import 'package:izowork/screens/task_create/task_create_screen.dart';
import 'package:izowork/services/urls.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:open_filex/open_filex.dart';
import 'package:record/record.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io' as dartio;

class DialogViewModel with ChangeNotifier {
  final Socket? socket;
  final Chat chat;
  final record = Record();

  LoadingStatus loadingStatus = LoadingStatus.searching;

  String? token;

  String? userId;

  int current = 0;

  Socket? _socket;

  bool _isSending = false;

  int _downloadIndex = -1;

  final List<Message> _messages = [];

  Socket? get newSocket {
    return _socket;
  }

  List<Message> get messages {
    return _messages;
  }

  bool get isSending {
    return _isSending;
  }

  int get downloadIndex {
    return _downloadIndex;
  }

  DialogViewModel(this.socket, this.chat);

  Future connectSocket() async {
    _socket = socket;

    if (socket == null) {
      _socket = io(
              'http://185.116.194.234/',
              OptionBuilder()
                  .setTransports(['websocket']) // for Flutter or Dart VM
                  .disableAutoConnect() // disable auto-connection
                  .build())
          .connect();
    }
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

    await DialogRepository()
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
        .then((value) => readMessages());
  }

  Future readMessages() async {
    await DialogRepository()
        .readChatMessages(MessageReadRequest(chatId: chat.id))
        .then((value) => notifyListeners());
  }

  Future uploadFile(
    BuildContext context,
    File file,
    bool isVoice,
  ) async {
    await DialogRepository()
        .addChatFile(MessageFileRequest(
          chat.id,
          file,
          isVoice,
        ))
        .then((response) => {
              // SHOW AUDIO BUTTON INSTEAD INDICATOR
              _isSending = false,
              notifyListeners(),

              // SHOW ERROR
              if (response is ErrorResponse)
                {
                  loadingStatus = LoadingStatus.error,
                  Toast().showTopToast(context, response.message ?? 'Ошибка')
                }
            });
  }

  // MARK: -
  // MARK: - FUNCTIONS

  Future getUserParams() async {
    UserParams userParams = UserParams();
    token = await userParams.getToken();
    userId = await userParams.getUserId();
  }

  Future<String> getLocalAudioPath() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path + '/audio_message.m4a';

    return path;
  }

  /// AUDIO

  Future clearAudio() async {
    /// CLEAR RECENT AUDIO
    File file = File(await getLocalAudioPath());

    if (await file.exists()) {
      file.delete();
    }
  }

  void recordAudio() async {
    await clearAudio();

    /// RECORD AUDIO
    if (await record.hasPermission()) {
      await record.start(
          path: await getLocalAudioPath(),
          encoder: AudioEncoder.aacLc,
          bitRate: 128000,
          samplingRate: 44100);
    }
  }

  Future cancelRecordAudio() async {
    if (await record.isRecording()) await record.stop();
  }

  void sendAudioMessage(BuildContext context) async {
    final path = await record.stop();

    if (path != null) {
      // SHOW INDICATOR INSTEAD AUDIO BUTTON
      _isSending = true;
      notifyListeners();

      Future.delayed(
          const Duration(milliseconds: 100),
          () => uploadFile(
                context,
                File(path),
                true,
              ));
    }
  }

  /// FILE

  Future openFile(BuildContext context, int index, Message message) async {
    String url = messageMediaUrl + (message.files.first.filename ?? '');

    if (Platform.isAndroid) {
      Directory appDocumentsDirectory =
          await getApplicationDocumentsDirectory();
      String appDocumentsPath = appDocumentsDirectory.path;
      String fileName = message.files.first.name;
      String filePath = '$appDocumentsPath/$fileName';
      bool isFileExists = await dartio.File(filePath).exists();

      if (!isFileExists) {
        _downloadIndex = index;
        notifyListeners();

        await Dio().download(url, filePath, onReceiveProgress: (count, total) {
          debugPrint('---Download----Rec: $count, Total: $total');
        }).then((value) => {_downloadIndex = -1, notifyListeners()});
      }

      OpenResult openResult = await OpenFilex.open(filePath);

      if (openResult.type == ResultType.noAppToOpen) {
        Toast().showTopToast(context, Titles.unsupportedFileFormat);
      }
    } else {
      if (await canLaunchUrl(Uri.parse(url.replaceAll(' ', '')))) {
        launchUrl(Uri.parse(url.replaceAll(' ', '')));
      } else if (await canLaunchUrl(
          Uri.parse('https://' + url.replaceAll(' ', '')))) {
        launchUrl(Uri.parse('https://' + url.replaceAll(' ', '')));
      }
    }
  }

  Future addFile(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowMultiple: true,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf', 'doc']);

    if (result != null) {
      if (result.files.isNotEmpty) {
        loadingStatus = LoadingStatus.searching;
        notifyListeners();

        result.files.forEach((element) async {
          if (element.path != null) {
            await uploadFile(
              context,
              File(element.path!),
              false,
            ).then((value) => {
                  current++,
                  if (current == result.files.length)
                    {
                      loadingStatus = LoadingStatus.completed,
                      notifyListeners(),
                    }
                });
          }
        });
      }
    }
  }

  // MARK: -
  // MARK: - PUSH

  void showGroupChatUsersScreen(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ParticipantsScreenWidget(chat: chat)));
  }

  void showAddTaskSheet(BuildContext context, String text) {
    showCupertinoModalBottomSheet(
        enableDrag: false,
        topRadius: const Radius.circular(16.0),
        barrierColor: Colors.black.withOpacity(0.6),
        backgroundColor: HexColors.white,
        context: context,
        builder: (context) => DialogAddTaskWidget(
            text: text,
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => TaskCreateScreenWidget(
                        message: text,
                        onCreate: (task) => Toast().showTopToast(context,
                            '${Titles.task} "${task?.name}" создана'))))));
  }

  void showProfileScreen(BuildContext context, Message message) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ProfileScreenWidget(
                isMine: false, user: message.user!, onPop: (user) => null)));
  }
}
