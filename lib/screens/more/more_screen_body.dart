import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/titles.dart';
import 'package:izowork/models/more_view_model.dart';
import 'package:izowork/services/urls.dart';
import 'package:izowork/screens/more/views/more_list_item_widget.dart';
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
    Titles.notifications
  ];
  late MoreViewModel _moreViewModel;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    _moreViewModel = Provider.of<MoreViewModel>(context, listen: true);

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
                                            : _moreViewModel
                                                    .user!.avatar!.isEmpty
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
                                                            MediaQuery.of(
                                                                    context)
                                                                .devicePixelRatio
                                                                .round(),
                                                        fit: BoxFit.cover)),
                                      ]),
                                      TitleWidget(
                                          text:
                                              _moreViewModel.user?.email ?? '',
                                          padding: const EdgeInsets.only(
                                              top: 14.0, bottom: 16.0)),
                                    ])
                              ]),
                          onTap: () =>
                              _moreViewModel.showProfileScreen(context))
                      : MoreListItemWidget(
                          showSeparator: index > 1,
                          title: _titles[index - 1],
                          onTap: () => {
                                index == 1
                                    ? _moreViewModel.showNewsScreen(context)
                                    : index == 2
                                        ? _moreViewModel
                                            .showStaffScreen(context)
                                        : index == 3
                                            ? _moreViewModel
                                                .showContactsScreen(context)
                                            : index == 4
                                                ? _moreViewModel
                                                    .showCompaniesScreen(
                                                        context)
                                                : index == 5
                                                    ? _moreViewModel
                                                        .showProductsScreen(
                                                            context)
                                                    : index == 6
                                                        ? _moreViewModel
                                                            .showAnaliticsScreen(
                                                                context)
                                                        : index == 7
                                                            ? _moreViewModel
                                                                .showDocumentsScreen(
                                                                    context)
                                                            : index == 8
                                                                ? _moreViewModel
                                                                    .showNotificationsScreen(
                                                                        context)
                                                                : debugPrint(index
                                                                    .toString())
                              });
                })));
  }
}
