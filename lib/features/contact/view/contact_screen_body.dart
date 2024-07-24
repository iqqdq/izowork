import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:izowork/features/contact/view_model/contact_view_model.dart';
import 'package:provider/provider.dart';

import 'package:izowork/components/components.dart';
import 'package:izowork/models/models.dart';

import 'package:izowork/api/api.dart';
import 'package:izowork/features/contact_create/view/contact_create_screen.dart';
import 'package:izowork/views/views.dart';

class ContactScreenBodyWidget extends StatefulWidget {
  final Function(Contact) onDelete;

  const ContactScreenBodyWidget({
    Key? key,
    required this.onDelete,
  }) : super(key: key);

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

    String? _url = _contactViewModel.contact?.avatar ??
        _contactViewModel.selectedContact.avatar;

    return Scaffold(
      backgroundColor: HexColors.white,
      appBar: AppBar(
          titleSpacing: 0.0,
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
                AvatarWidget(
                  url: contactAvatarUrl,
                  endpoint: _url,
                  size: 80.0,
                ),
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
                      fontFamily: 'PT Root UI',
                    )),
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
                              fontFamily: 'PT Root UI',
                            ))),
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
                      fontFamily: 'PT Root UI',
                    )),
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
                      fontFamily: 'PT Root UI',
                    )),
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
                            final social =
                                _contactViewModel.contact?.social[index];

                            return social == null
                                ? Container()
                                : Padding(
                                    key: ValueKey(social),
                                    padding: const EdgeInsets.only(bottom: 4.0),
                                    child: InkWell(
                                      highlightColor: Colors.transparent,
                                      splashColor: Colors.transparent,
                                      onTap: () =>
                                          _contactViewModel.openUrl(social),
                                      child: Text(
                                        social,
                                        style: TextStyle(
                                          color: HexColors.primaryDark,
                                          fontSize: 14.0,
                                          fontFamily: 'PT Root UI',
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
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
              onTap: () => _showContactEditScreen(),
            ),
          ),
        ),
        const SeparatorWidget(),

        /// INDICATOR
        _contactViewModel.loadingStatus == LoadingStatus.searching
            ? const LoadingIndicatorWidget()
            : Container()
      ]),
    );
  }

  // MARK: -
  // MARK: - PUSH

  void _showContactEditScreen() => Navigator.push(
        context,
        MaterialPageRoute(
            builder: (sheetContext) => ContactCreateScreenWidget(
                  company: _contactViewModel.selectedContact.company,
                  contact: _contactViewModel.selectedContact,
                  onPop: (contact) => _contactViewModel.setContact(contact),
                  onDelete: (contact) => widget.onDelete(contact),
                )),
      );
}
