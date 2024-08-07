// ignore_for_file: avoid_function_literals_in_foreach_calls
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:android_intent_plus/android_intent.dart';

import 'package:izowork/components/components.dart';
import 'package:izowork/helpers/helpers.dart';
import 'package:izowork/injection_container.dart';
import 'package:izowork/repositories/repositories.dart';

class ParticipantsViewModel with ChangeNotifier {
  final Chat chat;

  LoadingStatus loadingStatus = LoadingStatus.searching;

  final List<User> _users = [];

  List<User> get users => _users;

  Chat? _newChat;

  Chat? get newChat => _newChat;

  ParticipantsViewModel(this.chat) {
    getParticipantList(pagination: Pagination());
  }

  // MARK: -
  // MARK: - API CALL

  Future getParticipantList({
    required Pagination pagination,
    String? search,
  }) async {
    if (pagination.offset == 0) {
      _users.clear();

      loadingStatus = LoadingStatus.searching;
      notifyListeners();
    }

    await sl<UserRepositoryInterface>()
        .getParticipants(
          pagination: pagination,
          id: chat.id,
          search: search,
        )
        .then((response) => {
              if (response is List<User>)
                {
                  if (_users.isEmpty)
                    {
                      response.forEach((user) {
                        _users.add(user);
                      })
                    }
                  else
                    {
                      response.forEach((newUser) {
                        bool found = false;

                        _users.forEach((user) {
                          if (newUser.id == user.id) {
                            found = true;
                          }
                        });

                        if (!found) {
                          _users.add(newUser);
                        }
                      })
                    },
                  loadingStatus = LoadingStatus.completed
                }
              else
                loadingStatus = LoadingStatus.error,
            })
        .whenComplete(() => notifyListeners());
  }

  Future createUserChat(String id) async {
    User? user = await sl<LocalStorageRepositoryInterface>().getUser();
    String? userId = user?.id;

    if (userId == id) return;

    loadingStatus = LoadingStatus.searching;
    notifyListeners();

    await sl<ChatRepositoryInterface>()
        .createDmChat(chatDmRequest: ChatDmRequest(userId: id))
        .then((response) => {
              if (response is Chat)
                _newChat = chat
              else if (response is ErrorResponse)
                Toast().showTopToast(response.message ?? 'Произошла ошибка')
            })
        .whenComplete(() {
      loadingStatus = LoadingStatus.completed;
      notifyListeners();
    });
  }

  // MARK: -
  // MARK: - FUNCTIONS

  void openUrl(String url) async {
    if (url.isNotEmpty) {
      WebViewHelper webViewHelper = WebViewHelper();
      String? nativeUrl;

      if (url.contains('t.me')) {
        nativeUrl = 'tg:resolve?domain=${url.replaceAll('t.me/', '')}';
      } else if (url.characters.first == '@') {
        nativeUrl = 'instagram://user?username=${url.replaceAll('@', '')}';
      }

      if (Platform.isAndroid) {
        if (nativeUrl != null) {
          AndroidIntent intent = AndroidIntent(
              action: 'android.intent.action.VIEW', data: nativeUrl);

          if ((await intent.canResolveActivity()) == true) {
            await intent.launch();
          }
        } else {
          webViewHelper.open(url);
        }
      } else {
        nativeUrl != null
            ? webViewHelper.open(nativeUrl)
            : webViewHelper.open(url);
      }
    }
  }
}
