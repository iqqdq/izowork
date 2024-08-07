import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:izowork/components/components.dart';
import 'package:izowork/features/participants/view_model/participants_view_model.dart';
import 'package:izowork/models/models.dart';

import 'package:izowork/features/dialog/view/dialog_screen.dart';
import 'package:izowork/features/profile/view/profile_screen.dart';
import 'package:izowork/features/staff/view/views/staff_list_item_widget.dart';
import 'package:izowork/views/views.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:provider/provider.dart';

class ParticipantsScreenBodyWidget extends StatefulWidget {
  const ParticipantsScreenBodyWidget({Key? key}) : super(key: key);

  @override
  _ParticipantsScreenBodyState createState() => _ParticipantsScreenBodyState();
}

class _ParticipantsScreenBodyState extends State<ParticipantsScreenBodyWidget> {
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  final ScrollController _scrollController = ScrollController();

  late ParticipantsViewModel _participantsViewModel;

  Pagination _pagination = Pagination();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _pagination.increase();
        _participantsViewModel.getParticipantList(
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
    await _participantsViewModel.getParticipantList(
      pagination: _pagination,
      search: _textEditingController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    _participantsViewModel = Provider.of<ParticipantsViewModel>(
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
                Text(Titles.participants,
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
                                EasyDebounce.debounce('participant_debouncer',
                                    const Duration(milliseconds: 500),
                                    () async {
                                  _pagination = Pagination();

                                  _participantsViewModel
                                      .getParticipantList(
                                          pagination: _pagination,
                                          search: _textEditingController.text)
                                      .then((value) =>
                                          setState(() => _isSearching = false));
                                })
                              },
                          onClearTap: () => {
                                _pagination.offset = 0,
                                _participantsViewModel.getParticipantList(
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
                itemCount: _participantsViewModel.users.length,
                itemBuilder: (context, index) {
                  final user = _participantsViewModel.users[index];

                  return StaffListItemWidget(
                    key: ValueKey(user.id),
                    user: user,
                    onUserTap: () => _showProfileScreen(user),
                    onLinkTap: user.social.isEmpty
                        ? null
                        : (url) => _participantsViewModel.openUrl(url),
                    onChatTap: () => _showDialogScreen(user.id),
                  );
                }),
          ),
          const SeparatorWidget(),

          /// EMPTY LIST TEXT
          _participantsViewModel.loadingStatus == LoadingStatus.completed &&
                  _participantsViewModel.users.isEmpty &&
                  !_isSearching
              ? const NoResultTitle()
              : Container(),

          /// INDICATOR
          _participantsViewModel.loadingStatus == LoadingStatus.searching ||
                  _isSearching
              ? const LoadingIndicatorWidget()
              : Container()
        ]),
      ),
    );
  }

  // MARK: -
  // MARK: - PUSH

  void _showProfileScreen(User user) => Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ProfileScreenWidget(
                isMine: false,
                user: user,
                onPop: (user) => null,
              )));

  void _showDialogScreen(String id) async {
    await _participantsViewModel.createUserChat(id);

    if (_participantsViewModel.newChat == null) return;

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                DialogScreenWidget(id: _participantsViewModel.newChat!.id)));
  }
}
