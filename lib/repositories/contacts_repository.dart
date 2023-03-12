import 'dart:convert';
import 'package:izowork/components/pagination.dart';
import 'package:izowork/entities/request/contact_request.dart';
import 'package:izowork/entities/request/delete_request.dart';
import 'package:izowork/entities/response/contact.dart';
import 'package:izowork/entities/response/error_response.dart';
import 'package:izowork/services/urls.dart';
import 'package:izowork/services/web_service.dart';

class ContactRepository {
  Future<dynamic> getContact(String? id) async {
    dynamic json =
        await WebService().get(id == null ? contactUrl : userUrl + '?id=$id');

    try {
      Contact contact = Contact.fromJson(json["contact"]);
      return contact;
    } catch (e) {
      return ErrorResponse.fromJson(json);
    }
  }

  Future<dynamic> createContact(ContactRequest contactRequest) async {
    dynamic json =
        await WebService().patch(contactCreateUrl, jsonEncode(contactRequest));

    try {
      return Contact.fromJson(json["contact"]);
    } catch (e) {
      return ErrorResponse.fromJson(json);
    }
  }

  Future<dynamic> updateContact(ContactRequest contactRequest) async {
    dynamic json =
        await WebService().patch(contactUpdateUrl, jsonEncode(contactRequest));

    try {
      return Contact.fromJson(json["contact"]);
    } catch (e) {
      return ErrorResponse.fromJson(json);
    }
  }

  Future<dynamic> deleteContact(DeleteRequest deleteRequest) async {
    dynamic json =
        await WebService().patch(contactDeleteUrl, jsonEncode(deleteRequest));

    if (json == true) {
      return json;
    } else {
      return ErrorResponse.fromJson(json).message ?? 'Ошибка';
    }
  }

  // Future<dynamic> updateContactAvatar(FormData formData) async {
  //   dynamic json = await WebService().put('uploadAvatarUrl', formData);

  //   try {
  //     return json["avatar"] as String;
  //   } catch (e) {
  //     return ErrorResponse.fromJson(json);
  //   }
  // }

  Future<dynamic> getContacts(
      {required Pagination pagination, String? search}) async {
    var url =
        contactsUrl + '?offset=${pagination.offset}&limit=${pagination.size}';

    if (search != null) {
      url += '&q=$search';
    }

    dynamic json = await WebService().get(url);
    List<Contact> contacts = [];

    try {
      json['contacts'].forEach((element) {
        contacts.add(Contact.fromJson(element));
      });
      return contacts;
    } catch (e) {
      return ErrorResponse.fromJson(json);
    }
  }
}
