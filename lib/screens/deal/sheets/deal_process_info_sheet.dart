// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/titles.dart';
import 'package:izowork/components/toast.dart';
import 'package:izowork/entities/response/deal_process_info.dart';
import 'package:izowork/services/urls.dart';
import 'package:izowork/views/border_button_widget.dart';
import 'package:izowork/views/button_widget_widget.dart';
import 'package:izowork/views/dismiss_indicator_widget.dart';
import 'package:izowork/views/file_list_widget.dart';
import 'package:izowork/views/input_widget.dart';
import 'package:izowork/views/title_widget.dart';
import 'package:open_filex/open_filex.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io' as io;
import 'package:path_provider/path_provider.dart';

class DealProcessInfoSheetWidget extends StatefulWidget {
  final Function(String, List<PlatformFile>) onTap;

  const DealProcessInfoSheetWidget({Key? key, required this.onTap})
      : super(key: key);

  @override
  _DealProcessInfoSheetState createState() => _DealProcessInfoSheetState();
}

class _DealProcessInfoSheetState extends State<DealProcessInfoSheetWidget> {
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final List<PlatformFile> _files = [];

  @override
  void dispose() {
    _textEditingController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future _addFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf', 'doc']);

    if (result != null) {
      for (var file in result.files) {
        setState(() => _files.add(file));
      }
    }
  }

  void _removeFile(int index) {
    setState(() => _files.removeAt(index));
  }

  Future _closeSheet() async {
    widget.onTap(_textEditingController.text, _files);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        type: MaterialType.transparency,
        child: Container(
            color: HexColors.white,
            child: ListView(
                shrinkWrap: true,
                padding: EdgeInsets.only(
                    top: 8.0,
                    left: 16.0,
                    right: 16.0,
                    bottom: MediaQuery.of(context).padding.bottom == 0.0
                        ? MediaQuery.of(context).viewInsets.bottom + 20.0
                        : MediaQuery.of(context).viewInsets.bottom +
                            MediaQuery.of(context).padding.bottom),
                children: [
                  /// DISMISS INDICATOR
                  const SizedBox(height: 6.0),
                  const DismissIndicatorWidget(),

                  /// TITLE
                  const TitleWidget(
                      text: Titles.sendInfo, padding: EdgeInsets.zero),
                  const SizedBox(height: 16.0),

                  /// DESCRIPTION INPUT
                  InputWidget(
                    textEditingController: _textEditingController,
                    focusNode: _focusNode,
                    height: 168.0,
                    maxLines: 10,
                    margin: EdgeInsets.zero,
                    placeholder: '${Titles.description}...',
                    onTap: () => setState,
                    onChange: (text) => setState(() {}),
                  ),
                  const SizedBox(height: 16.0),

                  /// FILE LIST

                  ListView.builder(
                      padding: EdgeInsets.zero,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: _files.length,
                      itemBuilder: (context, index) {
                        return FileListItemWidget(
                          fileName: _files[index].name,
                          onRemoveTap: () => _removeFile(index),
                        );
                      }),

                  BorderButtonWidget(
                      margin: EdgeInsets.zero,
                      title: Titles.addFile,
                      onTap: () => _addFile()),

                  ButtonWidget(
                      margin: const EdgeInsets.only(top: 16.0),
                      title: Titles.send,
                      isDisabled: _textEditingController.text.isEmpty,
                      onTap: () => _closeSheet())
                ])));
  }
}
