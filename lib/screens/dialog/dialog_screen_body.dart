import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/models/dialog_view_model.dart';
import 'package:izowork/screens/dialog/views/bubble_widget.dart';
import 'package:izowork/views/back_button_widget.dart';
import 'package:izowork/components/loading_status.dart';
import 'package:izowork/components/titles.dart';
import 'package:izowork/views/chat_message_bar_widget.dart';
import 'package:izowork/views/loading_indicator_widget.dart';
import 'package:provider/provider.dart';

class DialogScreenBodyWidget extends StatefulWidget {
  const DialogScreenBodyWidget({Key? key}) : super(key: key);

  @override
  _DialogScreenBodyState createState() => _DialogScreenBodyState();
}

class _DialogScreenBodyState extends State<DialogScreenBodyWidget> {
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  late DialogViewModel _dialogViewModel;

  List<String> _list = [
    'Ну ты совсем умный, книжки читал? 👍',
    'audio',
    'filename.pdf',
    'filename.pdf',
    'Как дела? 😁😁😁',
    'Безусловно, существующая теория позволяет оценить значение распределения внутренних резервов и ресурсов.'
  ];

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
    _dialogViewModel = Provider.of<DialogViewModel>(context, listen: true);

    return Scaffold(
        backgroundColor: HexColors.grey,
        appBar: AppBar(
            titleSpacing: 0.0,
            elevation: 0.0,
            centerTitle: true,
            systemOverlayStyle: SystemUiOverlayStyle.dark,
            backgroundColor: HexColors.white,
            automaticallyImplyLeading: false,
            leading: Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: BackButtonWidget(onTap: () => Navigator.pop(context))),
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
                  child: Text('Аликджан Фахрутдинов',
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
                child: Scrollbar(
                    child: GestureDetector(
                        onTap: () => FocusScope.of(context).unfocus(),
                        child: ListView.builder(
                            reverse: true,
                            shrinkWrap: true,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 16.0),
                            itemCount: _list.length,
                            itemBuilder: (context, index) {
                              return BubbleWidget(
                                  isMine: index == 1 || index == 2,
                                  isFile: index == 2 || index == 3,
                                  isAudio: index == 0 || index == 1,
                                  isGroupLastMessage: index != 2 && index != 4,
                                  animate: false,
                                  text: _list[index],
                                  showDate: index != 1 && index != 3,
                                  dateTime: DateTime.now()
                                      .subtract(Duration(days: index)),
                                  onLongPress: () =>
                                      _dialogViewModel.showAddMapObjectSheet(
                                          context,
                                          index == 1 || index == 2,
                                          index == 2 || index == 3,
                                          index == 0 || index == 1,
                                          index != 2 && index != 4,
                                          _list[index],
                                          DateTime.now().subtract(
                                              Duration(days: index))));
                            })))),

            /// MESSAGE BAR
            ChatMessageBarWidget(
                isAudio: true,
                textEditingController: _textEditingController,
                focusNode: _focusNode,
                hintText: Titles.typeMessage,
                onSendTap: () => {},
                onClipTap: () => {}),
            Container(
                color: HexColors.white,
                height: MediaQuery.of(context).padding.bottom == 0.0
                    ? 0.0
                    : MediaQuery.of(context).padding.bottom / 2.0)
          ]),

          /// INDICATOR
          _dialogViewModel.loadingStatus == LoadingStatus.searching
              ? const LoadingIndicatorWidget()
              : Container()
        ])));
  }
}
