// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/pagination.dart';
import 'package:izowork/entities/request/chat_connect_request.dart';
import 'package:izowork/entities/request/message_request.dart';
import 'package:izowork/entities/response/message.dart';
import 'package:izowork/models/dialog_view_model.dart';
import 'package:izowork/screens/dialog/views/bubble_widget.dart';
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

  final List<Widget> _bubbles = [];

  late DialogViewModel _dialogViewModel;

  Pagination _pagination = Pagination(offset: 0, size: 50);

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
      _dialogViewModel.getUserParams().then((value) => {
            // ADD SOCKET LISTENER
            _dialogViewModel
                .connectSocket()
                .then((value) => _addSocketListener(_dialogViewModel.socket)),

            // GET MESSAGE DATA
            _dialogViewModel
                .getMessageList(pagination: _pagination)
                .then((value) => _updateBubbles(false))
          });
    });
  }

  // MARK: -
  // MARK: - FUNCTIONS

  void _addSocketListener(Socket? socket) {
    _dialogViewModel.socket?.onConnect((_) {
      debugPrint('connect');

      if (_dialogViewModel.token != null) {
        _dialogViewModel.socket?.emit(
            'join', ChatConnectRequest(accessToken: _dialogViewModel.token!));
      }
    });

    _dialogViewModel.socket?.onConnectError((_) {
      debugPrint('connection error');
    });

    _dialogViewModel.socket?.on(
        'message',
        (data) => {
              // UPDATE MESSAGES DATA
              _dialogViewModel.messages
                  .insert(0, Message.fromJson(data["message"])),

              // UPDATE NEW MESSAGE COUNT
              if (_dialogViewModel.userId ==
                  (Message.fromJson(data["message"])).userId)
                {
                  setState(() => _count++),
                },

              // UPDATE BUBBLES
              _updateBubbles(true)
            });
  }

  Future _updateBubbles(bool animate) async {
    _bubbles.clear();

    setState(() {
      if (mounted) {
        int index = 0;
        _dialogViewModel.messages.forEach((element) {
          if (element.id != null) {
            _bubbles.insert(
                0,
                BubbleWidget(
                    isMine: _dialogViewModel.userId == element.userId,
                    isFile: false,
                    isAudio: false,
                    isGroupLastMessage: !_isSameNextAuthor(index),
                    animate: animate && _bubbles.isEmpty,
                    text: element.text,
                    showDate: index == _dialogViewModel.messages.length - 1
                        ? true
                        : !_isSamePrevDate(index, _dialogViewModel.messages),
                    dateTime: DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
                        .parse(element.createdAt)));
          }

          index++;
        });
      }
    });
  }

  void _scrollDown() {
    _scrollController.animateTo(0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.fastOutSlowIn);
  }

  bool _isSamePrevDate(int index, List<Message> messages) {
    DateTime date = DateFormat("yyyy-MM-dd").parse(messages[index].createdAt);
    DateTime? dateTime = index == messages.length - 1
        ? null
        : DateFormat("yyyy-MM-dd").parse(messages[index + 1].createdAt);

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
  void dispose() {
    _scrollController.dispose();
    _textEditingController.dispose();
    _focusNode.dispose();
    _dialogViewModel.socket?.disconnect();
    _dialogViewModel.socket?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _dialogViewModel = Provider.of<DialogViewModel>(context, listen: true);

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
                    onTap: () => {
                          if (widget.onPop != null &&
                              _dialogViewModel.messages.isNotEmpty)
                            {
                              widget.onPop!(_dialogViewModel.messages.first),
                            },
                          Navigator.pop(context)
                        })),
            title: Wrap(direction: Axis.horizontal, children: [
              Stack(children: [
                /// AVATAR
                SvgPicture.asset('assets/ic_avatar.svg',
                    color: HexColors.grey40,
                    width: 24.0,
                    height: 24.0,
                    fit: BoxFit.cover),
                // ClipRRect(
                //   borderRadius: BorderRadius.circular(12.0),
                //   child:
                // CachedNetworkImage(imageUrl: '', width: 24.0, height: 24.0, fit: BoxFit.cover)),
              ]),
              const SizedBox(width: 10.0),

              /// USERNAME
              Container(
                  constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.7),
                  child: Text('???',
                      style: TextStyle(
                          overflow: TextOverflow.ellipsis,
                          color: HexColors.black,
                          fontSize: 18.0,
                          fontFamily: 'PT Root UI',
                          fontWeight: FontWeight.bold)))
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
                                        left: 10.0, top: 16.0, right: 10.0),
                                    itemCount: _bubbles.length,
                                    itemBuilder: (context, index) =>
                                        _bubbles[index])))))),

            /// MESSAGE BAR
            ChatMessageBarWidget(
                isAudio: true,
                textEditingController: _textEditingController,
                focusNode: _focusNode,
                hintText: Titles.typeMessage,
                onSendTap: () => {
                      FocusScope.of(context).unfocus(),
                      _scrollDown(),
                      if (_dialogViewModel.token != null)
                        {
                          _dialogViewModel.socket?.emit(
                              'message',
                              MessageRequest(
                                  chatId: _dialogViewModel.chat.id,
                                  accessToken: _dialogViewModel.token!,
                                  message: _textEditingController.text)),
                          _textEditingController.clear(),
                        }
                    },
                onClipTap: () => {}),
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
                      onTap: () => {
                            setState(() => _count = 0),
                            _scrollDown(),
                          }))),

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

          /// INDICATOR
          _dialogViewModel.loadingStatus == LoadingStatus.searching
              ? const LoadingIndicatorWidget()
              : Container()
        ])));
  }
}
