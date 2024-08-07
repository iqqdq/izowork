import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:izowork/components/components.dart';
import 'package:izowork/features/notifications/view_model/notifications_view_model.dart';
import 'package:izowork/models/models.dart';

import 'package:izowork/repositories/repositories.dart';
import 'package:izowork/features/deal/view/deal_screen.dart';
import 'package:izowork/features/dialog/view/dialog_screen.dart';
import 'package:izowork/features/news_page/view/news_page_screen.dart';
import 'package:izowork/features/notifications/view/views/notification_list_item_widget.dart';
import 'package:izowork/features/object/view/object_page_view_screen.dart';
import 'package:izowork/features/task/view/task_screen.dart';
import 'package:izowork/views/views.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:provider/provider.dart';

class NotificationsScreenBodyWidget extends StatefulWidget {
  final VoidCallback onPop;

  const NotificationsScreenBodyWidget({
    Key? key,
    required this.onPop,
  }) : super(key: key);

  @override
  _NotificationsScreenBodyState createState() =>
      _NotificationsScreenBodyState();
}

class _NotificationsScreenBodyState
    extends State<NotificationsScreenBodyWidget> {
  final ScrollController _scrollController = ScrollController();
  final Pagination _pagination = Pagination();

  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  late NotificationsViewModel _notificationsViewModel;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _pagination.increase();
        _notificationsViewModel.getNotificationList(pagination: _pagination);
      }
    });
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _focusNode.dispose();

    widget.onPop();

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
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          title: Stack(children: [
            BackButtonWidget(onTap: () => {Navigator.pop(context)}),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(
                Titles.notifications,
                style: TextStyle(
                  color: HexColors.black,
                  fontSize: 18.0,
                  fontFamily: 'PT Root UI',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ])
          ])),
      body: SizedBox.expand(
        child: Stack(children: [
          /// NOTIFICATIONS LIST VIEW
          LiquidPullToRefresh(
            color: HexColors.primaryMain,
            backgroundColor: HexColors.white,
            springAnimationDurationInMilliseconds: 300,
            onRefresh: _onRefresh,
            child: ListView.builder(
                controller: _scrollController,
                padding: EdgeInsets.only(
                  left: 16.0,
                  right: 16.0,
                  top: 16.0,
                  bottom: MediaQuery.of(context).padding.bottom == 0.0
                      ? 12.0
                      : MediaQuery.of(context).padding.bottom,
                ),
                itemCount: _notificationsViewModel.notifications.length,
                itemBuilder: (context, index) {
                  var notification =
                      _notificationsViewModel.notifications[index];

                  return NotificationListItemWidget(
                    key: ValueKey(notification.id),
                    dateTime: notification.createdAt.toUtc().toLocal(),
                    isUnread: !notification.read,
                    text: notification.text,
                    onTap: () => _onNotificationTap(notification),
                  );
                }),
          ),
          const SeparatorWidget(),

          /// EMPTY LIST TEXT
          _notificationsViewModel.loadingStatus == LoadingStatus.completed &&
                  _notificationsViewModel.notifications.isEmpty
              ? const NoResultTitle()
              : Container(),

          /// INDICATOR
          _notificationsViewModel.loadingStatus == LoadingStatus.searching
              ? const LoadingIndicatorWidget()
              : Container()
        ]),
      ),
    );
  }

  // MARK: -
  // MARK: - FUNCTIONS

  Future _onRefresh() async {
    _pagination.reset();
    await _notificationsViewModel.getNotificationList(pagination: _pagination);
  }

  // MARK: -
  // MARK: - PUSH

  void _onNotificationTap(NotificationEntity notification) async {
    await _notificationsViewModel.readNotification(notification);

    Widget? screen;
    final metadata = notification.metadata;

    if (metadata.objectId != null) {
      if (metadata.phaseId != null) {
        screen = ObjectPageViewScreenWidget(
          id: metadata.objectId!,
          phaseId: metadata.phaseId,
          onPop: (object) {},
        );
      } else {
        screen = ObjectPageViewScreenWidget(
          id: metadata.objectId!,
          onPop: (object) {},
        );
      }
    } else if (metadata.dealId != null) {
      screen = DealScreenWidget(id: metadata.dealId!);
    } else if (metadata.taskId != null) {
      screen = TaskScreenWidget(id: metadata.taskId!);
    } else if (metadata.chatId != null) {
      screen = DialogScreenWidget(id: metadata.chatId!);
    } else if (metadata.newsId != null) {
      screen = NewsPageScreenWidget(id: metadata.newsId!);
    }

    if (screen == null) return;
    Navigator.push(context, MaterialPageRoute(builder: (context) => screen!));
  }
}
