import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:izowork/components/components.dart';
import 'package:izowork/repositories/repositories.dart';
import 'package:izowork/screens/profile_edit/profile_edit_screen_body.dart';

class ContactCreateViewModel with ChangeNotifier {
  final Company? selectedCompany;

  final Contact? selectedContact;

  final Function(Contact)? onDelete;

  LoadingStatus loadingStatus = LoadingStatus.empty;

  Contact? _contact;

  Contact? get contact => _contact;

  Company? _company;

  Company? get company => _company;

  File? _file;

  File? get file => _file;

  ContactCreateViewModel(
    this.selectedCompany,
    this.selectedContact,
    this.onDelete,
  ) {
    _contact = selectedContact;
    _company = selectedCompany ?? selectedContact?.company;
    notifyListeners();
  }

  // MARK: -
  // MARK: - API CALL

  Future createNewContact(
    String name,
    String post,
    String email,
    String phone,
    List<SocialInputModel> socials,
  ) async {
    loadingStatus = LoadingStatus.searching;
    notifyListeners();

    ContactRequest contactRequest = ContactRequest(
      name: name,
      email: email,
      phone: phone,
      post: post,
      companyId: _company?.id,
    );

    List<String> social = [];

    for (var element in socials) {
      if (element.textEditingController.text.isNotEmpty) {
        social.add(element.textEditingController.text);
      }
    }

    if (social.isNotEmpty) {
      contactRequest.social = social;
    }

    await ContactRepository()
        .createContact(contactRequest)
        .then((response) => {
              if (response is Contact)
                {
                  _contact = response,
                  if (_file == null)
                    {
                      Toast().showTopToast(
                          '${Titles.contact} ${response.name} добавлен'),
                      loadingStatus = LoadingStatus.completed
                    }
                  else
                    {
                      changeAvatar(
                        response.id,
                        _file!,
                      ).then((value) => {
                            Toast().showTopToast(
                                '${Titles.contact} ${response.name} добавлен'),
                            loadingStatus = LoadingStatus.completed
                          })
                    }
                }
              else if (response is ErrorResponse)
                {
                  Toast().showTopToast(response.message ?? 'Произошла ошибка'),
                  loadingStatus = LoadingStatus.error
                }
            })
        .whenComplete(() => notifyListeners());
  }

  Future updateContactInfo(
    String name,
    String post,
    String email,
    String phone,
    List<SocialInputModel> socials,
  ) async {
    loadingStatus = LoadingStatus.searching;
    notifyListeners();

    ContactRequest contactRequest =
        ContactRequest(id: selectedContact!.id, companyId: company?.id);

    if (name.isNotEmpty && name != selectedContact?.name) {
      contactRequest.name = name;
    } else {
      contactRequest.name = selectedContact?.name;
    }

    if (post.isNotEmpty && post != selectedContact?.post) {
      contactRequest.post = post;
    } else {
      contactRequest.post = selectedContact?.post;
    }

    if (email.isNotEmpty && email != selectedContact?.email) {
      contactRequest.email = email;
    } else {
      contactRequest.email = selectedContact?.email;
    }

    if (phone.isNotEmpty && phone != selectedContact?.phone) {
      contactRequest.phone = phone;
    } else {
      contactRequest.phone = selectedContact?.phone;
    }

    List<String> social = [];

    for (var element in socials) {
      if (element.textEditingController.text.isNotEmpty) {
        social.add(element.textEditingController.text);
      }
    }

    if (social.isNotEmpty) {
      contactRequest.social = social;
    } else {
      contactRequest.social = selectedContact?.social;
    }

    await ContactRepository()
        .updateContact(contactRequest)
        .then((response) => {
              if (response is Contact)
                {
                  _contact = response,
                  Toast().showTopToast(Titles.changesSuccess),
                  loadingStatus = LoadingStatus.completed
                }
              else if (response is ErrorResponse)
                {
                  Toast().showTopToast(response.message ?? 'Произошла ошибка'),
                  loadingStatus = LoadingStatus.error
                }
            })
        .whenComplete(() => notifyListeners());
  }

  Future changeAvatar(
    String id,
    File file,
  ) async {
    loadingStatus = LoadingStatus.searching;
    notifyListeners();

    FormData formData = dio.FormData.fromMap({
      "id": id,
      "avatar": await MultipartFile.fromFile(file.path,
          filename: file.path.substring(file.path.length - 8, file.path.length))
    });

    await ContactRepository()
        .updateAvatar(formData)
        .then((response) => {
              if (response is String)
                {
                  _contact?.avatar = response,
                  loadingStatus = LoadingStatus.completed
                }
              else if (response is ErrorResponse)
                {
                  loadingStatus = LoadingStatus.error,
                  Toast().showTopToast(response.message ?? 'Произошла ошибка')
                }
            })
        .whenComplete(() => notifyListeners());
  }

  Future delete() async {
    loadingStatus = LoadingStatus.searching;
    notifyListeners();

    await ContactRepository()
        .deleteContact(DeleteRequest(id: _contact!.id))
        .whenComplete(() => {
              Toast().showTopToast(Titles.contactWasDeleted),
              onDelete == null
                  ? debugPrint('Nothing to delete')
                  : onDelete!(_contact!),
            });
  }

  // MARK: -
  // MARK: - FUNCTIONS

  void changeCompany(Company? company) {
    _company = company;
    notifyListeners();
  }

  Future pickImage() async {
    final XFile? xFile = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 70);

    if (xFile != null) {
      if (selectedContact == null) {
        _file = File(xFile.path);
        notifyListeners();
      } else {
        changeAvatar(
          selectedContact!.id,
          File(xFile.path),
        );
      }
    }
  }
}
