// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:flutter/material.dart';
import 'package:izowork/entities/response/company_type.dart';
import 'package:izowork/repositories/company_repository.dart';
import 'package:izowork/screens/contacts/contacts_filter_sheet/contacts_filter_page_view_screen_body.dart';

class ContactsFilterViewModel with ChangeNotifier {
  final ContactsFilter? contactsFilter;

  List<String> options = ['А-Я', 'Я-А'];
  List<int> tags = [];

  List<String> options2 = [];
  List<int> tags2 = [];

  ContactsFilterViewModel(this.contactsFilter) {
    if (contactsFilter != null) {
      tags = contactsFilter!.tags;
      tags2 = contactsFilter!.tags2;
      notifyListeners();
    }

    getCompanyTypeList();
  }

  // MARK: -
  // MARK: - API CALL

  Future getCompanyTypeList() async {
    await CompanyRepository().getCompanyTypes().then((response) => {
          if (response is CompanyType)
            {
              response.states.forEach((element) {
                options2.add(element);
              }),
              notifyListeners()
            }
        });
  }

  // MARK: -
  // MARK: - FUNCTIONS

  void sortByAlphabet(int index) {
    if (tags.contains(index)) {
      tags.clear();
    } else {
      tags.clear();
      tags.add(index);
    }

    notifyListeners();
  }

  void sortByType(int index) {
    if (tags2.contains(index)) {
      tags2.clear();
    } else {
      tags2.clear();
      tags2.add(index);
    }
    notifyListeners();
  }

  Future apply(Function(List<String>) didReturnParams) async {
    String sortBy = '&sort_by=';
    String sortOrder = '&sort_order=';
    List<String> params = [];

    if (tags.isNotEmpty) {
      sortBy = sortBy + 'name';

      if (tags.first == 0) {
        sortOrder = sortOrder.contains('asc') || sortOrder.contains('desc')
            ? sortOrder + ',asc'
            : sortOrder = sortOrder + 'asc';
      } else {
        sortOrder = sortOrder.contains('asc') || sortOrder.contains('desc')
            ? sortOrder + ',desc'
            : sortOrder = sortOrder + 'desc';
      }
    }

    if (tags2.isNotEmpty) {
      params.add('&type=${options2[tags2.first]}');
    }

    if (sortBy != '&sort_by=') {
      params.add(sortBy);
    }

    if (sortOrder != '&sort_order=') {
      params.add(sortOrder);
    }

    didReturnParams(params);
  }

  void reset(VoidCallback onResetTap) {
    tags.clear();
    tags2.clear();
    notifyListeners();
    onResetTap();
  }
}
