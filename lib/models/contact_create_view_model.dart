import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/loading_status.dart';
import 'package:izowork/components/titles.dart';
import 'package:izowork/components/toast.dart';
import 'package:izowork/entities/request/contact_request.dart';
import 'package:izowork/entities/request/delete_request.dart';
import 'package:izowork/entities/response/company.dart';
import 'package:izowork/entities/response/contact.dart';
import 'package:izowork/entities/response/error_response.dart';
import 'package:izowork/repositories/contacts_repository.dart';
import 'package:izowork/screens/profile_edit/profile_edit_screen_body.dart';
import 'package:izowork/screens/search_company/search_company_screen.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ContactCreateViewModel with ChangeNotifier {
  final Contact? selectedContact;
  final Function(Contact)? onDelete;

  LoadingStatus loadingStatus = LoadingStatus.empty;

  Contact? _contact;

  Company? _company;

  Contact? get contact {
    return _contact;
  }

  Company? get company {
    return _company;
  }

  ContactCreateViewModel(this.selectedContact, this.onDelete) {
    _contact = selectedContact;
    _company = selectedContact?.company;
    notifyListeners();
  }

  // MARK: -
  // MARK: - API CALL

  Future createNewContact(BuildContext context, String name, String post,
      String email, String phone, List<SocialInputModel> socials) async {
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
                  Toast().showTopToast(
                      context, '${Titles.contact} ${response.name} добавлен'),
                  loadingStatus = LoadingStatus.completed
                }
              else if (response is ErrorResponse)
                {
                  Toast().showTopToast(context, response.message ?? 'Ошибка'),
                  loadingStatus = LoadingStatus.error
                }
            })
        .then((value) => notifyListeners());
  }

  Future changeContactInfo(BuildContext context, String name, String post,
      String email, String phone, List<SocialInputModel> socials) async {
    loadingStatus = LoadingStatus.searching;
    notifyListeners();

    ContactRequest contactRequest =
        ContactRequest(id: _company?.id, companyId: company?.id);

    if (name.isNotEmpty && name != selectedContact?.name) {
      contactRequest.name = name;
    }

    if (post.isNotEmpty && post != selectedContact?.post) {
      contactRequest.post = post;
    }

    if (email.isNotEmpty && email != selectedContact?.email) {
      contactRequest.email = email;
    }

    if (phone.isNotEmpty && phone != selectedContact?.phone) {
      contactRequest.phone = phone;
    }

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
        .updateContact(contactRequest)
        .then((response) => {
              if (response is Contact)
                {
                  _contact = response,
                  Toast().showTopToast(context, Titles.changesSuccess),
                  loadingStatus = LoadingStatus.completed
                }
              else if (response is ErrorResponse)
                {
                  Toast().showTopToast(context, response.message ?? 'Ошибка'),
                  loadingStatus = LoadingStatus.error
                }
            })
        .then((value) => notifyListeners());
  }

  // Future changeAvatar(BuildContext context, File file) async {
  //   loadingStatus = LoadingStatus.searching;
  //   notifyListeners();

  //   FormData formData = dio.FormData.fromMap({
  //     "avatar": await MultipartFile.fromFile(file.path,
  //         filename: file.path.substring(file.path.length - 8, file.path.length))
  //   });

  //   await UserRepository()
  //       .updateAvatar(formData)
  //       .then((response) => {
  //             if (response is String)
  //               {
  //                 _contact?.avatar = response,
  //                 Toast().showTopToast(context, Titles.changesSuccess),
  //                 loadingStatus = LoadingStatus.completed
  //               }
  //             else if (response is ErrorResponse)
  //               {
  //                 loadingStatus = LoadingStatus.error,
  //                 Toast().showTopToast(context, response.message ?? 'Ошибка')
  //               }
  //           })
  //       .then((value) => notifyListeners());
  // }

  Future delete(BuildContext context) async {
    loadingStatus = LoadingStatus.searching;
    notifyListeners();

    int count = 0;

    await ContactRepository()
        .deleteContact(DeleteRequest(id: _contact!.id))
        .then((value) => {
              Toast().showTopToast(context, Titles.contactWasDeleted),
              onDelete == null
                  ? debugPrint('Nothing to delete')
                  : onDelete!(_contact!),
              Navigator.popUntil(context, (route) => count++ >= 2)
            });
  }

  // MARK: -
  // MARK: - PUSH

  void showSearchCompanySheet(BuildContext context) {
    showCupertinoModalBottomSheet(
        topRadius: const Radius.circular(16.0),
        barrierColor: Colors.black.withOpacity(0.6),
        backgroundColor: HexColors.white,
        context: context,
        builder: (context) => SearchCompanyScreenWidget(
            title: Titles.company,
            isRoot: true,
            onFocus: () => {},
            onPop: (company) => {
                  _company = company,
                  notifyListeners(),
                  Navigator.pop(context)
                }));
  }

  // MARK: -
  // MARK: - FUNCTIONS

  Future pickImage(BuildContext context) async {
    final XFile? xFile = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 70);

    if (xFile != null) {
      // changeAvatar(context, File(xFile.path));
    }
  }
}
