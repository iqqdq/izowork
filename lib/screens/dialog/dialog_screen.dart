import 'package:flutter/material.dart';
import 'package:izowork/models/models.dart';
import 'package:izowork/notifiers/notifiers.dart';
import 'package:izowork/screens/dialog/dialog_screen_body.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart';

class DialogScreenWidget extends StatelessWidget {
  final String id;
  final Socket? socket;
  final Function(Message)? onPop;

  const DialogScreenWidget({
    Key? key,
    required this.id,
    this.socket,
    this.onPop,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => DialogViewModel(
              id,
              socket,
            ),
        child: DialogScreenBodyWidget(onPop: onPop));
  }
}
