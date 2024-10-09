// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:path_provider/path_provider.dart';

import 'package:izowork/injection_container.dart';
import 'package:izowork/services/services.dart';
import 'package:izowork/components/components.dart';
import 'package:izowork/repositories/repositories.dart';
import 'package:izowork/api/api.dart';

class DialogViewModel with ChangeNotifier {
  LoadingStatus loadingStatus = LoadingStatus.searching;

  final String id;
  final Socket? chatSocket;
  final record = AudioRecorder();

  String? token;
  String? userId;

  Chat? _chat;
  Chat? get chat => _chat;

  Socket? _socket;
  Socket? get socket => _socket;

  final List<Message> _messages = [];
  List<Message> get messages => _messages;

  bool _isSending = false;
  bool get isSending => _isSending;

  int _downloadIndex = -1;
  int get downloadIndex => _downloadIndex;

  DialogViewModel(
    this.id,
    this.chatSocket,
  );

  // MARK: -
  // MARK: - API CALL

  Future connectSocket() async {
    _socket = chatSocket ??
        io(
            'http://185.116.194.234/',
            OptionBuilder()
                .setTransports(['websocket']) // for Flutter or Dart VM
                .disableAutoConnect() // disable auto-connection
                .build());

    _socket?.connect();
  }

  Future getChatById() async {
    await sl<DialogRepositoryInterface>().getChat(id: id).then((response) => {
          if (response is Chat)
            {
              loadingStatus = LoadingStatus.completed,
              _chat = response,
            }
          else if (response is ErrorResponse)
            {
              loadingStatus = LoadingStatus.error,
              Toast().showTopToast(response.message ?? 'Произошла ошибка')
            }
        });
  }

  Future getMessageList({required Pagination pagination}) async {
    if (pagination.offset == 0) {
      _messages.clear();
    }

    await sl<DialogRepositoryInterface>()
        .getMessages(
          id: id,
          pagination: pagination,
        )
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
              else if (response is ErrorResponse)
                {
                  loadingStatus = LoadingStatus.error,
                  Toast().showTopToast(response.message ?? 'Произошла ошибка')
                }
            })
        .then((value) => readMessages());
  }

  Future readMessages() async {
    await sl<DialogRepositoryInterface>()
        .readChatMessages(MessageReadRequest(chatId: id))
        .whenComplete(() => notifyListeners());
  }

  Future uploadFile(
    File file,
    bool isVoice,
  ) async {
    await sl<DialogRepositoryInterface>()
        .addChatFile(MessageFileRequest(
          id,
          file,
          isVoice,
        ))
        .then((response) => {
              // SHOW AUDIO BUTTON INSTEAD INDICATOR
              _isSending = false,
              notifyListeners(),

              if (response is ErrorResponse)
                {
                  loadingStatus = LoadingStatus.error,
                  Toast().showTopToast(response.message ?? 'Произошла ошибка')
                }
            });
  }

  // MARK: -
  // MARK: - FUNCTIONS

  Future getLocalStorageParams() async {
    final localStorageService = sl<LocalStorageRepositoryInterface>();
    token = await localStorageService.getToken();

    User? user = await localStorageService.getUser();
    userId = user?.id;
  }

  Future<String> getLocalAudioPath() async =>
      (await getApplicationDocumentsDirectory()).path + '/audio_message.m4a';

  Future clearAudio() async {
    /// CLEAR RECENT AUDIO
    File file = File(await getLocalAudioPath());

    if (await file.exists()) file.delete();
  }

  void recordAudio() async {
    await clearAudio();

    /// RECORD AUDIO
    if (await record.hasPermission()) {
      record.start(
        const RecordConfig(),
        path: await getLocalAudioPath(),
      );

      // await record.start(
      //   path: await getLocalAudioPath(),
      //   encoder: AudioEncoder.aacLc,
      //   bitRate: 128000,
      //   samplingRate: 44100,
      // );
    }
  }

  Future cancelRecordAudio() async {
    if (await record.isRecording()) await record.stop();
  }

  void sendAudioMessage() async {
    final path = await record.stop();

    if (path != null) {
      // SHOW INDICATOR INSTEAD AUDIO BUTTON
      _isSending = true;
      notifyListeners();

      Future.delayed(
          const Duration(milliseconds: 100),
          () => uploadFile(
                File(path),
                true,
              ));
    }
  }

  /// FILE

  Future openFile(
    int index,
    Message message,
  ) async {
    final filename = message.files.first.filename;
    if (filename == null) return;

    await sl<FileDownloadServiceInterface>().download(
        url: messageMediaUrl + filename,
        filename: filename,
        onDownload: () => {
              _downloadIndex = index,
              notifyListeners(),
            },
        onComplete: () => {
              _downloadIndex = -1,
              notifyListeners(),
            });
  }

  Future addFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowMultiple: true,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf', 'doc'],
    );

    if (result != null) {
      if (result.files.isNotEmpty) {
        loadingStatus = LoadingStatus.searching;
        notifyListeners();

        int current = 0;

        result.files.forEach((element) async {
          if (element.path != null) {
            await uploadFile(
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
}
