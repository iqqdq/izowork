import 'package:flutter/material.dart';
import 'package:izowork/models/chat_search_view_model.dart';
import 'package:izowork/screens/chat/chat_filter_sheet/chat_filter_search/chat_filter_search_screen_body.dart';
import 'package:provider/provider.dart';

class ChatFilterSearchScreenWidget extends StatelessWidget {
  final VoidCallback onPop;

  const ChatFilterSearchScreenWidget({Key? key, required this.onPop})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => ChatSearchViewModel(),
        child: ChatFilterSearchBodyScreenWidget(onPop: onPop));
  }
}
