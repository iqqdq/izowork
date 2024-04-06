import 'dart:convert';
import 'package:dio/dio.dart';
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
        await WebService().post(contactCreateUrl, jsonEncode(contactRequest));

    try {
      return Contact.fromJson(json["contact"]);
    } catch (e) {
      return ErrorResponse.fromJson(json);
    }
  }

  Future<dynamic> updateContact(ContactRequest contactRequest) async {
    dynamic json = await WebService().patch(contactUpdateUrl, contactRequest);

    try {
      return Contact.fromJson(json["contact"]);
    } catch (e) {
      return ErrorResponse.fromJson(json);
    }
  }

  Future<dynamic> deleteContact(DeleteRequest deleteRequest) async {
    dynamic json = await WebService().delete(
      contactDeleteUrl,
      jsonEncode(deleteRequest),
    );

    if (json == true) {
      return json;
    } else {
      return ErrorResponse.fromJson(json).message ?? 'Ошибка';
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
