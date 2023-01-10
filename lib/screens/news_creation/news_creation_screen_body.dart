import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/models/news_creation_view_model.dart';
import 'package:izowork/views/back_button_widget.dart';
import 'package:izowork/views/border_button_widget.dart';
import 'package:izowork/views/button_widget_widget.dart';
import 'package:izowork/components/loading_status.dart';
import 'package:izowork/components/titles.dart';
import 'package:izowork/views/loading_indicator_widget.dart';
import 'package:izowork/views/label_input_widget.dart';
import 'package:provider/provider.dart';

class NewsCreationScreenBodyWidget extends StatefulWidget {
  const NewsCreationScreenBodyWidget({Key? key}) : super(key: key);

  @override
  _NewsCreationScreenBodyState createState() => _NewsCreationScreenBodyState();
}

class _NewsCreationScreenBodyState extends State<NewsCreationScreenBodyWidget> {
  final TextEditingController _titleTextEditingController =
      TextEditingController();
  final FocusNode _titleFocusNode = FocusNode();
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  late NewsCreationViewModel _newsCreationViewModel;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _titleTextEditingController.dispose();
    _titleFocusNode.dispose();
    _textEditingController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _newsCreationViewModel =
        Provider.of<NewsCreationViewModel>(context, listen: true);

    final TextStyle _style = TextStyle(
        color: HexColors.black, fontFamily: 'PT Root UI', fontSize: 16.0);

    return Scaffold(
        backgroundColor: HexColors.white,
        appBar: AppBar(
            titleSpacing: 16.0,
            elevation: 0.0,
            systemOverlayStyle: SystemUiOverlayStyle.dark,
            backgroundColor: Colors.transparent,
            automaticallyImplyLeading: false,
            title: Column(children: [
              Stack(children: [
                BackButtonWidget(onTap: () => Navigator.pop(context)),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text(Titles.newNews,
                      style: TextStyle(
                          color: HexColors.black,
                          fontSize: 18.0,
                          fontFamily: 'PT Root UI',
                          fontWeight: FontWeight.bold)),
                ])
              ])
            ])),
        body: SizedBox.expand(
            child: Stack(children: [
          /// NEWS LIST VIEW
          ListView(
              shrinkWrap: true,
              padding: EdgeInsets.only(
                  left: 16.0,
                  right: 16.0,
                  top: 16.0,
                  bottom: 80.0 + MediaQuery.of(context).padding.bottom),
              children: [
                /// NAME INPUT
                LabelInputWidget(
                    margin: const EdgeInsets.only(bottom: 16.0),
                    textEditingController: _titleTextEditingController,
                    focusNode: _titleFocusNode,
                    labelText: Titles.title + ' ${Titles.news.toLowerCase()}'),

                /// TEXT INPUT
                Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 6.0),
                    height: 336.0,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        border:
                            Border.all(width: 1.0, color: HexColors.grey20)),
                    child: TextField(
                        maxLines: null,
                        controller: _textEditingController,
                        focusNode: _focusNode,
                        keyboardAppearance: Brightness.light,
                        cursorColor: HexColors.primaryDark,
                        textInputAction: TextInputAction.done,
                        textCapitalization: TextCapitalization.sentences,
                        style: _style,
                        decoration: InputDecoration(
                          labelText:
                              Titles.text + ' ${Titles.news.toLowerCase()}',
                          labelStyle: _style.copyWith(color: HexColors.grey40),
                          contentPadding: EdgeInsets.only(
                              top: _focusNode.hasFocus ? 8.0 : 10.0),
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                        ),
                        onChanged: (text) => {setState},
                        onEditingComplete: () =>
                            FocusScope.of(context).unfocus())),
                SizedBox(
                    height: _newsCreationViewModel.file == null ? 0.0 : 16.0),

                /// IMAGE
                _newsCreationViewModel.file == null
                    ? Container()
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(16.0),
                        child: Image.file(_newsCreationViewModel.file!,
                            height: 180.0, fit: BoxFit.cover)),

                /// CLIP IMAGE BUTTON
                BorderButtonWidget(
                    title: _newsCreationViewModel.file == null
                        ? Titles.clipMedia
                        : Titles.changeMedia,
                    margin: const EdgeInsets.only(top: 16.0),
                    onTap: () => _newsCreationViewModel.pickImage())
              ]),

          /// FILTER BUTTON
          Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).padding.bottom == 0.0
                      ? 16.0
                      : 0.0),
              child: Align(
                  alignment: Alignment.bottomCenter,
                  child: ButtonWidget(
                      title: Titles.publicate,
                      isDisabled: _titleTextEditingController.text.isEmpty ||
                          _textEditingController.text.isEmpty,
                      onTap: () => {}))),

          /// INDICATOR
          _newsCreationViewModel.loadingStatus == LoadingStatus.searching
              ? const LoadingIndicatorWidget()
              : Container()
        ])));
  }
}
