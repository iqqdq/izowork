import 'package:flutter/material.dart';
import 'package:izowork/features/chat/view_model/chat_view_model.dart';
import 'package:izowork/features/chat/view/chats_screen_body.dart';
import 'package:provider/provider.dart';

class ChatsScreenWidget extends StatelessWidget {
  const ChatsScreenWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ChatsViewModel(),
      child: const ChatsScreenBodyWidget(),
    );
  }
}
