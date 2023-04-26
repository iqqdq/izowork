import 'package:flutter/material.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/loading_status.dart';
import 'package:izowork/components/titles.dart';
import 'package:izowork/components/user_params.dart';
import 'package:izowork/entities/response/user.dart';
import 'package:izowork/repositories/user_repository.dart';
import 'package:izowork/screens/analytics/analytics_page_view_screen.dart';
import 'package:izowork/screens/authorization/authorization_screen.dart';
import 'package:izowork/screens/companies/companies_screen.dart';
import 'package:izowork/screens/contacts/contacts_screen.dart';
import 'package:izowork/screens/documents/documents_screen.dart';
import 'package:izowork/screens/news/news_screen.dart';
import 'package:izowork/screens/notifications/notifications_screen.dart';
import 'package:izowork/screens/products/products_screen.dart';
import 'package:izowork/screens/profile/profile_screen.dart';
import 'package:izowork/screens/staff/staff_screen.dart';

class MoreViewModel with ChangeNotifier {
  final int count;

  LoadingStatus loadingStatus = LoadingStatus.searching;

  User? _user;

  int _notificationCount = 0;

  int get notificationCount {
    return _notificationCount;
  }

  User? get user {
    return _user;
  }

  MoreViewModel(this.count) {
    _notificationCount = count;

    getProfile();
  }

  // MARK: -
  // MARK: - API CALL

  Future getProfile() async {
    loadingStatus = LoadingStatus.searching;

    await UserRepository().getUser(null).then((response) => {
          if (response is User)
            {
              _user = response,
              loadingStatus = LoadingStatus.completed,
            }
          else
            {loadingStatus = LoadingStatus.error},
          notifyListeners()
        });
  }

  // MARK: -
  // MARK: - ACTIONS

  void showProfileScreen(BuildContext context) {
    if (_user != null) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ProfileScreenWidget(
                  isMine: true,
                  user: _user!,
                  onPop: (user) => {_user = user, notifyListeners()})));
    }
  }

  void showNewsScreen(BuildContext context) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const NewsScreenWidget()));
  }

  void showStaffScreen(BuildContext context) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const StaffScreenWidget()));
  }

  void showContactsScreen(BuildContext context) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const ContactsScreenWidget()));
  }

  void showCompaniesScreen(BuildContext context) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const CompaniesScreenWidget()));
  }

  void showProductsScreen(BuildContext context) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const ProductsScreenWidget()));
  }

  void showAnaliticsScreen(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const AnalyticsPageViewScreenBodyWidget()));
  }

  void showDocumentsScreen(BuildContext context) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const DocumentsScreenWidget()));
  }

  void showNotificationsScreen(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => NotificationsScreenWidget(
                onPop: (count) =>
                    {_notificationCount = count, notifyListeners()})));
  }

  Future showLogoutDialog(BuildContext context) async {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text(Titles.logoutAreYouSure,
                  style: TextStyle(
                      color: HexColors.black,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w400)),
              actions: <Widget>[
                TextButton(
                    child: Text(Titles.logout,
                        style: TextStyle(
                            color: HexColors.additionalRed,
                            fontSize: 14.0,
                            fontWeight: FontWeight.w400)),
                    onPressed: () {
                      /// LOGOUT
                      UserParams().clear();
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const AuthorizationScreenWidget()),
                          (route) => false);
                    }),
                TextButton(
                    child: Text(Titles.cancel,
                        style: TextStyle(
                            color: HexColors.black,
                            fontSize: 14.0,
                            fontWeight: FontWeight.w400)),
                    onPressed: () => Navigator.of(context).pop())
              ]);
        });
  }
}
