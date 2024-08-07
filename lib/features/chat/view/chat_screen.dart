import 'package:flutter/material.dart';
import 'package:izowork/features/chat/view_model/chat_view_model.dart';
import 'package:izowork/features/chat/view/chat_screen_body.dart';
import 'package:provider/provider.dart';

class ChatScreenWidget extends StatelessWidget {
  const ChatScreenWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ChatViewModel(),
      child: const ChatScreenBodyWidget(),
    );
  }
}
