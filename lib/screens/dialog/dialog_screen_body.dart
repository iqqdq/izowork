import 'package:audiofileplayer/audiofileplayer.dart';
import 'package:blur/blur.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/pagination.dart';
import 'package:izowork/entities/request/chat_connect_request.dart';
import 'package:izowork/entities/request/message_request.dart';
import 'package:izowork/entities/response/message.dart';
import 'package:izowork/models/dialog_view_model.dart';
import 'package:izowork/screens/dialog/views/bubble_widget.dart';
import 'package:izowork/services/urls.dart';
import 'package:izowork/views/back_button_widget.dart';
import 'package:izowork/components/loading_status.dart';
import 'package:izowork/components/titles.dart';
import 'package:izowork/views/chat_message_bar_widget.dart';
import 'package:izowork/views/loading_indicator_widget.dart';
import 'package:izowork/views/scroll_to_end_button_widget.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart';

class DialogScreenBodyWidget extends StatefulWidget {
  final Function(Message)? onPop;

  const DialogScreenBodyWidget({Key? key, this.onPop}) : super(key: key);

  @override
  _DialogScreenBodyState createState() => _DialogScreenBodyState();
}

class _DialogScreenBodyState extends State<DialogScreenBodyWidget> {
  final ScrollController _scrollController = ScrollController();

  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  final Audio _audio = Audio.load('assets/sounds/message_sent.mp3');

  final Pagination _pagination = Pagination(offset: 0, size: 50);

  final List<Widget> _bubbles = [];

  late DialogViewModel _dialogViewModel;

  bool _isGroupChat = false;

