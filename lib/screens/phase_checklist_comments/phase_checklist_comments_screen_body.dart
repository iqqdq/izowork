import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/pagination.dart';
import 'package:izowork/models/phase_checklist_comments_view_model.dart';
import 'package:izowork/screens/phase_checklist_comments/views/phase_checklist_comment_item_widget.dart';
import 'package:izowork/views/back_button_widget.dart';
import 'package:izowork/components/loading_status.dart';
import 'package:izowork/components/titles.dart';
import 'package:izowork/views/chat_message_bar_widget.dart';
import 'package:izowork/views/loading_indicator_widget.dart';
import 'package:izowork/views/separator_widget.dart';
import 'package:provider/provider.dart';

class PhaseChecklistCommentsBodyWidget extends StatefulWidget {
  const PhaseChecklistCommentsBodyWidget({
    Key? key,
  }) : super(key: key);

  @override
  _PhaseChecklistCommentsBodyState createState() =>
      _PhaseChecklistCommentsBodyState();
}

class _PhaseChecklistCommentsBodyState
    extends State<PhaseChecklistCommentsBodyWidget> {
  final ScrollController _scrollController = ScrollController();

  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  final Pagination _pagination = Pagination(
    offset: 0,
    size: 50,
  );

  late PhaseChecklistCommentsViewModel _phaseChecklistCommentsViewModel;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _pagination.offset += 1;
        _phaseChecklistCommentsViewModel.getPhaseChecklistCommentsList(
            pagination: _pagination);
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
    _phaseChecklistCommentsViewModel =
        Provider.of<PhaseChecklistCommentsViewModel>(
      context,
      listen: true,
    );

    return Scaffold(
        backgroundColor: HexColors.white,
        appBar: AppBar(
          titleSpacing: 0.0,
          elevation: 0.0,
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
                child:
                    Text(_phaseChecklistCommentsViewModel.phaseChecklist.name,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          overflow: TextOverflow.ellipsis,
                          color: HexColors.black,
                          fontSize: 18.0,
                          fontFamily: 'PT Root UI',
                          fontWeight: FontWeight.bold,
                        )),
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
                          cacheExtent: 0.0,
                          reverse: false,
                          primary: false,
                          shrinkWrap: true,
                          itemCount:
                              2, // TODO: - _phaseChecklistCommentsViewModel.comments.lenght
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                PhaseChecklistCommentItemWidget(
                                  onUserTap: () => {}, // TODO: - SHOW USER
                                ),
                                // _phaseChecklistCommentsViewModel.comments.isEmpty ? Container() :
                                const SeparatorWidget(),
                              ],
                            );
                          }),
                    ),
                  ),
                ),
              ),
            ),

            /// MESSAGE BAR
            ChatMessageBarWidget(
              isSending: _phaseChecklistCommentsViewModel.isSending,
              isAudio: false,
              textEditingController: _textEditingController,
              focusNode: _focusNode,
              hintText: Titles.typeComment,
              onSendTap: () => {
                FocusScope.of(context).unfocus(),

                // TODO: - SEND PHASE CHECKLIST COMMENT

                /// CLEAR INPUT
                _textEditingController.clear(),
              },
              // onClipTap: () => _dialogViewModel.addFile(context),
            ),
            Container(
                color: HexColors.white,
                height: MediaQuery.of(context).padding.bottom == 0.0
                    ? 0.0
                    : MediaQuery.of(context).padding.bottom / 2.0)
          ]),

          /// EMPTY LIST TEXT
          _phaseChecklistCommentsViewModel.loadingStatus ==
                  LoadingStatus.completed
              // && _phaseChecklistCommentsViewModel.comments.isEmpty
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
          _phaseChecklistCommentsViewModel.loadingStatus ==
                  LoadingStatus.searching
              ? const LoadingIndicatorWidget()
              : Container()
        ])));
  }
}
