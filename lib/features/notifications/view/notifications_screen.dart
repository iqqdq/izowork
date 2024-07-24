import 'package:flutter/material.dart';
import 'package:izowork/features/notifications/view_model/notifications_view_model.dart';

import 'package:izowork/features/notifications/view/notifications_screen_body.dart';
import 'package:provider/provider.dart';

class NotificationsScreenWidget extends StatelessWidget {
  final VoidCallback onPop;

  const NotificationsScreenWidget({
    Key? key,
    required this.onPop,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => NotificationsViewModel(),
      child: NotificationsScreenBodyWidget(onPop: onPop),
    );
  }
}