  int _count = 0;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _pagination.offset += 1;
        _dialogViewModel.getMessageList(pagination: _pagination);
      }

      setState(() {
        // SET SCROLL TO BOTTOM BUTTON VISIBLE
      });
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _dialogViewModel.getLocalService().then((value) => _dialogViewModel
          .connectSocket()
          .then((value) => _addSocketListener(_dialogViewModel.socket))
          .then(
            (value) => _dialogViewModel
                .getMessageList(pagination: _pagination)
                .then((value) => _updateBubbles(false)),
          ));
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _textEditingController.dispose();
    _focusNode.dispose();
    _dialogViewModel.socket?.disconnect();
    _dialogViewModel.socket?.dispose();

    if (widget.onPop != null && _dialogViewModel.messages.isNotEmpty) {
      widget.onPop!(_dialogViewModel.messages.first);
    }

    _audio.dispose();

    super.dispose();
  }

  // MARK: -
  // MARK: - FUNCTIONS

  void _addSocketListener(Socket? socket) {
    socket?.onConnect((_) {
      debugPrint('SOCKET CONNECTION SUCCESS');

      if (_dialogViewModel.token != null) {
        socket.emit(
          'join',
          ChatConnectRequest(accessToken: _dialogViewModel.token!),
        );
      }
    });

    socket?.onDisconnect((data) => {
          debugPrint('SOCKET DISCONNECTED'),
          _dialogViewModel.connectSocket().then(
                (value) => _addSocketListener(_dialogViewModel.socket),
              )
        });

    socket?.on(
        'message',
        (data) => {
              // UPDATE MESSAGES DATA
              _dialogViewModel.messages.insert(
                0,
                Message.fromJson(data["message"]),
              ),

              // UPDATE NEW MESSAGE COUNT
              if (_dialogViewModel.userId !=
                      (Message.fromJson(data["message"])).userId &&
                  _scrollController.position.pixels >= 50.0)
                {
                  setState(() => _count++),
                },

              /// PLAY MESSAGE RECEIVE SOUND
              // Audio.load('assets/sounds/message_receive.mp3').play(),

              // UPDATE BUBBLES
              _updateBubbles(true),
            });
  }

  Future _updateBubbles(bool animate) async {
    int index = 0;

    _bubbles.clear();

    for (var element in _dialogViewModel.messages) {
      bool isMine = false;
      bool isAudio = false;
      bool isFile = false;

      isMine = _dialogViewModel.userId == element.userId;

      if (_dialogViewModel.messages[index].files.length == 1) {
        // SHOW SINGLE FILE
        isAudio = _dialogViewModel.messages[index].files.first.mimeType == null
            ? false
            : _dialogViewModel.messages[index].files.first.mimeType!
                    .contains('audio') ||
                _dialogViewModel.messages[index].files.first.name
                    .contains('m4a');

        isFile = !isAudio && element.files.isNotEmpty;
      } else if (_dialogViewModel.messages[index].files.length > 1) {
        // SHOW A FEW FILES
      }

      if (element.id != null) {
        setState(() {
          if (mounted) {
            _bubbles.insert(
              0,
              BubbleWidget(
                key: ValueKey(_dialogViewModel.messages[index].id),
                animate: animate && _bubbles.isEmpty,
                verticalSpacing: !_isSameNextAuthor(index)
                    ? isMine
                        ? 16.0
                        : 10.0
                    : 0.0,
                isMine: isMine,
                isRead: element.readAt != null,
                isFile: isFile,
                isDownloading: _dialogViewModel.downloadIndex == index,
                isAudio: isAudio,
                showDate: index == _dialogViewModel.messages.length - 1
                    ? true
                    : !_isSamePrevDate(index),
                showName: _isGroupChat
                    ? !_isSamePrevAuthor(index) ||
                        !_isSamePrevDate(index) && !_isSameNextAuthor(index) ||
                        !_isSamePrevDate(index) && !_isSamePrevAuthor(index)
                    : false,
                isGroupLastMessage:
                    _isGroupChat ? !_isSameNextAuthor(index) : false,
                user: _isGroupChat ? element.user : null,
                text: isFile
                    ? element.files.first.name
                    : isAudio
                        ? messageMediaUrl + (element.files.first.filename ?? '')
                        : element.text,
                dateTime: element.createdAt.toLocal(),
                onUserTap: () =>
                    _dialogViewModel.showProfileScreen(context, element),
                onTap: isFile
                    ? () => _dialogViewModel.openFile(context, index, element)
                    : null,
                onLongPress: isFile || isAudio
                    ? null
                    : () => _dialogViewModel.showAddTaskSheet(
                        context, element.text),
              ),
            );
          }

          index++;
        });
      }
    }
  }

  void _scrollDown() {
    setState(() => _count = 0);
    _scrollController.animateTo(0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.fastOutSlowIn);
  }

  bool _isSamePrevDate(int index) {
    DateTime date =
        _dialogViewModel.messages[index].createdAt.toUtc().toLocal();
    DateTime? dateTime = index == _dialogViewModel.messages.length - 1
        ? null
        : _dialogViewModel.messages[index + 1].createdAt.toUtc().toLocal();

    return date.year == dateTime?.year &&
        date.month == dateTime?.month &&
        date.day == dateTime?.day;
  }

  bool _isSamePrevAuthor(int index) {
    String authorId = _dialogViewModel.messages[index].userId;
    String? nextAuthorId = index == _dialogViewModel.messages.length - 1
        ? null
        : _dialogViewModel.messages[index + 1].userId;

    return authorId == nextAuthorId;
  }

  bool _isSameNextAuthor(int index) {
    String authorId = _dialogViewModel.messages[index].userId;
    String? nextAuthorId =
        index == 0 ? null : _dialogViewModel.messages[index - 1].userId;

    return authorId == nextAuthorId;
  }

  @override
  Widget build(BuildContext context) {
    _dialogViewModel = Provider.of<DialogViewModel>(
      context,
      listen: true,
    );

    _isGroupChat = _dialogViewModel.chat.chatType == 'GROUP';

    String? _url = _dialogViewModel.chat.user?.avatar;

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
                child: BackButtonWidget(onTap: () => {Navigator.pop(context)})),
            title: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              /// AVATAR
              Stack(children: [
                Container(
                    width: 30.0,
                    height: 30.0,
                    padding: EdgeInsets.all(_isGroupChat ? 6.0 : 0.0),
                    decoration: BoxDecoration(
                        color: _isGroupChat
                            ? HexColors.additionalViolet.withOpacity(0.8)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(15.0)),
                    child: SvgPicture.asset(
                        _isGroupChat
                            ? 'assets/ic_group.svg'
                            : 'assets/ic_avatar.svg',
                        color:
                            _isGroupChat ? HexColors.white : HexColors.grey30,
                        width: 30.0,
                        height: 30.0,
                        fit: BoxFit.cover)),
                _url == null
                    ? Container()
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(15.0),
                        child: CachedNetworkImage(
                            cacheKey: _url,
                            imageUrl: avatarUrl + _url,
                            width: 30.0,
                            height: 30.0,
                            fit: BoxFit.cover)),
              ]),
              const SizedBox(width: 12.0),

              /// CHAT/USER NAME
              Expanded(
                  child: Text(
                      _dialogViewModel.chat.name ??
                          _dialogViewModel.chat.user?.name ??
                          '-',
                      style: TextStyle(
                          overflow: TextOverflow.ellipsis,
                          color: HexColors.black,
                          fontSize: 18.0,
                          fontFamily: 'PT Root UI',
                          fontWeight: FontWeight.bold))),
            ])),
        body: SizedBox.expand(
            child: Stack(children: [
          Column(children: [
            /// DIALOG LIST VIEW
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
                            reverse: true,
                            child: GestureDetector(
                                onTap: () => FocusScope.of(context).unfocus(),
                                child: ListView.builder(
                                  cacheExtent: 0.0,
                                  reverse: false,
                                  primary: false,
                                  shrinkWrap: true,
                                  padding: const EdgeInsets.only(
                                      top: 12.0, left: 10.0, right: 10.0),
                                  itemCount: _bubbles.length,
                                  itemBuilder: (context, index) =>
                                      _bubbles[index],
                                )))))),

            /// MESSAGE BAR
            ChatMessageBarWidget(
              isSending: _dialogViewModel.isSending,
              isAudio: true,
              textEditingController: _textEditingController,
              focusNode: _focusNode,
              hintText: Titles.typeMessage,
              onSendTap: () => {
                FocusScope.of(context).unfocus(),
                _scrollDown(),
                if (_dialogViewModel.token != null)
                  {
                    /// PLAY MESSAGE SENT SOUND
                    _audio.play(),

                    /// SEND MESSAGE
                    _dialogViewModel.socket?.emit(
                        'message',
                        MessageRequest(
                          chatId: _dialogViewModel.chat.id,
                          accessToken: _dialogViewModel.token!,
                          message: _textEditingController.text,
                        )),

                    /// REPEAT SOCKET CONNECT IF GROUP CHAT WAS EMPTY BEFORE OUR MESSAGE
                    if (_isGroupChat && _dialogViewModel.messages.isEmpty)
                      {
                        _dialogViewModel
                            .getMessageList(pagination: _pagination)
                            .then((value) => _updateBubbles(true))
                            .then((value) => _dialogViewModel
                                .connectSocket()
                                .then((value) => _addSocketListener(
                                    _dialogViewModel.socket)))
                      },

                    /// CLEAR INPUT
                    _textEditingController.clear(),
                  }
              },
              onClipTap: () => _dialogViewModel.addFile(context),
              onRecordStarted: () => _dialogViewModel.recordAudio(),
              onRecordCanceled: () => _dialogViewModel.cancelRecordAudio(),
              onRecord: () => _dialogViewModel.sendAudioMessage(context),
            ),
            Container(
                color: HexColors.white,
                height: MediaQuery.of(context).padding.bottom == 0.0
                    ? 0.0
                    : MediaQuery.of(context).padding.bottom / 2.0)
          ]),

          /// SCROLL TO END / NEW MESSAGE INDICATOR
          Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                  padding: EdgeInsets.only(
                      right: 10.0,
                      bottom: MediaQuery.of(context).padding.bottom == 0.0
                          ? 80.0
                          : MediaQuery.of(context).padding.bottom + 60.0),
                  child: ScrollToEndButtonWidget(
                      isHidden: !_scrollController.hasClients ||
                          !(_scrollController.position.pixels >= 50.0 &&
                              _dialogViewModel.messages.length > 1),
                      count: _count,
                      onTap: () => _scrollDown()))),

          /// EMPTY LIST TEXT
          _dialogViewModel.loadingStatus == LoadingStatus.completed &&
                  _dialogViewModel.messages.isEmpty
              ? Center(
                  child: Padding(
                      padding: const EdgeInsets.only(
                          left: 20.0, right: 20.0, bottom: 100.0),
                      child: Text(Titles.noMessages,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 16.0,
                              color: HexColors.grey50))))
              : Container(),

          /// SHOW USER LIST
          _isGroupChat
              ? AnimatedOpacity(
                  opacity: _dialogViewModel.loadingStatus ==
                              LoadingStatus.searching &&
                          _dialogViewModel.messages.isEmpty
                      ? 0.0
                      : _scrollController.positions.isEmpty
                          ? 0.0
                          : _scrollController.position.userScrollDirection ==
                                      ScrollDirection.reverse ||
                                  _scrollController.position.pixels ==
                                      _scrollController.position.maxScrollExtent
                              ? 1.0
                              : 0.0,
                  duration: const Duration(milliseconds: 300),
                  child: Container(
                      margin: const EdgeInsets.only(top: 12.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                                onTap: () => _dialogViewModel
                                    .showGroupChatUsersScreen(context),
                                child: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 0.5,
                                            color: HexColors.additionalViolet),
                                        borderRadius:
                                            BorderRadius.circular(16.0)),
                                    child: Blur(
                                        borderRadius:
                                            BorderRadius.circular(16.0),
                                        overlay: Center(
                                            child: Text(Titles.showAllUsers,
                                                style: TextStyle(
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    color: HexColors
                                                        .additionalViolet,
                                                    fontSize: 16.0,
                                                    fontWeight: FontWeight.w600,
                                                    fontFamily: 'PT Root UI'))),
                                        child: Container(
                                            width: 272.0,
                                            height: 40.0,
                                            decoration: BoxDecoration(color: HexColors.white10, borderRadius: BorderRadius.circular(16.0))))))
                          ])))
              : Container(),

          /// INDICATOR
          _dialogViewModel.loadingStatus == LoadingStatus.searching
              ? const LoadingIndicatorWidget()
              : Container()
        ])));
  }
}
