import 'package:flutter/material.dart';
import 'package:izowork/entities/response/chat.dart';
import 'package:izowork/entities/response/message.dart';
import 'package:izowork/models/dialog_view_model.dart';
import 'package:izowork/screens/dialog/dialog_screen_body.dart';
import 'package:provider/provider.dart';

class DialogScreenWidget extends StatelessWidget {
  final Chat chat;
  final Function(Message)? onPop;

  const DialogScreenWidget({Key? key, required this.chat, this.onPop})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => DialogViewModel(chat),
        child: DialogScreenBodyWidget(onPop: onPop));
  }
}
