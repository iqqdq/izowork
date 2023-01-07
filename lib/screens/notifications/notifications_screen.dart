import 'package:flutter/material.dart';
import 'package:izowork/models/notifications_view_model.dart';
import 'package:izowork/screens/notifications/notifications_screen_body.dart';
import 'package:provider/provider.dart';

class NotificationsScreenWidget extends StatelessWidget {
  const NotificationsScreenWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => NotificationsViewModel(),
        child: const NotificationsScreenBodyWidget());
  }
}
