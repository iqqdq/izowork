import 'package:audiofileplayer/audiofileplayer.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:izowork/components/components.dart';
import 'package:izowork/models/models.dart';
import 'package:izowork/notifiers/domain.dart';
import 'package:izowork/screens/chat/views/chat_list_item_widget.dart';
import 'package:izowork/views/views.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart';

class ChatScreenBodyWidget extends StatefulWidget {
  const ChatScreenBodyWidget({Key? key}) : super(key: key);

  @override
  _ChatScreenBodyState createState() => _ChatScreenBodyState();
}

class _ChatScreenBodyState extends State<ChatScreenBodyWidget>
    with AutomaticKeepAliveClientMixin {
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final Audio _audio = Audio.load('assets/sounds/message_receive.mp3');

  late ChatViewModel _chatViewModel;

  Pagination _pagination = Pagination(offset: 0, size: 50);
  bool _isSearching = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _chatViewModel.getLocalStorageParams().then((value) => _chatViewModel
          .connectSocket()
          .then((value) => _addSocketListener(_chatViewModel.socket))
          .then((value) => _chatViewModel.getChatList(
              pagination: _pagination, search: _textEditingController.text)));
    });
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _focusNode.dispose();

    _audio.dispose();

    super.dispose();
  }

  // MARK: -
  // MARK: - FUNCTIONS

  void _addSocketListener(Socket? socket) {
    // bool found = false;
    // Message? message;

    socket?.onConnect((_) {
      debugPrint('SOCKET CONNECTION SUCCESS');

      if (_chatViewModel.token != null) {
        socket.emit(
          'join',
          ChatConnectRequest(accessToken: _chatViewModel.token!),
        );
      }
    });

    socket?.onDisconnect((data) => {
          debugPrint('SOCKET DISCONNECTED'),
          _chatViewModel.connectSocket().then(
                (value) => _addSocketListener(socket),
              )
        });

    socket?.on(
        'message',
        (data) => {
              // UPDATE CHAT LAST MESSAGE DATA
              _chatViewModel.clearChats(),
              _chatViewModel
                  .getChatList(
                      pagination: _pagination,
                      search: _textEditingController.text)
                  .then((value) => _audio.play()),
            });
  }

  Future _onRefresh() async {
    await _chatViewModel.getChatList(
      pagination: _pagination,
      search: _textEditingController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    _chatViewModel = Provider.of<ChatViewModel>(
      context,
      listen: true,
    );

    return Scaffold(
        backgroundColor: HexColors.white,
        appBar: AppBar(
            toolbarHeight: 68.0,
            titleSpacing: 0.0,
            elevation: 0.0,
            systemOverlayStyle: SystemUiOverlayStyle.dark,
            backgroundColor: Colors.transparent,
            automaticallyImplyLeading: false,
            title: Column(children: [
              const SizedBox(height: 10.0),
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
                                      setState(() => _isSearching = true),
                                      EasyDebounce.debounce('chat_debouncer',
                                          const Duration(milliseconds: 500),
                                          () async {
                                        _pagination =
                                            Pagination(offset: 0, size: 50);

                                        _chatViewModel
                                            .getChatList(
                                                pagination: _pagination,
                                                search:
                                                    _textEditingController.text)
                                            .then((value) => setState(
                                                () => _isSearching = false));
                                      })
                                    },
                                onClearTap: () => {
                                      //  _chatViewModel.resetFilter(),
                                      _pagination.offset = 0,
                                      _chatViewModel.getChatList(
                                          pagination: _pagination,
                                          search: _textEditingController.text)
                                    })),
                  ])),
              const SizedBox(height: 12.0),
              const SeparatorWidget()
            ])),
        floatingActionButton: MediaQuery.of(context).viewInsets.bottom == 0.0
            ? FloatingButtonWidget(
                onTap: () => _chatViewModel.showStaffScreen(context))
            : Container(),
        body: SizedBox.expand(
          child: Stack(children: [
            /// CHATS LIST VIEW
            LiquidPullToRefresh(
                color: HexColors.primaryMain,
                backgroundColor: HexColors.white,
                springAnimationDurationInMilliseconds: 300,
                onRefresh: _onRefresh,
                child: ListView.builder(
                    padding:
                        const EdgeInsets.only(top: 16.0, bottom: 16.0 + 64.0),
                    itemCount: _chatViewModel.chats.length,
                    itemBuilder: (context, index) {
                      return ChatListItemWidget(
                          key: ValueKey(_chatViewModel.chats[index]),
                          chat: _chatViewModel.chats[index],
                          onTap: () =>
                              _chatViewModel.showDialogScreen(context, index));
                    })),

            /// FILTER BUTTON
            // SafeArea(
            //     child: Align(
            //         alignment: Alignment.bottomCenter,
            //         child: Padding(
            //             padding: const EdgeInsets.only(bottom: 6.0),
            //             child: FilterButtonWidget(
            //               onTap: () => _chatViewModel.showMapFilterSheet(context),
            //               // onClearTap: () => {}
            //             )))),

            /// INDICATOR
            _chatViewModel.loadingStatus == LoadingStatus.searching &&
                    !_isSearching
                ? const LoadingIndicatorWidget()
                : Container()
          ]),
        ));
  }
}
