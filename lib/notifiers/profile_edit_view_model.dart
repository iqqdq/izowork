import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';

import 'package:izowork/components/components.dart';
import 'package:izowork/repositories/repositories.dart';
import 'package:izowork/screens/profile_edit/profile_edit_screen_body.dart';

class ProfileEditViewModel with ChangeNotifier {
  final User currentUser;

  LoadingStatus loadingStatus = LoadingStatus.empty;
  User? _user;

  User? get user => _user;

  ProfileEditViewModel(this.currentUser) {
    _user = currentUser;
    notifyListeners();
  }

  // MARK: -
  // MARK: - API CALL

  Future changeUserInfo(
    String name,
    String post,
    String email,
    String phone,
    List<SocialInputModel> socials,
  ) async {
    loadingStatus = LoadingStatus.searching;
    notifyListeners();

    UserRequest userRequest = UserRequest();

    if (name.isNotEmpty && name != currentUser.name) {
      userRequest.name = name;
    }

    if (post.isNotEmpty && post != currentUser.post) {
      userRequest.post = post;
    }

    if (email.isNotEmpty && email != currentUser.email) {
      userRequest.email = email;
    }

    if (phone.isNotEmpty && phone != currentUser.phone) {
      userRequest.phone = phone;
    }

    List<String> social = [];

    for (var element in socials) {
      if (element.textEditingController.text.isNotEmpty) {
        social.add(element.textEditingController.text);
      }
    }

    if (social.isNotEmpty) {
      userRequest.social = social;
    }

    await UserRepository()
        .updateUser(userRequest)
        .then((response) => {
              if (response is User)
                {
                  _user = response,
                  Toast().showTopToast(Titles.changesSuccess),
                  loadingStatus = LoadingStatus.completed
                }
              else if (response is ErrorResponse)
                {
                  Toast().showTopToast(response.message ?? 'Ошибка'),
                  loadingStatus = LoadingStatus.error
                },
            })
        .whenComplete(() => notifyListeners());
  }

  Future changeAvatar(File file) async {
    loadingStatus = LoadingStatus.searching;
    notifyListeners();

    FormData formData = dio.FormData.fromMap({
      "avatar": await MultipartFile.fromFile(file.path,
          filename: file.path.substring(file.path.length - 8, file.path.length))
    });

    await UserRepository()
        .updateAvatar(formData)
        .then((response) => {
              if (response is String)
                {
                  _user?.avatar = response,
                  Toast().showTopToast(Titles.changesSuccess),
                  loadingStatus = LoadingStatus.completed
                }
              else if (response is ErrorResponse)
                {
                  loadingStatus = LoadingStatus.error,
                  Toast().showTopToast(response.message ?? 'Ошибка')
                }
            })
        .whenComplete(() => notifyListeners());
  }

  Future deleteAccount(BuildContext context) async {
    loadingStatus = LoadingStatus.searching;
    notifyListeners();

    await UserRepository()
        .deleteUser(id: _user?.id ?? currentUser.id)
        .then((response) async => {
              if (response == true)
                {
                  /// CLEAR LOCAL STORAGE
                  loadingStatus = LoadingStatus.completed,
                  await GetIt.I<LocalStorageRepositoryInterface>().clear(),
                }
              else if (response is ErrorResponse)
                {
                  loadingStatus = LoadingStatus.error,
                  Toast().showTopToast(response.message ?? 'Ошибка')
                }
            })
        .whenComplete(() => notifyListeners());
  }

  // MARK: -
  // MARK: - FUNCTIONS

  Future pickImage() async {
    final XFile? xFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );

    if (xFile != null) {
      changeAvatar(File(xFile.path));
    }
  }
}
