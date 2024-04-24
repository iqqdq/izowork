// ignore_for_file: avoid_function_literals_in_foreach_calls
import 'dart:io';
import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:izowork/components/loading_status.dart';
import 'package:izowork/components/pagination.dart';
import 'package:izowork/services/local_service.dart';
import 'package:izowork/entities/request/chat_dm_request.dart';
import 'package:izowork/entities/response/chat.dart';
import 'package:izowork/entities/response/user.dart';
import 'package:izowork/repositories/chat_repository.dart';
import 'package:izowork/repositories/user_repository.dart';
import 'package:izowork/screens/dialog/dialog_screen.dart';
import 'package:izowork/screens/profile/profile_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class ParticipantsViewModel with ChangeNotifier {
  final Chat chat;

  LoadingStatus loadingStatus = LoadingStatus.searching;

  String? userId;

  final List<User> _users = [];

  List<User> get users {
    return _users;
  }

  ParticipantsViewModel(this.chat) {
    getLocalService().then((value) =>
        getParticipantList(pagination: Pagination(offset: 0, size: 50)));
  }

  // MARK: -
  // MARK: - API CALL

  Future getParticipantList(
      {required Pagination pagination, String? search}) async {
    if (pagination.offset == 0) {
      loadingStatus = LoadingStatus.searching;
      _users.clear();

      Future.delayed(Duration.zero, () async {
        notifyListeners();
      });
    }

    await UserRepository()
        .getParticipants(pagination: pagination, id: chat.id, search: search)
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
              notifyListeners()
            });
  }

  Future createUserChat(BuildContext context, int index) async {
    loadingStatus = LoadingStatus.searching;
    notifyListeners();

    await ChatRepository()
        .createDmChat(chatDmRequest: ChatDmRequest(userId: _users[index].id))
        .then((response) => {
              if (response is Chat)
                {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              DialogScreenWidget(chat: response)))
                }
            })
        .then((value) =>
            {loadingStatus = LoadingStatus.completed, notifyListeners()});
  }

  // MARK: -
  // MARK: - PUSH

  void showProfileScreen(BuildContext context, User user) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ProfileScreenWidget(
                isMine: false, user: user, onPop: (user) => null)));
  }

  // MARK: -
  // MARK: - FUNCTIONS

  Future getLocalService() async {
    await LocalService().getUser().then((value) => {
          userId = value?.id,
        });
  }

  void openUrl(String url) async {
    if (url.isNotEmpty) {
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
          openBrowser(url);
        }
      } else {
        if (nativeUrl != null) {
          openBrowser(nativeUrl);
        } else {
          openBrowser(url);
        }
      }
    }
  }

  void openBrowser(String url) async {
    if (await canLaunchUrl(Uri.parse(url.replaceAll(' ', '')))) {
      launchUrl(Uri.parse(url.replaceAll(' ', '')));
    } else if (await canLaunchUrl(
        Uri.parse('https://' + url.replaceAll(' ', '')))) {
      launchUrl(Uri.parse('https://' + url.replaceAll(' ', '')));
    }
  }
}
