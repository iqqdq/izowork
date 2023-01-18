import 'package:flutter/material.dart';
import 'package:izowork/components/loading_status.dart';
import 'package:izowork/screens/analytics/analytics_page_view_screen.dart';
import 'package:izowork/screens/companies/companies_screen.dart';
import 'package:izowork/screens/contacts/contacts_screen.dart';
import 'package:izowork/screens/documents/documents_screen.dart';
import 'package:izowork/screens/news/news_screen.dart';
import 'package:izowork/screens/notifications/notifications_screen.dart';
import 'package:izowork/screens/products/products_screen.dart';
import 'package:izowork/screens/profile/profile_screen.dart';
import 'package:izowork/screens/staff/staff_screen.dart';

class MoreViewModel with ChangeNotifier {
  // LoadingStatus loadingStatus = LoadingStatus.searching;
  LoadingStatus loadingStatus = LoadingStatus.empty;

  // MARK: -
  // MARK: - ACTIONS

  void showProfileScreen(BuildContext context) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const ProfileScreenWidget()));
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
            builder: (context) => const NotificationsScreenWidget()));
  }
}
