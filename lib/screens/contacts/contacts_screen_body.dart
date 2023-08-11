import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:izowork/components/debouncer.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/pagination.dart';
import 'package:izowork/entities/response/contact.dart';
import 'package:izowork/models/contacts_view_model.dart';
import 'package:izowork/screens/contacts/views/contact_list_item_widget.dart';
import 'package:izowork/views/back_button_widget.dart';
import 'package:izowork/views/filter_button_widget.dart';
import 'package:izowork/views/floating_button_widget.dart';
import 'package:izowork/views/input_widget.dart';
import 'package:izowork/components/loading_status.dart';
import 'package:izowork/components/titles.dart';
import 'package:izowork/views/loading_indicator_widget.dart';
import 'package:izowork/views/separator_widget.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:provider/provider.dart';

class ContactsScreenBodyWidget extends StatefulWidget {
  final Function(Contact)? onPop;

  const ContactsScreenBodyWidget({Key? key, this.onPop}) : super(key: key);

  @override
  _ContactsScreenBodyState createState() => _ContactsScreenBodyState();
}

class _ContactsScreenBodyState extends State<ContactsScreenBodyWidget> {
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  final ScrollController _scrollController = ScrollController();
  final Debouncer _debouncer = Debouncer(milliseconds: 500);

  Pagination _pagination = Pagination(offset: 0, size: 50);
  bool _isSearching = false;

  late ContactsViewModel _contactsViewModel;

  @override
  void dispose() {
    _scrollController.dispose();
    _textEditingController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  // MARK: -
  // MARK: - FUNCTIONS

  Future _onRefresh() async {
    _pagination = Pagination(offset: 0, size: 50);
    _contactsViewModel.getContactList(
        pagination: _pagination, search: _textEditingController.text);
  }

  @override
  Widget build(BuildContext context) {
    _contactsViewModel = Provider.of<ContactsViewModel>(context, listen: true);

    return Scaffold(
        backgroundColor: HexColors.white,
        floatingActionButton: FloatingButtonWidget(
            onTap: () => _contactsViewModel.showContactEditScreen(context)),
        appBar: AppBar(
            toolbarHeight: 116.0,
            titleSpacing: 0.0,
            elevation: 0.0,
            systemOverlayStyle: SystemUiOverlayStyle.dark,
            backgroundColor: Colors.transparent,
            automaticallyImplyLeading: false,
            title: Column(children: [
              Stack(children: [
                Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: widget.onPop == null
                        ? BackButtonWidget(onTap: () => Navigator.pop(context))
                        : BackButtonWidget(
                            asset: 'assets/ic_close.svg',
                            onTap: () => Navigator.pop(context),
                          )),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text(Titles.contacts,
                      style: TextStyle(
                          color: HexColors.black,
                          fontSize: 18.0,
                          fontFamily: 'PT Root UI',
                          fontWeight: FontWeight.bold)),
                ])
              ]),
              const SizedBox(height: 16.0),
              Row(children: [
                Expanded(
                    child:

                        /// SEARCH INPUT
                        InputWidget(
                            textEditingController: _textEditingController,
                            focusNode: _focusNode,
                            margin:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            isSearchInput: true,
                            placeholder: '${Titles.search}...',
                            onTap: () => setState,
                            onChange: (text) => {
                                  setState(() => _isSearching = true),
                                  _debouncer.run(() {
                                    _pagination =
                                        Pagination(offset: 0, size: 50);

                                    _contactsViewModel
                                        .getContactList(
                                            pagination: _pagination,
                                            search: _textEditingController.text)
                                        .then((value) => setState(
                                            () => _isSearching = false));
                                  })
                                },
                            onClearTap: () => {
                                  _contactsViewModel.resetFilter(),
                                  _pagination.offset = 0,
                                  _contactsViewModel.getContactList(
                                      pagination: _pagination,
                                      search: _textEditingController.text)
                                }))
              ])
            ])),
        body: SizedBox.expand(
            child: Stack(children: [
          /// CONTACTS LIST VIEW
          LiquidPullToRefresh(
              color: HexColors.primaryMain,
              backgroundColor: HexColors.white,
              springAnimationDurationInMilliseconds: 300,
              onRefresh: _onRefresh,
              child: ListView.builder(
                  controller: _scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.only(
                      left: 16.0,
                      right: 16.0,
                      top: 16.0,
                      bottom: 80.0 + MediaQuery.of(context).padding.bottom),
                  itemCount: _contactsViewModel.contacts.length,
                  itemBuilder: (context, index) {
                    return ContactListItemWidget(
                        contact: _contactsViewModel.contacts[index],
                        onContactTap: () => widget.onPop == null
                            ? _contactsViewModel.showContactScreen(
                                context, index)
                            : {
                                widget
                                    .onPop!(_contactsViewModel.contacts[index]),
                                Navigator.pop(context)
                              },
                        onPhoneTap: () => {},
                        onLinkTap: (url) => _contactsViewModel.openUrl(url));
                  })),
          const SeparatorWidget(),

          /// FILTER BUTTON
          SafeArea(
              child: Align(
                  alignment: Alignment.bottomCenter,
                  child: FilterButtonWidget(
                    onTap: () => _contactsViewModel.showContactsFilterSheet(
                        context,
                        () => {
                              _pagination = Pagination(offset: 0, size: 50),
                              _contactsViewModel.getContactList(
                                  pagination: _pagination,
                                  search: _textEditingController.text)
                            }),
                    // onClearTap: () => {}
                  ))),

          /// EMPTY LIST TEXT
          _contactsViewModel.loadingStatus == LoadingStatus.completed &&
                  _contactsViewModel.contacts.isEmpty &&
                  !_isSearching
              ? Center(
                  child: Padding(
                      padding: const EdgeInsets.only(
                          left: 20.0, right: 20.0, bottom: 100.0),
                      child: Text(Titles.noResult,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 16.0,
                              color: HexColors.grey50))))
              : Container(),

          /// INDICATOR
          _contactsViewModel.loadingStatus == LoadingStatus.searching
              ? const Padding(
                  padding: EdgeInsets.only(bottom: 90.0),
                  child: LoadingIndicatorWidget())
              : Container()
        ])));
  }
}
