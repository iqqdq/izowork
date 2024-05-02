import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/titles.dart';
import 'package:izowork/models/more_view_model.dart';
import 'package:izowork/api/urls.dart';
import 'package:izowork/screens/analytics/analytics_page_view_screen.dart';
import 'package:izowork/screens/authorization/authorization_screen.dart';
import 'package:izowork/screens/companies/companies_screen.dart';
import 'package:izowork/screens/contacts/contacts_screen.dart';
import 'package:izowork/screens/documents/documents_screen.dart';
import 'package:izowork/screens/more/views/more_list_item_widget.dart';
import 'package:izowork/screens/news/news_screen.dart';
import 'package:izowork/screens/notifications/notifications_screen.dart';
import 'package:izowork/screens/products/products_screen.dart';
import 'package:izowork/screens/profile/profile_screen.dart';
import 'package:izowork/screens/staff/staff_screen.dart';
import 'package:izowork/views/border_button_widget.dart';
import 'package:izowork/views/title_widget.dart';
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
    late Widget screen;

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

    Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
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
                          title: Titles.logout,
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
                      onTap: () => Navigator.of(context).pop(),
                    ),
                  ),
                ],
              ),
            ]);
      });

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
          elevation: 0.0,
          automaticallyImplyLeading: false,
        ),
        body: SizedBox.expand(
          child: ListView.builder(
              itemCount: _titles.length + 1,
              itemBuilder: (context, index) {
                return index == 0
                    ? GestureDetector(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    /// AVATAR

                                    Stack(children: [
                                      SvgPicture.asset('assets/ic_avatar.svg',
                                          color: HexColors.grey40,
                                          width: 80.0,
                                          height: 80.0,
                                          fit: BoxFit.cover),
                                      _moreViewModel.user?.avatar == null
                                          ? Container()
                                          : _moreViewModel.user!.avatar!.isEmpty
                                              ? Container()
                                              : ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          40.0),
                                                  child: CachedNetworkImage(
                                                    cacheKey: _moreViewModel
                                                        .user!.avatar,
                                                    imageUrl: avatarUrl +
                                                        _moreViewModel
                                                            .user!.avatar!,
                                                    width: 80.0,
                                                    height: 80.0,
                                                    memCacheWidth: 80 *
                                                        MediaQuery.of(context)
                                                            .devicePixelRatio
                                                            .round(),
                                                    fit: BoxFit.cover,
                                                  )),
                                    ]),
                                    TitleWidget(
                                        text: _moreViewModel.user?.email ?? '',
                                        padding: const EdgeInsets.only(
                                          top: 14.0,
                                          bottom: 16.0,
                                        )),
                                  ])
                            ]),
                        onTap: () => _showProfileScreen(context))
                    : MoreListItemWidget(
                        showSeparator: index > 1,
                        title: _titles[index - 1],
                        count: index == _titles.length - 1
                            ? _moreViewModel.notificationCount
                            : null,
                        onTap: () => index == 9
                            ? _showLogoutDialog(context)
                            : _showScreen(index));
              }),
        ));
  }
}
