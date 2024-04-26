import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/models/notifications_view_model.dart';
import 'package:izowork/screens/notifications/views/notification_list_item_widget.dart';
import 'package:izowork/views/back_button_widget.dart';
import 'package:izowork/components/loading_status.dart';
import 'package:izowork/components/titles.dart';
import 'package:izowork/views/loading_indicator_widget.dart';
import 'package:izowork/views/separator_widget.dart';
import 'package:provider/provider.dart';

class NotificationsScreenBodyWidget extends StatefulWidget {
  final Function(int) onPop;

  const NotificationsScreenBodyWidget({Key? key, required this.onPop})
      : super(key: key);

  @override
  _NotificationsScreenBodyState createState() =>
      _NotificationsScreenBodyState();
}

class _NotificationsScreenBodyState
    extends State<NotificationsScreenBodyWidget> {
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  late NotificationsViewModel _notificationsViewModel;

  @override
  void dispose() {
    _textEditingController.dispose();
    _focusNode.dispose();

    widget.onPop(_notificationsViewModel.getUnreadCount());

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _notificationsViewModel = Provider.of<NotificationsViewModel>(
      context,
      listen: true,
    );

    return Scaffold(
        backgroundColor: HexColors.white,
        appBar: AppBar(
            titleSpacing: 16.0,
            elevation: 0.0,
            systemOverlayStyle: SystemUiOverlayStyle.dark,
            backgroundColor: Colors.transparent,
            automaticallyImplyLeading: false,
            title: Stack(children: [
              BackButtonWidget(onTap: () => {Navigator.pop(context)}),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(Titles.notifications,
                    style: TextStyle(
                        color: HexColors.black,
                        fontSize: 18.0,
                        fontFamily: 'PT Root UI',
                        fontWeight: FontWeight.bold)),
              ])
            ])),
        body: SizedBox.expand(
            child: Stack(children: [
          /// NOTIFICATIONS LIST VIEW
          ListView.builder(
              padding: const EdgeInsets.only(
                left: 16.0,
                right: 16.0,
                top: 16.0,
                bottom: 16.0 + 48.0,
              ),
              itemCount: _notificationsViewModel.notifications.length,
              itemBuilder: (context, index) {
                return NotificationListItemWidget(
                  key:
                      ValueKey(_notificationsViewModel.notifications[index].id),
                  dateTime: _notificationsViewModel
                      .notifications[index].createdAt
                      .toUtc()
                      .toLocal(),
                  isUnread: !_notificationsViewModel.notifications[index].read,
                  text: _notificationsViewModel.notifications[index].text,
                  onTap: () => _notificationsViewModel.readNotification(
                    context,
                    false,
                    _notificationsViewModel.notifications[index],
                  ),
                );
              }),
          const SeparatorWidget(),

          /// EMPTY LIST TEXT
          _notificationsViewModel.loadingStatus == LoadingStatus.completed &&
                  _notificationsViewModel.notifications.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      Titles.noResult,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 16.0,
                        color: HexColors.grey50,
                      ),
                    ),
                  ),
                )
              : Container(),

          /// INDICATOR
          _notificationsViewModel.loadingStatus == LoadingStatus.searching
              ? const LoadingIndicatorWidget()
              : Container()
        ])));
  }
}
