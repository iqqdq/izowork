import 'package:dio/dio.dart';
import 'package:izowork/components/components.dart';
import 'package:izowork/models/models.dart';

abstract class ContactRepositoryInterface {
  Future<dynamic> getContact(String? id);

  Future<dynamic> createContact(ContactRequest contactRequest);

  Future<dynamic> updateContact(ContactRequest contactRequest);

  Future<dynamic> deleteContact(DeleteRequest deleteRequest);

  Future<dynamic> updateAvatar(FormData formData);

  Future<dynamic> getContacts({
    required Pagination pagination,
    List<String>? params,
    String? search,
  });
}
