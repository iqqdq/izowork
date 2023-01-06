import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:izowork/components/loading_status.dart';
import 'package:izowork/screens/contacts/contacts_screen.dart';
import 'package:izowork/screens/staff/staff_screen.dart';

class MoreViewModel with ChangeNotifier {
  // LoadingStatus loadingStatus = LoadingStatus.searching;
  LoadingStatus loadingStatus = LoadingStatus.empty;

  // MARK: -
  // MARK: - FUNCTIONS

  Future setAvatar() async {
    final XFile? file =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (file != null) {
      // File(file.path);
      debugPrint(file.path);
    }
  }

  // MARK: -
  // MARK: - ACTIONS

  void showStaffScreen(BuildContext context) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const StaffScreenWidget()));
  }

  void showContactsScreen(BuildContext context) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const ContactsScreenWidget()));
  }
}
