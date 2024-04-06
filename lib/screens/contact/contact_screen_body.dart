import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/loading_status.dart';
import 'package:izowork/components/titles.dart';
import 'package:izowork/models/contact_view_model.dart';
import 'package:izowork/services/urls.dart';
import 'package:izowork/views/back_button_widget.dart';
import 'package:izowork/views/button_widget.dart';
import 'package:izowork/views/loading_indicator_widget.dart';
import 'package:izowork/views/separator_widget.dart';
import 'package:izowork/views/status_widget.dart';
import 'package:izowork/views/title_widget.dart';
import 'package:provider/provider.dart';

class ContactScreenBodyWidget extends StatefulWidget {
  const ContactScreenBodyWidget({Key? key}) : super(key: key);

  @override
  _ContactScreenBodyState createState() => _ContactScreenBodyState();
}

class _ContactScreenBodyState extends State<ContactScreenBodyWidget> {
  late ContactViewModel _contactViewModel;

  @override
  Widget build(BuildContext context) {
    _contactViewModel = Provider.of<ContactViewModel>(
      context,
      listen: true,
    );

    String? _url = _contactViewModel.contact == null
        ? null
        : _contactViewModel.contact!.avatar == null
            ? null
            : _contactViewModel.contact!.avatar!;

    return Scaffold(
        backgroundColor: HexColors.white,
        appBar: AppBar(
            titleSpacing: 0.0,
            elevation: 0.0,
            systemOverlayStyle: SystemUiOverlayStyle.dark,
            backgroundColor: Colors.transparent,
            automaticallyImplyLeading: false,
            title: Column(children: [
              Stack(children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: BackButtonWidget(onTap: () => Navigator.pop(context)),
                ),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text(Titles.contact,
                      style: TextStyle(
                          color: HexColors.black,
                          fontSize: 18.0,
                          fontFamily: 'PT Root UI',
                          fontWeight: FontWeight.bold)),
                ])
              ])
            ])),
        body: Stack(children: [
          ListView(
              padding: EdgeInsets.only(
                  left: 16.0,
                  right: 16.0,
                  top: 20.0,
                  bottom: MediaQuery.of(context).padding.bottom + 60.0),
              children: [
                /// AVATAR
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Stack(children: [
                    SvgPicture.asset('assets/ic_avatar.svg',
                        color: HexColors.grey40,
                        width: 80.0,
                        height: 80.0,
                        fit: BoxFit.cover),
                    _url == null
                        ? Container()
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(40.0),
                            child: CachedNetworkImage(
                                cacheKey: _url,
                                imageUrl: contactAvatarUrl + _url,
                                width: 80.0,
                                height: 80.0,
                                memCacheWidth: 80 *
                                    MediaQuery.of(context)
                                        .devicePixelRatio
                                        .round(),
                                fit: BoxFit.cover)),
                  ])
                ]),
                const SizedBox(height: 14.0),

                /// NAME
                SelectionArea(
                  child: Text(
                    _contactViewModel.contact?.name ?? '-',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: HexColors.black,
                        fontSize: 18.0,
                        fontFamily: 'PT Root UI',
                        fontWeight: FontWeight.bold),
                  ),
                ),

                /// POST
                const TitleWidget(
                    text: Titles.speciality,
                    padding: EdgeInsets.only(top: 16.0, bottom: 4.0),
                    isSmall: true),
                SelectionArea(
                  child: Text(_contactViewModel.contact?.post ?? '-',
                      style: TextStyle(
                          color: HexColors.black,
                          fontSize: 14.0,
                          fontFamily: 'PT Root UI')),
                ),
                const SizedBox(height: 16.0),
                const SeparatorWidget(),
                const SizedBox(height: 16.0),

                /// COMPANY
                const TitleWidget(
                    text: Titles.companyName,
                    padding: EdgeInsets.only(bottom: 4.0),
                    isSmall: true),
                Row(
                  children: [
                    Expanded(
                      child: SelectionArea(
                          child: Text(
                              _contactViewModel.contact?.company?.name ?? '-',
                              style: TextStyle(
                                  color: HexColors.black,
                                  fontSize: 14.0,
                                  fontFamily: 'PT Root UI'))),
                    ),
                    const SizedBox(width: 10.0),

                    /// TAG
                    _contactViewModel.contact?.company == null
                        ? Container()
                        : StatusWidget(
                            title:
                                _contactViewModel.contact?.company?.type ?? '-',
                            status: _contactViewModel.contact?.company?.type ==
                                    'Поставщик'
                                ? 0
                                : _contactViewModel.contact?.company?.type ==
                                        'Проектировщик'
                                    ? 1
                                    : 2)
                  ],
                ),
                const SizedBox(height: 16.0),
                const SeparatorWidget(),
                const SizedBox(height: 16.0),

                /// EMAIL
                const TitleWidget(
                    text: Titles.email,
                    padding: EdgeInsets.only(bottom: 4.0),
                    isSmall: true),
                SelectionArea(
                  child: Text(_contactViewModel.contact?.email ?? '-',
                      style: TextStyle(
                          color: HexColors.black,
                          fontSize: 14.0,
                          fontFamily: 'PT Root UI')),
                ),
                const SizedBox(height: 16.0),
                const SeparatorWidget(),
                const SizedBox(height: 16.0),

                /// PHONE
                const TitleWidget(
                    text: Titles.phone,
                    padding: EdgeInsets.only(bottom: 4.0),
                    isSmall: true),
                SelectionArea(
                  child: Text(_contactViewModel.contact?.phone ?? '-',
                      style: TextStyle(
                          color: HexColors.black,
                          fontSize: 14.0,
                          fontFamily: 'PT Root UI')),
                ),
                const SizedBox(height: 16.0),
                _contactViewModel.contact == null
                    ? Container()
                    : _contactViewModel.contact!.social.isEmpty
                        ? Container()
                        : const SeparatorWidget(),
                const SizedBox(height: 16.0),

                /// SOCIAL
                _contactViewModel.contact == null
                    ? Container()
                    : _contactViewModel.contact!.social.isEmpty
                        ? Container()
                        : const TitleWidget(
                            text: Titles.socialLinks,
                            padding: EdgeInsets.only(bottom: 4.0),
                            isSmall: true),
                _contactViewModel.contact == null
                    ? Container()
                    : _contactViewModel.contact!.social.isEmpty
                        ? Container()
                        : ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            itemCount: _contactViewModel.contact?.social.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                  key: ValueKey(
                                      _contactViewModel.contact?.social[index]),
                                  padding: const EdgeInsets.only(bottom: 4.0),
                                  child: InkWell(
                                    highlightColor: Colors.transparent,
                                    splashColor: Colors.transparent,
                                    onTap: () => _contactViewModel.openUrl(
                                        _contactViewModel
                                            .contact!.social[index]),
                                    child: Text(
                                        _contactViewModel
                                            .contact!.social[index],
                                        style: TextStyle(
                                            color: HexColors.primaryDark,
                                            fontSize: 14.0,
                                            fontFamily: 'PT Root UI',
                                            decoration:
                                                TextDecoration.underline)),
                                  ));
                            })
              ]),

          Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).padding.bottom == 0.0
                          ? 12.0
                          : MediaQuery.of(context).padding.bottom),
                  child: ButtonWidget(
                      title: Titles.edit,
                      onTap: () =>
                          _contactViewModel.showContactEditScreen(context)))),
          const SeparatorWidget(),

          /// INDICATOR
          _contactViewModel.loadingStatus == LoadingStatus.searching
              ? const LoadingIndicatorWidget()
              : Container()
        ]));
  }
}
