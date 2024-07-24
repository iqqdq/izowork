import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:izowork/components/components.dart';
import 'package:izowork/models/responses/deal.dart';
import 'package:izowork/features/deal/view/deal_screen.dart';
import 'package:izowork/features/deals/view/views/deal_list_item_widget.dart';
import 'package:izowork/views/views.dart';

class DealEventScreenBodyWidget extends StatefulWidget {
  final DateTime dateTime;
  final List<Deal> deals;

  const DealEventScreenBodyWidget({
    Key? key,
    required this.dateTime,
    required this.deals,
  }) : super(key: key);

  @override
  _DealEventScreenBodyState createState() => _DealEventScreenBodyState();
}

class _DealEventScreenBodyState extends State<DealEventScreenBodyWidget> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _day = DateTime.now().day.toString().length == 1
        ? '0${DateTime.now().day}'
        : '${DateTime.now().day}';
    final _month = DateFormat.MMMM(Platform.localeName)
        .format(widget.dateTime)
        .toLowerCase();
    final _year = '${DateTime.now().year}';

    return Material(
      type: MaterialType.transparency,
      child: Container(
        height: MediaQuery.of(context).size.height,
        color: HexColors.white,
        child: Scrollbar(
          child: NotificationListener<ScrollEndNotification>(
            onNotification: (notification) {
              if (_scrollController.position.pixels == 0.0 &&
                  MediaQuery.of(context).viewInsets.bottom == 0.0) {
                Navigator.pop(context);
              }

              // Return true to cancel the notification bubbling. Return false (or null) to
              // allow the notification to continue to be dispatched to further ancestors.
              return true;
            },
            child: ListView(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: EdgeInsets.only(
                    top: 8.0,
                    left: 16.0,
                    right: 16.0,
                    bottom: (MediaQuery.of(context).padding.bottom == 0.0
                            ? 20.0
                            : MediaQuery.of(context).padding.bottom) +
                        MediaQuery.of(context).viewInsets.bottom),
                children: [
                  /// DISMISS INDICATOR
                  const SizedBox(height: 6.0),
                  const DismissIndicatorWidget(),

                  /// TITLE
                  Row(
                    children: [
                      Expanded(
                          child: Material(
                              type: MaterialType.transparency,
                              child: Text(
                                  'Сделки на $_day ${_month.substring(0, 3)} $_year',
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                      color: HexColors.black,
                                      fontFamily: 'PT Root UI'))))
                    ],
                  ),

                  /// TASK LIST VIEW
                  ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      padding: const EdgeInsets.only(top: 16.0),
                      itemCount: widget.deals.length,
                      itemBuilder: (context, index) {
                        final deal = widget.deals[index];

                        return DealListItemWidget(
                            key: ValueKey(deal.id),
                            deal: deal,
                            onTap: () => _showDealScreenWidget(index));
                      }),
                ]),
          ),
        ),
      ),
    );
  }

  void _showDealScreenWidget(int index) => Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => DealScreenWidget(id: widget.deals[index].id)));
}
