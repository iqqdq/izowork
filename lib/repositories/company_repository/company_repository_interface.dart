import 'package:dio/dio.dart';
import 'package:izowork/components/components.dart';
import 'package:izowork/models/models.dart';

abstract class CompanyRepositoryInterface {
  Future<dynamic> getCompanyTypes();

  Future<dynamic> getCompany(String id);

  Future<dynamic> createCompany(CompanyRequest companyRequest);

  Future<dynamic> updateCompany(CompanyRequest companyRequest);

  Future<dynamic> updateCompanyAvatar(FormData formData);

  Future<dynamic> getCompanyActions({
    required Pagination pagination,
    required String companyId,
    List<String>? params,
  });

  Future<dynamic> createCompanyAction(
      CompanyActionRequest companyActionRequest);

  Future<dynamic> updateCompanyAction(
      CompanyActionUpdateRequest companyActionUpdateRequest);

  Future<dynamic> deleteCompanyAction(DeleteRequest deleteRequest);
}
