// import 'package:chips_choice/chips_choice.dart';
// import 'package:flutter/material.dart';
// import 'package:izowork/components/hex_colors.dart';
// import 'package:izowork/components/titles.dart';
// import 'package:izowork/models/chat_filter_view_model.dart';
// import 'package:izowork/views/button_widget.dart';
// import 'package:izowork/views/selection_input_widget.dart';
// import 'package:izowork/views/title_widget.dart';
// import 'package:izowork/views/transparent_button_widget_widget.dart';
// import 'package:provider/provider.dart';

// class ChatFilterScreenBodyWidget extends StatefulWidget {
//   final VoidCallback onEmployeeTap;
//   final VoidCallback onApplyTap;
//   final VoidCallback onResetTap;

//   const ChatFilterScreenBodyWidget(
//       {Key? key,
//       required this.onEmployeeTap,
//       required this.onApplyTap,
//       required this.onResetTap})
//       : super(key: key);

//   @override
//   _ChatFilterScreenBodyState createState() => _ChatFilterScreenBodyState();
// }

// class _ChatFilterScreenBodyState extends State<ChatFilterScreenBodyWidget> {
//   late ChatFilterViewModel _chatFilterViewModel;

//   final options = [
//     'Все',
//     'Прочитанные',
//     'Непрочитанные',
//   ];
//   List<int> tags = [];

//   final options2 = [
//     'Сначала новые',
//     'Сначала старые',
//   ];
//   List<int> tags2 = [];

//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     _chatFilterViewModel =
//         Provider.of<ChatFilterViewModel>(context, listen: true);

//     return Material(
//         type: MaterialType.transparency,
//         child: Container(
//             color: HexColors.white,
//             child: ListView(
//                 physics: const NeverScrollableScrollPhysics(),
//                 shrinkWrap: true,
//                 padding: const EdgeInsets.only(top: 8.0),
//                 children: [
//                   /// TITLE
//                   const TitleWidget(text: Titles.filter),
//                   const SizedBox(height: 17.0),

//                   /// SCROLLABLE LIST
//                   ListView(
//                       shrinkWrap: true,
//                       padding: EdgeInsets.only(
//                           bottom: MediaQuery.of(context).padding.bottom == 0.0
//                               ? 12.0
//                               : MediaQuery.of(context).padding.bottom),
//                       children: [
//                         /// EMPLOYEE SELECTION INPUT
//                         SelectionInputWidget(
//                             title: Titles.employee,
//                             value: 'Имя Фамилия',
//                             onTap: () => widget.onEmployeeTap()),

//                         const SizedBox(height: 16.0),
//                         const TitleWidget(text: Titles.status, isSmall: true),
//                         const SizedBox(height: 10.0),

//                         /// STATUS GRID VIEW
//                         ChipsChoice<String>.multiple(
//                             padding:
//                                 const EdgeInsets.symmetric(horizontal: 16.0),
//                             wrapped: true,
//                             spacing: 6.0,
//                             runSpacing: 6.0,
//                             value: options,
//                             choiceBuilder: (item, index) => InkWell(
//                                   onTap: () => setState(
//                                       () => {tags.clear(), tags.add(index)}),
//                                   child: Container(
//                                       padding: const EdgeInsets.symmetric(
//                                           horizontal: 10.0, vertical: 4.0),
//                                       decoration: BoxDecoration(
//                                           color: tags.contains(index)
//                                               ? HexColors.additionalViolet
//                                               : HexColors.grey10,
//                                           borderRadius: const BorderRadius.all(
//                                             Radius.circular(18.0),
//                                           )),
//                                       child: Text(options[index],
//                                           style: TextStyle(
//                                               fontSize: 14.0,
//                                               fontWeight: tags.contains(index)
//                                                   ? FontWeight.w500
//                                                   : FontWeight.w400,
//                                               color: tags.contains(index)
//                                                   ? HexColors.white
//                                                   : HexColors.black,
//                                               fontFamily: 'PT Root UI'))),
//                                 ),
//                             onChanged: (val) => {},
//                             choiceItems: C2Choice.listFrom<String, String>(
//                               source: options,
//                               value: (i, v) => v,
//                               label: (i, v) => v,
//                             )),

//                         const SizedBox(height: 17.0),
//                         const TitleWidget(text: Titles.sorting, isSmall: true),
//                         const SizedBox(height: 10.0),

//                         /// SORTING GRID VIEW
//                         ChipsChoice<String>.multiple(
//                             padding:
//                                 const EdgeInsets.symmetric(horizontal: 16.0),
//                             wrapped: true,
//                             spacing: 6.0,
//                             runSpacing: 6.0,
//                             value: options2,
//                             choiceBuilder: (item, index) => InkWell(
//                                   onTap: () => setState(
//                                       () => {tags2.clear(), tags2.add(index)}),
//                                   child: Container(
//                                       padding: const EdgeInsets.symmetric(
//                                           horizontal: 10.0, vertical: 4.0),
//                                       decoration: BoxDecoration(
//                                           color: tags2.contains(index)
//                                               ? HexColors.additionalViolet
//                                               : HexColors.grey10,
//                                           borderRadius: const BorderRadius.all(
//                                             Radius.circular(18.0),
//                                           )),
//                                       child: Text(options2[index],
//                                           style: TextStyle(
//                                               fontSize: 14.0,
//                                               fontWeight: tags2.contains(index)
//                                                   ? FontWeight.w500
//                                                   : FontWeight.w400,
//                                               color: tags2.contains(index)
//                                                   ? HexColors.white
//                                                   : HexColors.black,
//                                               fontFamily: 'PT Root UI'))),
//                                 ),
//                             onChanged: (val) => {},
//                             choiceItems: C2Choice.listFrom<String, String>(
//                               source: options2,
//                               value: (i, v) => v,
//                               label: (i, v) => v,
//                             ))
//                       ]),

//                   /// BUTTON's
//                   Row(children: [
//                     /// APPLY
//                     Expanded(
//                         child: ButtonWidget(
//                             title: Titles.apply,
//                             margin:
//                                 const EdgeInsets.only(left: 16.0, right: 5.0),
//                             onTap: () => widget.onApplyTap())),

//                     /// RESET
//                     Expanded(
//                         child: TransparentButtonWidget(
//                             title: Titles.reset,
//                             margin:
//                                 const EdgeInsets.only(left: 5.0, right: 16.0),
//                             onTap: () => {
//                                   setState(() {
//                                     tags.clear();
//                                     tags2.clear();
//                                   }),
//                                   widget.onResetTap()
//                                 }))
//                   ])
//                 ])));
//   }
// }
