import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:izowork/components/loading_status.dart';
import 'package:izowork/components/titles.dart';
import 'package:izowork/components/toast.dart';
import 'package:izowork/entities/request/user_request.dart';
import 'package:izowork/entities/response/error_response.dart';
import 'package:izowork/entities/response/user.dart';
import 'package:izowork/repositories/user_repository.dart';
import 'package:izowork/screens/profile_edit/profile_edit_screen_body.dart';

class ProfileEditViewModel with ChangeNotifier {
  final User currentUser;

  LoadingStatus loadingStatus = LoadingStatus.empty;
  User? _user;

  User? get user {
    return _user;
  }

  ProfileEditViewModel(this.currentUser) {
    _user = currentUser;
    notifyListeners();
  }

  // MARK: -
  // MARK: - API CALL

  Future changeUserInfo(BuildContext context, String name, String post,
      String email, String phone, List<SocialInputModel> socials) async {
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

    await UserRepository().updateUser(userRequest).then((response) => {
          if (response is User)
            {
              _user = response,
              Toast().showTopToast(context, Titles.changesSuccess),
              loadingStatus = LoadingStatus.completed
            }
          else if (response is ErrorResponse)
            {
              Toast().showTopToast(context, response.message ?? 'Ошибка'),
              loadingStatus = LoadingStatus.error
            },
          notifyListeners()
        });
  }

  Future changeAvatar(BuildContext context, File file) async {
    loadingStatus = LoadingStatus.searching;
    notifyListeners();

    FormData formData = dio.FormData.fromMap({
      "avatar": await MultipartFile.fromFile(file.path,
          filename: file.path.substring(file.path.length - 8, file.path.length))
    });

    await UserRepository().updateAvatar(formData).then((response) => {
          if (response is String)
            {
              _user?.avatar = response,
              Toast().showTopToast(context, Titles.changesSuccess),
              loadingStatus = LoadingStatus.completed
            }
          else if (response is ErrorResponse)
            {
              loadingStatus = LoadingStatus.error,
              Toast().showTopToast(context, response.message ?? 'Ошибка')
            },
          notifyListeners()
        });
  }

  // MARK: -
  // MARK: - FUNCTIONS

  Future pickImage(BuildContext context) async {
    final XFile? xFile = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 70);

    if (xFile != null) {
      changeAvatar(context, File(xFile.path));
    }
  }

  // MARK: -
  // MARK: - PUSH

}
