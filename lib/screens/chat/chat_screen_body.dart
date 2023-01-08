import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/views/filter_button_widget.dart';
import 'package:izowork/views/input_widget.dart';
import 'package:izowork/components/loading_status.dart';
import 'package:izowork/components/titles.dart';
import 'package:izowork/entities/chat.dart';
import 'package:izowork/models/chat_view_model.dart';
import 'package:izowork/screens/chat/views/chat_list_item_widget.dart';
import 'package:izowork/views/floating_button_widget.dart';
import 'package:izowork/views/loading_indicator_widget.dart';
import 'package:izowork/views/separator_widget.dart';
import 'package:provider/provider.dart';

class ChatScreenBodyWidget extends StatefulWidget {
  const ChatScreenBodyWidget({Key? key}) : super(key: key);

  @override
  _ChatScreenBodyState createState() => _ChatScreenBodyState();
}

class _ChatScreenBodyState extends State<ChatScreenBodyWidget>
    with AutomaticKeepAliveClientMixin {
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  late ChatViewModel _chatViewModel;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    _chatViewModel = Provider.of<ChatViewModel>(context, listen: true);

    return Scaffold(
        backgroundColor: HexColors.white,
        appBar: AppBar(
            toolbarHeight: 74.0,
            titleSpacing: 0.0,
            elevation: 0.0,
            systemOverlayStyle: SystemUiOverlayStyle.dark,
            backgroundColor: Colors.transparent,
            automaticallyImplyLeading: false,
            title: Column(children: [
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(children: [
                    Expanded(
                        child:

                            /// SEARCH INPUT
                            InputWidget(
                                textEditingController: _textEditingController,
                                focusNode: _focusNode,
                                margin: EdgeInsets.zero,
                                isSearchInput: true,
                                placeholder: '${Titles.search}...',
                                onTap: () => setState,
                                onChange: (text) => {
                                      // TODO SEARCH CHATS
                                    },
                                onClearTap: () => {
                                      // TODO CLEAR CHATS SEARCH
                                    })),
                  ])),
              const SizedBox(height: 16.0),
              const SeparatorWidget()
            ])),
        floatingActionButton: FloatingButtonWidget(
            onTap: () => {
                  // TODO ADD CHAT
                }),
        body: SizedBox.expand(
            child: Stack(children: [
          /// CHATS LIST VIEW
          ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.only(
                  left: 16.0, right: 16.0, top: 16.0, bottom: 16.0 + 48.0),
              itemCount: 10,
              itemBuilder: (context, index) {
                return ChatListItemWidget(chat: Chat(), onTap: () => {});
              }),

          /// FILTER BUTTON
          SafeArea(
              child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                      padding: const EdgeInsets.only(bottom: 6.0),
                      child: FilterButtonWidget(
                        onTap: () => {},
                        // onClearTap: () => {}
                      )))),

          /// INDICATOR
          _chatViewModel.loadingStatus == LoadingStatus.searching
              ? const LoadingIndicatorWidget()
              : Container()
        ])));
  }
}
