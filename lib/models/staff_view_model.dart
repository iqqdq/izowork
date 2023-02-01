// ignore_for_file: avoid_function_literals_in_foreach_calls
import 'package:flutter/material.dart';
import 'package:izowork/components/loading_status.dart';
import 'package:izowork/components/pagination.dart';
import 'package:izowork/entities/response/user.dart';
import 'package:izowork/repositories/user_repository.dart';
import 'package:izowork/screens/dialog/dialog_screen.dart';
import 'package:izowork/screens/profile/profile_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class StaffViewModel with ChangeNotifier {
  LoadingStatus loadingStatus = LoadingStatus.searching;

  final List<User> _users = [];

  List<User> get users {
    return _users;
  }

  StaffViewModel() {
    getUserList(Pagination(offset: 0, size: 50), '');
  }

  // MARK: -
  // MARK: - API CALL

  Future getUserList(Pagination pagination, String search) async {
    if (pagination.offset == 0) {
      loadingStatus = LoadingStatus.searching;
      _users.clear();

      Future.delayed(Duration.zero, () async {
        notifyListeners();
      });
    }

    await UserRepository().getUsers(pagination, search).then((response) => {
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

  // MARK: -
  // MARK: - PUSH

  void showProfileScreen(BuildContext context, User user) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                ProfileScreenWidget(user: user, onPop: (user) => null)));
  }

  void showDialogScreen(BuildContext context) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const DialogScreenWidget()));
  }

  // MARK: -
  // MARK: - FUNCTIONS

  void openUrl(String url) async {
    if (await canLaunchUrl(Uri.parse(url.replaceAll(' ', '')))) {
      launchUrl(Uri.parse(url.replaceAll(' ', '')));
    } else {
      if (await canLaunchUrl(Uri.parse('https://' + url.replaceAll(' ', '')))) {
        launchUrl(Uri.parse('https://' + url.replaceAll(' ', '')));
      } else {
        if (await canLaunchUrl(
            Uri.parse('https://' + url.replaceAll(' ', '')))) {
          launchUrl(Uri.parse('https://' + url.replaceAll(' ', '')));
        }
      }
    }
  }
}
