// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
//  import 'package:izowork/components/components.dart';
//
// import 'package:izowork/views/views.dart';
// import 'package:izowork/views/button_widget.dart';
// import 'package:izowork/views/views.dart';
// import 'package:izowork/views/file_list_widget.dart';
// import 'package:izowork/views/input_widget.dart';
// import 'package:izowork/views/views.dart';

// class DealProcessEditSheetWidget extends StatefulWidget {
//   final Function(String, List<PlatformFile>) onTap;

//   const DealProcessEditSheetWidget({Key? key, required this.onTap})
//       : super(key: key);

//   @override
//   _DealProcessEditSheetState createState() => _DealProcessEditSheetState();
// }

// class _DealProcessEditSheetState extends State<DealProcessEditSheetWidget> {
//   final TextEditingController _textEditingController = TextEditingController();
//   final FocusNode _focusNode = FocusNode();
//   final List<PlatformFile> _files = [];

//   @override
//   void dispose() {
//     _textEditingController.dispose();
//     _focusNode.dispose();
//     super.dispose();
//   }

//   Future _addFile() async {
//     FilePickerResult? result = await FilePicker.platform.pickFiles(
//         type: FileType.custom,
//         allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf', 'doc'],);

//     if (result != null) {
//       for (var file in result.files) {
//         _files.add(file);
//       }
//     }
//   }

//   void _removeFile(int index) {
//     setState(() => _files.removeAt(index));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Material(
//         type: MaterialType.transparency,
//         child: Container(
//             color: HexColors.white,
//             child: ListView(
//                 shrinkWrap: true,
//                 padding: EdgeInsets.only(
//                     top: 8.0,
//                     left: 16.0,
//                     right: 16.0,
//                     bottom: MediaQuery.of(context).padding.bottom == 0.0
//                         ? 20.0
//                         : MediaQuery.of(context).padding.bottom),
//                 children: [
//                   /// DISMISS INDICATOR
//                   const SizedBox(height: 6.0),
//                   const DismissIndicatorWidget(),

//                   /// TITLE
//                   const TitleWidget(
//                       text: Titles.process, padding: EdgeInsets.zero),
//                   const SizedBox(height: 16.0),

//                   /// REASON INPUT
//                   InputWidget(
//                     textEditingController: _textEditingController,
//                     focusNode: _focusNode,
//                     height: 168.0,
//                     maxLines: 10,
//                     margin: EdgeInsets.zero,
//                     placeholder: '${Titles.reason}...',
//                     onTap: () => setState,
//                     onChange: (text) => {
//                       // TODO DESCRTIPTION
//                     },
//                   ),
//                   const SizedBox(height: 16.0),

//                   /// FILE LIST
//                   ListView.builder(
//                       padding: EdgeInsets.zero,
//                       physics: const NeverScrollableScrollPhysics(),
//                       shrinkWrap: true,
//                       itemCount: _files.length,
//                       itemBuilder: (context, index) {
//                         return FileListItemWidget(
//                           key: ValueKey(_files[index].name),
//                           fileName: _files[index].name,
//                           onRemoveTap: () => _removeFile(index),
//                         );
//                       }),
//                   BorderButtonWidget(
//                       margin: EdgeInsets.zero,
//                       title: Titles.addFile,
//                       onTap: () => _addFile()),
//                   ButtonWidget(
//                       margin: const EdgeInsets.only(top: 16.0),
//                       title: Titles.closeDeal,
//                       isDisabled: _textEditingController.text.isEmpty,
//                       onTap: () =>
//                           widget.onTap(_textEditingController.text, _files))
//                 ])));
//   }
// }
