import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:izowork/components/components.dart';
import 'package:izowork/models/models.dart';
import 'package:izowork/notifiers/notifiers.dart';
import 'package:izowork/screens/contact/contact_screen.dart';
import 'package:izowork/screens/contact_create/contact_create_screen.dart';
import 'package:izowork/screens/contacts/contacts_filter_sheet/contacts_filter_page_view_screen.dart';
import 'package:izowork/screens/contacts/views/contact_list_item_widget.dart';
import 'package:izowork/views/views.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

class ContactsScreenBodyWidget extends StatefulWidget {
  final Company? company;
  final Function(Contact)? onPop;

  const ContactsScreenBodyWidget({
    Key? key,
    this.company,
    this.onPop,
  }) : super(key: key);

  @override
  _ContactsScreenBodyState createState() => _ContactsScreenBodyState();
}

class _ContactsScreenBodyState extends State<ContactsScreenBodyWidget> {
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  final ScrollController _scrollController = ScrollController();

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

  @override
  Widget build(BuildContext context) {
    _contactsViewModel = Provider.of<ContactsViewModel>(
      context,
      listen: true,
    );

    return Scaffold(
      backgroundColor: HexColors.white,
      floatingActionButton: FloatingButtonWidget(
          onTap: () => _showContactEditScreen(
                widget.company,
              )),
      appBar: AppBar(
          toolbarHeight: 116.0,
          titleSpacing: 0.0,
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
                        margin: const EdgeInsets.symmetric(horizontal: 16.0),
                        isSearchInput: true,
                        placeholder: '${Titles.search}...',
                        onTap: () => setState,
                        onChange: (text) => {
                              setState(() => _isSearching = true),
                              EasyDebounce.debounce('contact_debouncer',
                                  const Duration(milliseconds: 500), () async {
                                _pagination = Pagination(offset: 0, size: 50);

                                _contactsViewModel
                                    .getContactList(
                                        pagination: _pagination,
                                        search: _textEditingController.text)
                                    .then((value) =>
                                        setState(() => _isSearching = false));
                              })
                            },
                        onClearTap: () => {
                              _contactsViewModel.resetFilter(),
                              _onRefresh(),
                            }),
              )
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
                    bottom: 80.0 + MediaQuery.of(context).padding.bottom,
                  ),
                  itemCount: _contactsViewModel.contacts.length,
                  itemBuilder: (context, index) {
                    var contact = _contactsViewModel.contacts[index];
                    return ContactListItemWidget(
                      key: ValueKey(contact.id),
                      contact: contact,
                      onContactTap: () => widget.onPop == null
                          ? _showContactScreen(contact)
                          : {widget.onPop!(contact), Navigator.pop(context)},
                      onLinkTap: (url) => _contactsViewModel.openUrl(url),
                    );
                  })),
          const SeparatorWidget(),

          /// FILTER BUTTON
          SafeArea(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: FilterButtonWidget(
                isSelected: _contactsViewModel.contactsFilter != null,
                onTap: () => _showContactsFilterSheet(),
              ),
            ),
          ),

          /// EMPTY LIST TEXT
          _contactsViewModel.loadingStatus == LoadingStatus.completed &&
                  _contactsViewModel.contacts.isEmpty &&
                  !_isSearching
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      Titles.noResult,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 16.0,
                        color: HexColors.grey50,
                      ),
                    ),
                  ),
                )
              : Container(),

          /// INDICATOR
          _contactsViewModel.loadingStatus == LoadingStatus.searching
              ? const LoadingIndicatorWidget()
              : Container()
        ]),
      ),
    );
  }

  // MARK: -
  // MARK: - FUNCTIONS

  Future _onRefresh() async {
    _pagination = Pagination(offset: 0, size: 50);
    await _contactsViewModel.getContactList(
      pagination: _pagination,
      search: _textEditingController.text,
    );
  }

  // MARK: -
  // MARK: - PUSH

  void _showContactScreen(Contact contact) => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ContactScreenWidget(
              contact: contact,
              onDelete: (contact) => _contactsViewModel.removeContact(contact)),
        ),
      );

  void _showContactEditScreen(Company? company) => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (newContext) => ContactCreateScreenWidget(
              company: company,
              contact: null,
              onDelete: null,
              onPop: (contact) => {
                    if (company == null)
                      if (contact != null)
                        _contactsViewModel.setContact(contact)
                      else
                        {
                          if (contact != null)
                            if (widget.onPop != null)
                              {
                                widget.onPop!(contact),
                                Future.delayed(
                                    const Duration(seconds: 1),
                                    () => {
                                          if (context.mounted)
                                            Navigator.pop(context),
                                        })
                              }
                        }
                  }),
        ),
      );

  void _showContactsFilterSheet() => showCupertinoModalBottomSheet(
        enableDrag: false,
        topRadius: const Radius.circular(16.0),
        barrierColor: Colors.black.withOpacity(0.6),
        backgroundColor: HexColors.white,
        context: context,
        builder: (sheetContext) => ContactsFilterPageViewScreenWidget(
            contactsFilter: _contactsViewModel.contactsFilter,
            onPop: (contactsFilter) => {
                  contactsFilter == null
                      ? _contactsViewModel.resetFilter()
                      : _contactsViewModel.setFilter(contactsFilter),
                  _onRefresh(),
                }),
      );
}
