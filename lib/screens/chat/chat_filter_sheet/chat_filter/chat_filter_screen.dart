import 'package:flutter/material.dart';
import 'package:izowork/models/chat_filter_view_model.dart';
import 'package:izowork/screens/chat/chat_filter_sheet/chat_filter/chat_filter_screen_body.dart';
import 'package:provider/provider.dart';

class ChatFilterScreenWidget extends StatelessWidget {
  final VoidCallback onEmployeeTap;
  final VoidCallback onApplyTap;
  final VoidCallback onResetTap;

  const ChatFilterScreenWidget(
      {Key? key,
      required this.onEmployeeTap,
      required this.onApplyTap,
      required this.onResetTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => ChatFilterViewModel(),
        child: ChatFilterScreenBodyWidget(
            onEmployeeTap: onEmployeeTap,
            onApplyTap: onApplyTap,
            onResetTap: onResetTap));
  }
}
