// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:flutter/material.dart';
import 'package:izowork/components/components.dart';

import 'package:izowork/entities/responses/responses.dart';
import 'package:izowork/repositories/repositories.dart';

class SearchUserViewModel with ChangeNotifier {
  LoadingStatus loadingStatus = LoadingStatus.searching;

  final List<User> _users = [];

  List<User> get users => _users;

  SearchUserViewModel() {
    getUserList(pagination: Pagination(offset: 0, size: 50));
  }

  // MARK: -
  // MARK: - API CALL

  Future getUserList({
    required Pagination pagination,
    String? search,
  }) async {
    if (pagination.offset == 0) {
      _users.clear();
    }

    await UserRepository()
        .getUsers(
          pagination: pagination,
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
}
