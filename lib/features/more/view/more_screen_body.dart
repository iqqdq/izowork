import 'package:flutter/material.dart';
import 'package:izowork/components/components.dart';

import 'package:izowork/api/api.dart';
import 'package:izowork/features/analytics/view/analytics_page_view_screen.dart';
import 'package:izowork/features/authorization/view/authorization_screen.dart';
import 'package:izowork/features/companies/view/companies_screen.dart';
import 'package:izowork/features/contacts/view/contacts_screen.dart';
import 'package:izowork/features/documents/view/documents_screen.dart';
import 'package:izowork/features/more/view_model/more_view_model.dart';
import 'package:izowork/features/more/view/views/more_list_item_widget.dart';
import 'package:izowork/features/news/view/news_screen.dart';
import 'package:izowork/features/notifications/view/notifications_screen.dart';
import 'package:izowork/features/products/view/products_screen.dart';
import 'package:izowork/features/profile/view/profile_screen.dart';
import 'package:izowork/features/staff/view/staff_screen.dart';
import 'package:izowork/views/views.dart';
import 'package:provider/provider.dart';

class MoreScreenBodyWidget extends StatefulWidget {
  const MoreScreenBodyWidget({Key? key}) : super(key: key);

  @override
  _MoreScreenBodyState createState() => _MoreScreenBodyState();
}

class _MoreScreenBodyState extends State<MoreScreenBodyWidget>
    with AutomaticKeepAliveClientMixin {
  final _titles = [
    Titles.news,
    Titles.staff,
    Titles.contacts,
    Titles.companies,
    Titles.products,
    Titles.analytics,
    Titles.documents,
    Titles.notifications,
    Titles.logout
  ];

  late MoreViewModel _moreViewModel;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    _moreViewModel = Provider.of<MoreViewModel>(
      context,
      listen: true,
    );

    return Scaffold(
        backgroundColor: HexColors.white,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
        ),
        body: SizedBox.expand(
          child: ListView.builder(
              itemCount: _titles.length + 1,
              itemBuilder: (context, index) {
                final user = _moreViewModel.user;

                return index == 0
                    ? GestureDetector(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    /// AVATAR
                                    AvatarWidget(
                                      url: avatarUrl,
                                      endpoint: user?.avatar,
                                      size: 80.0,
                                    ),

                                    /// EMAIL
                                    TitleWidget(
                                        text: user?.email ?? '',
                                        padding: const EdgeInsets.only(
                                          top: 14.0,
                                          bottom: 16.0,
                                        )),
                                  ])
                            ]),
                        onTap: () => _showProfileScreen(context),
                      )
                    : MoreListItemWidget(
                        showSeparator: index > 1,
                        title: _titles[index - 1],
                        count: index == _titles.length - 1
                            ? _moreViewModel.notificationCount
                            : null,
                        onTap: () => index == 9
                            ? _showLogoutDialog(context)
                            : _showScreen(index),
                      );
              }),
        ));
  }

  // MARK: -
  // MARK: - PUSH

  void _showProfileScreen(BuildContext context) {
    if (_moreViewModel.user == null) return;

    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProfileScreenWidget(
              isMine: true,
              user: _moreViewModel.user!,
              onPop: (user) => _moreViewModel.updateUser(user)),
        ));
  }

  void _showScreen(int index) {
    Widget? screen;

    switch (index) {
      case 1:
        screen = const NewsScreenWidget();
        break;
      case 2:
        screen = const StaffScreenWidget();
        break;
      case 3:
        screen = const ContactsScreenWidget();
        break;
      case 4:
        screen = const CompaniesScreenWidget();
        break;
      case 5:
        screen = const ProductsScreenWidget();
        break;
      case 6:
        screen = const AnalyticsPageViewScreenBodyWidget();
        break;
      case 7:
        screen = const DocumentsScreenWidget();
        break;
      case 8:
        screen = NotificationsScreenWidget(
            onPop: () => _moreViewModel.getUnreadNotificationCount());
        break;
      default:
        break;
    }

    if (screen == null) return;
    Navigator.push(context, MaterialPageRoute(builder: (context) => screen!));
  }

  Future _showLogoutDialog(BuildContext context) async => showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
            title: Text(
              Titles.logoutAreYouSure,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: HexColors.black,
                fontSize: 16.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            actions: <Widget>[
              Row(
                children: [
                  Expanded(
                      child: BorderButtonWidget(
                          margin: EdgeInsets.zero,
                          title: Titles.exit,
                          isDestructive: true,
                          onTap: () async {
                            await _moreViewModel.logout().then(
                                  (value) => Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const AuthorizationScreenWidget()),
                                    (route) => false,
                                  ),
                                );
                          })),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: BorderButtonWidget(
                      margin: EdgeInsets.zero,
                      title: Titles.cancel,
                      onTap: () => Navigator.pop(context),
                    ),
                  ),
                ],
              ),
            ]);
      });
}
