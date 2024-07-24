import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:izowork/components/components.dart';
import 'package:izowork/features/staff/view_model/staff_view_model.dart';
import 'package:izowork/models/models.dart';

import 'package:izowork/features/dialog/view/dialog_screen.dart';
import 'package:izowork/features/profile/view/profile_screen.dart';
import 'package:izowork/features/staff/view/views/staff_list_item_widget.dart';
import 'package:izowork/views/views.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:provider/provider.dart';

class StaffScreenBodyWidget extends StatefulWidget {
  const StaffScreenBodyWidget({Key? key}) : super(key: key);

  @override
  _StaffScreenBodyState createState() => _StaffScreenBodyState();
}

class _StaffScreenBodyState extends State<StaffScreenBodyWidget> {
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  late StaffViewModel _staffViewModel;
  Pagination _pagination = Pagination();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _pagination.increase();
        _staffViewModel.getUserList(
            pagination: _pagination, search: _textEditingController.text);
      }
    });
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _focusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // MARK: -
  // MARK: - FUNCTIONS

  Future _onRefresh() async {
    _pagination = Pagination();
    await _staffViewModel.getUserList(
      pagination: _pagination,
      search: _textEditingController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    _staffViewModel = Provider.of<StaffViewModel>(
      context,
      listen: true,
    );

    return Scaffold(
      backgroundColor: HexColors.white,
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
                  child: BackButtonWidget(onTap: () => Navigator.pop(context))),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(Titles.staff,
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
                                EasyDebounce.debounce('staff_debouncer',
                                    const Duration(milliseconds: 500),
                                    () async {
                                  _pagination = Pagination();

                                  _staffViewModel
                                      .getUserList(
                                        pagination: _pagination,
                                        search: _textEditingController.text,
                                      )
                                      .then(
                                        (value) => setState(
                                            () => _isSearching = false),
                                      );
                                })
                              },
                          onClearTap: () => {
                                _pagination.offset = 0,
                                _staffViewModel.getUserList(
                                    pagination: _pagination)
                              }))
            ])
          ])),
      body: SizedBox.expand(
        child: Stack(children: [
          /// STAFF LIST VIEW
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
                  bottom: MediaQuery.of(context).padding.bottom == 0.0
                      ? 12.0
                      : MediaQuery.of(context).padding.bottom,
                ),
                shrinkWrap: true,
                itemCount: _staffViewModel.users.length,
                itemBuilder: (context, index) {
                  final user = _staffViewModel.users[index];

                  return StaffListItemWidget(
                    key: ValueKey(user.id),
                    user: user,
                    onUserTap: () => _showProfileScreen(
                      context,
                      user,
                    ),
                    onLinkTap: user.social.isEmpty
                        ? null
                        : (url) => _staffViewModel.openUrl(url),
                    onChatTap: user.id == _staffViewModel.userId
                        ? null
                        : () => _createChat(index),
                  );
                }),
          ),
          const SeparatorWidget(),

          /// EMPTY LIST TEXT
          _staffViewModel.loadingStatus == LoadingStatus.completed &&
                  _staffViewModel.users.isEmpty &&
                  !_isSearching
              ? const NoResultTitle()
              : Container(),

          /// INDICATOR
          _staffViewModel.loadingStatus == LoadingStatus.searching ||
                  _isSearching
              ? const LoadingIndicatorWidget()
              : Container()
        ]),
      ),
    );
  }

  // MARK: -
  // MARK: - FUNCTIONS

  void _showProfileScreen(
    BuildContext context,
    User user,
  ) =>
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ProfileScreenWidget(
                    isMine: false,
                    user: user,
                    onPop: (user) => null,
                  )));

  void _createChat(int index) {
    _staffViewModel.createUserChat(index).whenComplete(() {
      if (_staffViewModel.chat != null) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    DialogScreenWidget(id: _staffViewModel.chat!.id)));
      }
    });
  }
}
