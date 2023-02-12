// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:flutter/material.dart';
import 'package:izowork/components/loading_status.dart';
import 'package:izowork/components/pagination.dart';
import 'package:izowork/entities/response/user.dart';
import 'package:izowork/repositories/user_repository.dart';

class SearchManagerViewModel with ChangeNotifier {
  LoadingStatus loadingStatus = LoadingStatus.searching;

  final List<User> _users = [];

  List<User> get users {
    return _users;
  }

  SearchManagerViewModel() {
    getUserList(pagination: Pagination(offset: 0, size: 50));
  }

  // MARK: -
  // MARK: - API CALL

  Future getUserList({required Pagination pagination, String? search}) async {
    if (pagination.offset == 0) {
      loadingStatus = LoadingStatus.searching;
      _users.clear();

      Future.delayed(Duration.zero, () async {
        notifyListeners();
      });
    }

    await UserRepository()
        .getUsers(pagination: pagination, search: search)
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
}
