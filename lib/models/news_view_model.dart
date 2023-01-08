import 'package:flutter/material.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/loading_status.dart';
import 'package:izowork/screens/news/views/news_filter_sheet/news_filter_widget.dart';
import 'package:izowork/screens/news_comments/news_comments_screen.dart';
import 'package:izowork/screens/news_creation/news_creation_screen.dart';
import 'package:izowork/screens/news_page/news_page_screen.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class NewsViewModel with ChangeNotifier {
  // LoadingStatus loadingStatus = LoadingStatus.searching;
  LoadingStatus loadingStatus = LoadingStatus.empty;

  // MARK: -
  // MARK: - FUNCTIONS

  // MARK: -
  // MARK: - PUSH

  void showContactsFilterSheet(BuildContext context) {
    showCupertinoModalBottomSheet(
        topRadius: const Radius.circular(16.0),
        barrierColor: Colors.black.withOpacity(0.6),
        backgroundColor: HexColors.white,
        context: context,
        builder: (context) => NewsFilterWidget(
            onResponsibleTap: () => {},
            onApplyTap: () => Navigator.pop(context),
            onResetTap: () => {}));
  }

  void showNewsCreationScreen(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const NewsCreationScreenWidget()));
  }

  void showNewsPageScreen(BuildContext context, int index) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => NewsPageScreenWidget(tag: index.toString())));
  }

  void showNewsCommentsScreen(BuildContext context, int index) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                NewsCommentsScreenWidget(tag: index.toString())));
  }
}
