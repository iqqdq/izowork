import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/loading_status.dart';
import 'package:izowork/components/titles.dart';
import 'package:izowork/models/more_view_model.dart';
import 'package:izowork/views/loading_indicator_widget.dart';
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
    Titles.employees,
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
        body: Stack(children: [
          SizedBox.expand(
              child: ListView.builder(
                  itemCount: _titles.length + 1,
                  itemBuilder: (context, index) {
                    return index == 0
                        ? InkWell(
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            child: Padding(
                                padding: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.height /
                                        (MediaQuery.of(context).padding.top ==
                                                0.0
                                            ? 6.5
                                            : 5.0),
                                    left: 16.0,
                                    bottom: 14.0,
                                    right: 16.0),
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Stack(children: [
                                        SvgPicture.asset('assets/ic_avatar.svg',
                                            width: 80.0,
                                            height: 80.0,
                                            fit: BoxFit.cover,
                                            color: HexColors.primaryMain),
                                        // ClipRRect(
                                        //   borderRadius: BorderRadius.circular(12.0),
                                        //   child:
                                        // CachedNetworkImage(imageUrl: '', width: 80.0, height: 80.0, fit: BoxFit.cover)),
                                      ]),
                                      const SizedBox(height: 14.0),
                                      const TitleWidget(
                                          text: 'almaty_user18@kaspi.kz',
                                          padding: EdgeInsets.zero)
                                    ])),
                            onTap: () =>
                                _moreViewModel.showProfileScreen(context))
                        : MoreListItemWidget(
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
                  })),

          /// INDICATOR
          _moreViewModel.loadingStatus == LoadingStatus.searching
              ? const LoadingIndicatorWidget()
              : Container()
        ]));
  }
}
