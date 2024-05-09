import 'package:dio/dio.dart';
import 'package:izowork/components/components.dart';

import 'package:izowork/entities/requests/requests.dart';
import 'package:izowork/entities/responses/responses.dart';
import 'package:izowork/api/api.dart';
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
    dynamic json = await WebService().post(
      contactCreateUrl,
      contactRequest.toJson(),
    );

    try {
      return Contact.fromJson(json["contact"]);
    } catch (e) {
      return ErrorResponse.fromJson(json);
    }
  }

  Future<dynamic> updateContact(ContactRequest contactRequest) async {
    dynamic json = await WebService().patch(
      contactUpdateUrl,
      contactRequest.toJson(),
      null,
    );

    try {
      return Contact.fromJson(json["contact"]);
    } catch (e) {
      return ErrorResponse.fromJson(json);
    }
  }

  Future<dynamic> deleteContact(DeleteRequest deleteRequest) async {
    dynamic json = await WebService().delete(
      contactDeleteUrl,
      deleteRequest.toJson(),
    );

    if (json == true) {
      return json;
    } else {
      return ErrorResponse.fromJson(json);
    }
  }

  Future<dynamic> updateAvatar(FormData formData) async {
    dynamic json = await WebService().put(uploadContactAvatarUrl, formData);

    try {
      return json["avatar"] as String;
    } catch (e) {
      return ErrorResponse.fromJson(json);
    }
  }

  Future<dynamic> getContacts(
      {required Pagination pagination,
      List<String>? params,
      String? search}) async {
    var url =
        contactsUrl + '?offset=${pagination.offset}&limit=${pagination.size}';

    if (search != null) {
      url += '&q=$search';
    }

    if (params != null) {
      for (var element in params) {
        url += element;
      }
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
