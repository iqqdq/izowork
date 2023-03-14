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

class DealProcessCompleteSheetWidget extends StatefulWidget {
  final String title;
  final DealProcessInfo? dealProcessInfo;
  final Function(String, List<PlatformFile>) onTap;

  const DealProcessCompleteSheetWidget(
      {Key? key,
      required this.title,
      this.dealProcessInfo,
      required this.onTap})
      : super(key: key);

  @override
  _DealProcessCompleteSheetState createState() =>
      _DealProcessCompleteSheetState();
}

class _DealProcessCompleteSheetState
    extends State<DealProcessCompleteSheetWidget> {
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final List<PlatformFile> _files = [];
  int _downloadIndex = -1;

  @override
  void initState() {
    if (widget.dealProcessInfo != null) {
      _textEditingController.text = widget.dealProcessInfo!.description;

      if (widget.dealProcessInfo!.files.isNotEmpty) {
        widget.dealProcessInfo!.files.forEach((element) {
          _files.add(PlatformFile(name: element.filename, size: 0));
        });
      }
    }

    super.initState();
  }

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

  Future _openFile(int index) async {
    String url = dealProcessInfoMediaUrl + _files[index].name;

    if (Platform.isAndroid) {
      Directory appDocumentsDirectory =
          await getApplicationDocumentsDirectory();
      String appDocumentsPath = appDocumentsDirectory.path;
      String fileName = _files[index].name;
      String filePath = '$appDocumentsPath/$fileName';
      bool isFileExists = await io.File(filePath).exists();

      if (!isFileExists) {
        setState(() => _downloadIndex = index);

        await Dio().download(url, filePath, onReceiveProgress: (count, total) {
          debugPrint('---Download----Rec: $count, Total: $total');
        }).then((value) => setState(() => _downloadIndex = -1));
      }

      OpenResult openResult = await OpenFilex.open(filePath);

      if (openResult.type == ResultType.noAppToOpen) {
        Toast().showTopToast(context, Titles.unsupportedFileFormat);
      }
    } else {
      if (await canLaunchUrl(Uri.parse(url.replaceAll(' ', '')))) {
        launchUrl(Uri.parse(url.replaceAll(' ', '')));
      } else if (await canLaunchUrl(
          Uri.parse('https://' + url.replaceAll(' ', '')))) {
        launchUrl(Uri.parse('https://' + url.replaceAll(' ', '')));
      }
    }
  }

  Future<List<PlatformFile>> _getNewFiles() async {
    List<PlatformFile> newFiles = [];
    bool found = false;

    if (widget.dealProcessInfo != null) {
      if (widget.dealProcessInfo!.files.isNotEmpty) {
        _files.forEach((file) {
          widget.dealProcessInfo!.files.forEach((processFile) {
            if (file.name == processFile.name) {
              found = true;
            }
          });

          if (found) {
            newFiles.add(file);
          }
        });
      }
    }

    return newFiles;
  }

  void _removeFile(int index) {
    setState(() => _files.removeAt(index));
  }

  Future _closeSheet() async {
    widget.onTap(_textEditingController.text, await _getNewFiles());
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
                  TitleWidget(text: widget.title, padding: EdgeInsets.zero),
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
                          isDownloading: _downloadIndex == index,
                          onTap: () => widget.dealProcessInfo == null
                              ? null
                              : _openFile(index),
                          onRemoveTap: widget.dealProcessInfo == null
                              ? () => _removeFile(index)
                              : null,
                        );
                      }),
                  BorderButtonWidget(
                      margin: EdgeInsets.zero,
                      title: Titles.addFile,
                      onTap: () => _addFile()),

                  Opacity(
                      opacity: widget.dealProcessInfo == null ? 1.0 : 0.5,
                      child: IgnorePointer(
                          ignoring: widget.dealProcessInfo != null,
                          child: ButtonWidget(
                              margin: const EdgeInsets.only(top: 16.0),
                              title: Titles.send,
                              isDisabled: _textEditingController.text.isEmpty,
                              onTap: () => _closeSheet())))
                ])));
  }
}
