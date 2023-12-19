// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/entities/response/news.dart';
import 'package:izowork/models/news_create_view_model.dart';
import 'package:izowork/views/back_button_widget.dart';
import 'package:izowork/views/border_button_widget.dart';
import 'package:izowork/views/button_widget.dart';
import 'package:izowork/components/loading_status.dart';
import 'package:izowork/components/titles.dart';
import 'package:izowork/views/checkbox_widget.dart';
import 'package:izowork/views/loading_indicator_widget.dart';
import 'package:izowork/views/label_input_widget.dart';
import 'package:provider/provider.dart';

class NewsCreateScreenBodyWidget extends StatefulWidget {
  final Function(News) onPop;

  const NewsCreateScreenBodyWidget({Key? key, required this.onPop})
      : super(key: key);

  @override
  _NewsCreateScreenBodyState createState() => _NewsCreateScreenBodyState();
}

class _NewsCreateScreenBodyState extends State<NewsCreateScreenBodyWidget> {
  final TextEditingController _titleTextEditingController =
      TextEditingController();
  final FocusNode _titleFocusNode = FocusNode();

  final TextEditingController _descriptionTextEditingController =
      TextEditingController();
  final FocusNode _focusNode = FocusNode();

  final List<Widget> _images = [];

  late NewsCreateViewModel _newsCreateViewModel;

  @override
  void dispose() {
    _titleTextEditingController.dispose();
    _titleFocusNode.dispose();
    _descriptionTextEditingController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _newsCreateViewModel = Provider.of<NewsCreateViewModel>(
      context,
      listen: true,
    );

    final TextStyle _style = TextStyle(
        color: HexColors.black, fontFamily: 'PT Root UI', fontSize: 16.0);

    if (_newsCreateViewModel.files.isNotEmpty &&
        _images.length != _newsCreateViewModel.files.length) {
      if (_newsCreateViewModel.files.isNotEmpty) {
        _images.clear();
        _newsCreateViewModel.files.forEach((element) {
          _images.add(Image.file(File(element.path),
              width: MediaQuery.of(context).size.width - 32.0,
              height: 180.0,
              fit: BoxFit.cover));
        });
      }
    }

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
          GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: ListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.only(
                      left: 16.0,
                      right: 16.0,
                      top: 16.0,
                      bottom: MediaQuery.of(context).padding.bottom == 0.0
                          ? 100.0
                          : MediaQuery.of(context).padding.bottom + 80.0),
                  children: [
                    /// SLIDESHOW
                    ClipRRect(
                        borderRadius: BorderRadius.circular(16.0),
                        child: _images.isEmpty
                            ? Container()
                            : ImageSlideshow(
                                width: MediaQuery.of(context).size.width - 32.0,
                                height: 180.0,
                                children: _images,
                                initialPage: 0,
                                indicatorColor: HexColors.white,
                                indicatorBackgroundColor: HexColors.grey40,
                                indicatorRadius:
                                    _images.length == 1 ? 0.0 : 4.0,
                                autoPlayInterval: 6000,
                                isLoop: true)),
                    SizedBox(
                        height:
                            _newsCreateViewModel.files.isEmpty ? 0.0 : 16.0),

                    /// NAME INPUT
                    LabelInputWidget(
                        margin: const EdgeInsets.only(bottom: 16.0),
                        textEditingController: _titleTextEditingController,
                        focusNode: _titleFocusNode,
                        labelText:
                            Titles.title + ' ${Titles.news.toLowerCase()}'),

                    /// TEXT INPUT
                    Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 6.0),
                        height: 260.0,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(
                                width: 1.0, color: HexColors.grey20)),
                        child: TextField(
                            maxLines: null,
                            controller: _descriptionTextEditingController,
                            focusNode: _focusNode,
                            keyboardAppearance: Brightness.light,
                            cursorColor: HexColors.primaryDark,
                            textInputAction: TextInputAction.done,
                            textCapitalization: TextCapitalization.sentences,
                            style: _style,
                            decoration: InputDecoration(
                              labelText:
                                  Titles.text + ' ${Titles.news.toLowerCase()}',
                              labelStyle:
                                  _style.copyWith(color: HexColors.grey40),
                              contentPadding: EdgeInsets.only(
                                  top: _focusNode.hasFocus ? 8.0 : 10.0),
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                            ),
                            onChanged: (text) => {setState},
                            onEditingComplete: () =>
                                FocusScope.of(context).unfocus())),

                    /// CLIP IMAGE BUTTON
                    BorderButtonWidget(
                        title: _newsCreateViewModel.files.isEmpty
                            ? Titles.clipMedia
                            : Titles.addMedia,
                        margin: const EdgeInsets.only(top: 16.0),
                        onTap: () => _newsCreateViewModel.pickImage()),
                    const SizedBox(height: 16.0),

                    /// CHECKBOX
                    GestureDetector(
                      child: Row(children: [
                        CheckBoxWidget(
                            isSelected: _newsCreateViewModel.important),
                        const SizedBox(width: 8.0),
                        Text(Titles.importantNews,
                            style: TextStyle(
                                color: HexColors.black,
                                fontSize: 16.0,
                                fontFamily: 'PT Root UI'))
                      ]),
                      onTap: () => _newsCreateViewModel
                          .setInportant(!_newsCreateViewModel.important),
                    )
                  ])),

          /// ADD NEWS BUTTON
          Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).padding.bottom == 0.0
                          ? 20.0
                          : MediaQuery.of(context).padding.bottom),
                  child: ButtonWidget(
                      title: Titles.publicate,
                      isDisabled: _titleTextEditingController.text.isEmpty ||
                          _descriptionTextEditingController.text.isEmpty,
                      onTap: () => _newsCreateViewModel.createNewDeal(
                          context,
                          _titleTextEditingController.text,
                          _descriptionTextEditingController.text,
                          _newsCreateViewModel.important,
                          (news) =>
                              {widget.onPop(news), Navigator.pop(context)})))),

          /// INDICATOR
          _newsCreateViewModel.loadingStatus == LoadingStatus.searching
              ? const LoadingIndicatorWidget()
              : Container()
        ])));
  }
}
