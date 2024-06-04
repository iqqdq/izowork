import 'package:flutter/material.dart';
import 'package:izowork/models/models.dart';
import 'package:izowork/notifiers/notifiers.dart';
import 'package:izowork/screens/participants/participants_screen_body.dart';
import 'package:provider/provider.dart';

class ParticipantsScreenWidget extends StatelessWidget {
  final Chat chat;

  const ParticipantsScreenWidget({Key? key, required this.chat})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => ParticipantsViewModel(chat),
        child: const ParticipantsScreenBodyWidget());
  }
}
