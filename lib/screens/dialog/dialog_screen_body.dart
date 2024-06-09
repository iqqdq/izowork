import 'package:audiofileplayer/audiofileplayer.dart';
import 'package:blur/blur.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart';

import 'package:izowork/components/components.dart';
import 'package:izowork/models/models.dart';
import 'package:izowork/notifiers/notifiers.dart';
import 'package:izowork/screens/dialog/views/bubble_widget.dart';
import 'package:izowork/api/api.dart';
import 'package:izowork/screens/dialog/views/dialog_add_task_widget.dart';
import 'package:izowork/screens/participants/participants_screen.dart';
import 'package:izowork/screens/profile/profile_screen.dart';
import 'package:izowork/screens/task_create/task_create_screen.dart';
import 'package:izowork/views/views.dart';

class DialogScreenBodyWidget extends StatefulWidget {
  final Function(Message)? onPop;

  const DialogScreenBodyWidget({
    Key? key,
    this.onPop,
  }) : super(key: key);

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

    WidgetsBinding.instance.addPostFrameCallback((_) => _updateChat());
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

  @override
  Widget build(BuildContext context) {
    _dialogViewModel = Provider.of<DialogViewModel>(
      context,
      listen: true,
    );

    String? _url = _dialogViewModel.chat?.user?.avatar;

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
            onTap: () => Navigator.pop(context),
          ),
        ),
        title: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          /// AVATAR
          _dialogViewModel.chat == null
              ? Container()
              : AvatarWidget(
                  url: avatarUrl,
                  endpoint: _url,
                  size: 30.0,
                  isGroupAvatar: _isGroupChat,
                ),

          const SizedBox(width: 12.0),

          /// CHAT/USER NAME
          Expanded(
            child: Text(
              _dialogViewModel.chat?.name ??
                  _dialogViewModel.chat?.user?.name ??
                  '',
              style: TextStyle(
                overflow: TextOverflow.ellipsis,
                color: HexColors.black,
                fontSize: 18.0,
                fontFamily: 'PT Root UI',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 16.0),
        ]),
      ),
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
                _sendMessage(),
              },
              onClipTap: () => _dialogViewModel.addFile(),
              onRecordStarted: () => _dialogViewModel.recordAudio(),
              onRecordCanceled: () => _dialogViewModel.cancelRecordAudio(),
              onRecord: () => _dialogViewModel.sendAudioMessage(),
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
                onTap: () => _scrollDown(),
              ),
            ),
          ),

          /// EMPTY LIST TEXT
          _dialogViewModel.loadingStatus == LoadingStatus.completed &&
                  _dialogViewModel.messages.isEmpty
              ? Center(
                  child: Text(Titles.noMessages,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 16.0,
                          color: HexColors.grey50)))
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
                            onTap: () => _showGroupChatUsersScreen(),
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 0.5,
                                      color: HexColors.additionalViolet),
                                  borderRadius: BorderRadius.circular(16.0)),
                              child: Blur(
                                borderRadius: BorderRadius.circular(16.0),
                                overlay: Center(
                                  child: Text(
                                    Titles.showAllUsers,
                                    style: TextStyle(
                                        overflow: TextOverflow.ellipsis,
                                        color: HexColors.additionalViolet,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'PT Root UI'),
                                  ),
                                ),
                                child: Container(
                                  width: 272.0,
                                  height: 40.0,
                                  decoration: BoxDecoration(
                                    color: HexColors.white10,
                                    borderRadius: BorderRadius.circular(16.0),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ]),
                  ),
                )
              : Container(),

          /// INDICATOR
          _dialogViewModel.loadingStatus == LoadingStatus.searching
              ? const LoadingIndicatorWidget()
              : Container()
        ]),
      ),
    );
  }

  // MARK: -
  // MARK: - FUNCTIONS

  void _updateChat() async {
    await _dialogViewModel.getLocalStorageParams();

    await _dialogViewModel.getChatById();

    await _dialogViewModel.getMessageList(pagination: _pagination);

    await _dialogViewModel.connectSocket();

    _addSocketListener(_dialogViewModel.socket);

    _updateBubbles(false);
  }

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

    socket?.on(
        'message',
        (data) => {
              // UPDATE MESSAGES DATA
              _dialogViewModel.messages
                  .insert(0, Message.fromJson(data["message"])),

              // UPDATE NEW MESSAGE COUNT
              if (_dialogViewModel.userId !=
                      (Message.fromJson(data["message"])).userId &&
                  _scrollController.position.pixels >= 50.0)
                setState(() => _count++),

              // UPDATE BUBBLES
              _updateBubbles(true),
            });
  }

  void _sendMessage() {
    if (_dialogViewModel.token == null) return;
    if (_dialogViewModel.chat == null) return;

    /// PLAY MESSAGE SENT SOUND
    _audio.play();

    /// SEND MESSAGE
    _dialogViewModel.socket?.emit(
        'message',
        MessageRequest(
          chatId: _dialogViewModel.chat!.id,
          accessToken: _dialogViewModel.token!,
          message: _textEditingController.text,
        ));

    /// REPEAT SOCKET CONNECT IF GROUP CHAT WAS EMPTY BEFORE OUR MESSAGE
    if (_isGroupChat && _dialogViewModel.messages.isEmpty) {
      _dialogViewModel
          .getMessageList(pagination: _pagination)
          .then((value) => _updateBubbles(true))
          .then(
            (value) => _dialogViewModel.connectSocket().then(
                  (value) => _addSocketListener(_dialogViewModel.socket),
                ),
          );
    }

    /// CLEAR INPUT
    _textEditingController.clear();
  }

  Future _updateBubbles(bool animate) async {
    _isGroupChat = _dialogViewModel.chat?.chatType == 'GROUP';

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
                onUserTap: () => _showProfileScreen(element),
                onTap: isFile
                    ? () => _dialogViewModel.openFile(
                          index,
                          element,
                        )
                    : null,
                onLongPress: isFile || isAudio
                    ? null
                    : () => _showAddTaskSheet(element.text),
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

  // MARK: -
  // MARK: - PUSH

  void _showGroupChatUsersScreen() {
    if (_dialogViewModel.chat == null) return;

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                ParticipantsScreenWidget(chat: _dialogViewModel.chat!)));
  }

  void _showAddTaskSheet(String text) => showCupertinoModalBottomSheet(
      enableDrag: false,
      topRadius: const Radius.circular(16.0),
      barrierColor: Colors.black.withOpacity(0.6),
      backgroundColor: HexColors.white,
      context: context,
      builder: (sheetContext) => DialogAddTaskWidget(
            text: text,
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TaskCreateScreenWidget(
                      message: text,
                      onCreate: (task) => Toast().showTopToast(
                            '${Titles.task} "${task?.name}" создана',
                          )),
                )),
          ));

  void _showProfileScreen(Message message) => Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ProfileScreenWidget(
                isMine: false,
                user: message.user!,
                onPop: (user) => null,
              )));
}
