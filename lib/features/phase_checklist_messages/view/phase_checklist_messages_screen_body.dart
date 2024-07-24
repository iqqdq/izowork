import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:izowork/components/components.dart';
import 'package:izowork/features/phase_checklist_messages/view_model/phase_checklist_messages_view_model.dart';

import 'package:izowork/features/phase_checklist_messages/view/views/phase_checklist_comment_item_widget.dart';
import 'package:izowork/features/profile/view/profile_screen.dart';
import 'package:izowork/views/views.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:provider/provider.dart';

class PhaseChecklistMessagesBodyWidget extends StatefulWidget {
  const PhaseChecklistMessagesBodyWidget({
    Key? key,
  }) : super(key: key);

  @override
  _PhaseChecklistCommentsBodyState createState() =>
      _PhaseChecklistCommentsBodyState();
}

class _PhaseChecklistCommentsBodyState
    extends State<PhaseChecklistMessagesBodyWidget> {
  final ScrollController _scrollController = ScrollController();

  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  Pagination _pagination = Pagination();

  late PhaseChecklistMessagesViewModel _phaseChecklistMessagesViewModel;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (_phaseChecklistMessagesViewModel
                .phaseChecklistMessagesResponse.messages.length <
            _phaseChecklistMessagesViewModel
                .phaseChecklistMessagesResponse.count) {
          _pagination.increase();
          _phaseChecklistMessagesViewModel.getPhaseChecklistMessagesList(
              pagination: _pagination);
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _textEditingController.dispose();
    _focusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _phaseChecklistMessagesViewModel =
        Provider.of<PhaseChecklistMessagesViewModel>(
      context,
      listen: true,
    );

    return Scaffold(
      backgroundColor: HexColors.white,
      appBar: AppBar(
        titleSpacing: 0.0,
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        backgroundColor: HexColors.white,
        automaticallyImplyLeading: false,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: BackButtonWidget(
            asset: 'assets/ic_close.svg',
            onTap: () => Navigator.pop(context),
          ),
        ),
        title: Padding(
          padding: const EdgeInsets.only(right: 16.0 + 24.0),
          child: Row(children: [
            /// PHASE CHECKLIST TITLE
            Expanded(
              child: Text(
                _phaseChecklistMessagesViewModel.phaseChecklist.name,
                textAlign: TextAlign.center,
                style: TextStyle(
                  overflow: TextOverflow.ellipsis,
                  color: HexColors.black,
                  fontSize: 18.0,
                  fontFamily: 'PT Root UI',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ]),
        ),
      ),
      body: SizedBox.expand(
        child: Stack(children: [
          Column(children: [
            const SeparatorWidget(),

            /// COMMENTS LIST VIEW
            Expanded(
              child: LiquidPullToRefresh(
                color: HexColors.primaryMain,
                backgroundColor: HexColors.white,
                springAnimationDurationInMilliseconds: 300,
                onRefresh: _onRefresh,
                child: Container(
                  color: HexColors.grey,
                  child: RawScrollbar(
                    controller: _scrollController,
                    thumbColor: HexColors.grey50,
                    thickness: 3,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      controller: _scrollController,
                      reverse: false,
                      child: GestureDetector(
                        onTap: () => FocusScope.of(context).unfocus(),
                        child: ListView.builder(
                            padding: EdgeInsets.zero,
                            cacheExtent: 0.0,
                            reverse: false,
                            primary: false,
                            shrinkWrap: true,
                            itemCount: _phaseChecklistMessagesViewModel
                                .phaseChecklistMessagesResponse.messages.length,
                            itemBuilder: (context, index) {
                              return Column(children: [
                                PhaseChecklistMessageItemWidget(
                                  phaseChecklistMessage:
                                      _phaseChecklistMessagesViewModel
                                          .phaseChecklistMessagesResponse
                                          .messages[index],
                                  onUserTap: () => showProfileScreen(index),
                                ),
                                const SeparatorWidget(),
                              ]);
                            }),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            /// MESSAGE BAR
            Column(children: [
              const SeparatorWidget(),
              ChatMessageBarWidget(
                isSending: _phaseChecklistMessagesViewModel.isSending,
                isAudio: false,
                textEditingController: _textEditingController,
                focusNode: _focusNode,
                hintText: Titles.typeComment,
                onSendTap: () => {
                  FocusScope.of(context).unfocus(),

                  /// SEND COMMENT
                  _phaseChecklistMessagesViewModel
                      .sendMessage(message: _textEditingController.text)
                      .whenComplete(() =>

                          /// CLEAR INPUT
                          _textEditingController.clear())
                },
              ),
            ]),
            Container(
                color: HexColors.white,
                height: MediaQuery.of(context).padding.bottom == 0.0
                    ? 0.0
                    : MediaQuery.of(context).padding.bottom / 2.0)
          ]),

          /// EMPTY LIST TEXT
          _phaseChecklistMessagesViewModel.loadingStatus ==
                      LoadingStatus.completed &&
                  _phaseChecklistMessagesViewModel
                      .phaseChecklistMessagesResponse.messages.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      Titles.noComments,
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
          _phaseChecklistMessagesViewModel.loadingStatus ==
                  LoadingStatus.searching
              ? const LoadingIndicatorWidget()
              : Container()
        ]),
      ),
    );
  }

  Future _onRefresh() async {
    _pagination = Pagination();
    await _phaseChecklistMessagesViewModel.getPhaseChecklistMessagesList(
        pagination: _pagination);
  }

  void showProfileScreen(int index) => Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfileScreenWidget(
          isMine: false,
          user: _phaseChecklistMessagesViewModel
              .phaseChecklistMessagesResponse.messages[index].user,
          onPop: (user) => {},
        ),
      ));
}
