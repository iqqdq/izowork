// import 'package:flutter/material.dart';
//
// import 'package:izowork/screens/chat/chat_filter_sheet/chat_filter/chat_filter_screen.dart';
// import 'package:izowork/screens/search_user/search_user_screen.dart';
// import 'package:izowork/views/views.dart';

// class ChatFilterPageViewWidget extends StatefulWidget {
//   final VoidCallback onApplyTap;
//   final VoidCallback onResetTap;

//   const ChatFilterPageViewWidget(
//       {Key? key, required this.onApplyTap, required this.onResetTap})
//       : super(key: key);

//   @override
//   _ChatFilterPageViewState createState() => _ChatFilterPageViewState();
// }

// class _ChatFilterPageViewState extends State<ChatFilterPageViewWidget> {
//   final PageController _pageController = PageController();
//   List<Widget> _pages = [];
//   bool _isSearching = false;

//   @override
//   void initState() {
//     _pages = [
//       ChatFilterScreenWidget(
//           onEmployeeTap: () => {
//                 setState(
//                   () => _isSearching = true,
//                 ),
//                 _pages.add(SearchUserScreenWidget(
//                     isRoot: false,
//                     title: Titles.employee,
//                     onFocus: () => {},
//                     onPop: (user) => {
//                           setState(() => _isSearching = false),
//                           _pageController
//                               .animateToPage(0,
//                                   duration: const Duration(milliseconds: 300),
//                                   curve: Curves.easeIn)
//                               .then(
//                                   (value) => {if (mounted) _pages.removeLast()})
//                         })),
//                 Future.delayed(
//                     const Duration(milliseconds: 100),
//                     () => _pageController.animateToPage(1,
//                         duration: const Duration(milliseconds: 300),
//                         curve: Curves.easeIn))
//               },
//           onApplyTap: widget.onApplyTap,
//           onResetTap: widget.onResetTap),
//     ];

//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Material(
//         type: MaterialType.transparency,
//         child: ListView(
//             padding: EdgeInsets.zero,
//             physics: const NeverScrollableScrollPhysics(),
//             shrinkWrap: true,
//             children: [
//               Column(children: const [
//                 /// DISMISS INDICATOR
//                 SizedBox(height: 6.0),
//                 DismissIndicatorWidget(),
//               ]),
//               AnimatedContainer(
//                   duration: const Duration(milliseconds: 300),
//                   height: _isSearching
//                       ? MediaQuery.of(context).size.height * 0.7
//                       : MediaQuery.of(context).padding.bottom == 0.0
//                           ? 324.0
//                           : 344.0,
//                   child: PageView(
//                     controller: _pageController,
//                     physics: const NeverScrollableScrollPhysics(),
//                     children: _pages,
//                   ))
//             ]));
//   }
// }
