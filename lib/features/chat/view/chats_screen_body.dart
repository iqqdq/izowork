import 'package:audiofilereader/audiofileplayer.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:izowork/components/components.dart';
import 'package:izowork/features/chat/view_model/chat_view_model.dart';
import 'package:izowork/models/models.dart';

import 'package:izowork/features/chat/view/views/chat_list_item_widget.dart';
import 'package:izowork/features/dialog/view/dialog_screen.dart';
import 'package:izowork/features/staff/view/staff_screen.dart';
import 'package:izowork/views/views.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart';

class ChatsScreenBodyWidget extends StatefulWidget {
  const ChatsScreenBodyWidget({Key? key}) : super(key: key);

  @override
  _ChatsScreenBodyState createState() => _ChatsScreenBodyState();
}

class _ChatsScreenBodyState extends State<ChatsScreenBodyWidget>
    with AutomaticKeepAliveClientMixin {
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  final Audio _audio = Audio.load('assets/sounds/message_receive.mp3');

  Pagination _pagination = Pagination();
  bool _isSearching = false;

  late ChatsViewModel _chatsViewModel;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) => _updateChats());
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _focusNode.dispose();
    _audio.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    _chatsViewModel = Provider.of<ChatsViewModel>(
      context,
      listen: true,
    );

    return Scaffold(
        backgroundColor: HexColors.white,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
            toolbarHeight: 68.0,
            titleSpacing: 0.0,
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
                      EasyDebounce.debounce(
                          'chat_debouncer', const Duration(milliseconds: 500),
                          () async {
                        _pagination = Pagination();

                        _chatsViewModel
                            .getChatList(
                                pagination: _pagination,
                                search: _textEditingController.text)
                            .then((value) =>
                                setState(() => _isSearching = false));
                      })
                    },
                    onClearTap: () => {
                      _pagination.offset = 0,
                      _chatsViewModel.getChatList(
                          pagination: _pagination,
                          search: _textEditingController.text)
                    },
                  )),
                ]),
              ),
              const SizedBox(height: 12.0),
              const SeparatorWidget()
            ])),
        floatingActionButton: MediaQuery.of(context).viewInsets.bottom == 0.0
            ? FloatingButtonWidget(onTap: () => _showStaffScreen())
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
                  padding: const EdgeInsets.only(
                    top: 16.0,
                    bottom: 16.0 + 64.0,
                  ),
                  itemCount: _chatsViewModel.chats.length,
                  itemBuilder: (context, index) {
                    final chat = _chatsViewModel.chats[index];

                    return ChatListItemWidget(
                        key: ValueKey(chat.id),
                        chat: chat,
                        onTap: () => _showDialogScreen(index));
                  }),
            ),

            /// EMPTY LIST TEXT
            _chatsViewModel.loadingStatus == LoadingStatus.completed &&
                    _chatsViewModel.chats.isEmpty
                ? const NoResultTitle()
                : Container(),

            /// INDICATOR
            _chatsViewModel.loadingStatus == LoadingStatus.searching ||
                    _isSearching
                ? const LoadingIndicatorWidget()
                : Container()
          ]),
        ));
  }

  // MARK: -
  // MARK: - FUNCTIONS

  void _updateChats() async {
    await _chatsViewModel.getLocalStorageParams();

    await _chatsViewModel.connectSocket();

    await _chatsViewModel.getChatList(
      pagination: _pagination,
      search: _textEditingController.text,
    );

    _addSocketListener(_chatsViewModel.socket);
  }

  void _addSocketListener(Socket? socket) {
    socket?.onConnect((_) {
      debugPrint('SOCKET CONNECTION SUCCESS');

      if (_chatsViewModel.token != null) {
        socket.emit(
          'join',
          ChatConnectRequest(accessToken: _chatsViewModel.token!),
        );
      }
    });

    socket?.on(
        'message',
        (data) => {
              // UPDATE CHAT LAST MESSAGE DATA
              _chatsViewModel.clearChats(),
              _chatsViewModel
                  .getChatList(
                    pagination: _pagination,
                    search: _textEditingController.text,
                  )
                  .then((value) => _audio.play()),
            });
  }

  Future _onRefresh() async {
    _pagination.reset();
    await _chatsViewModel.getChatList(
      pagination: _pagination,
      search: _textEditingController.text,
    );
  }

  // MARK: -
  // MARK: - PUSH

  void _showDialogScreen(int index) {
    _chatsViewModel.clearUndreadMessageCount(index);

    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DialogScreenWidget(
              socket: _chatsViewModel.socket,
              id: _chatsViewModel.chats[index].id,
              onPop: (message) => _chatsViewModel.replaceLastMassage(message)),
        ));
  }

  void _showStaffScreen() => Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const StaffScreenWidget(),
      ));
}
