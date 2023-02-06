import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/loading_status.dart';
import 'package:izowork/components/locale.dart';
import 'package:izowork/entities/response/deal.dart';
import 'package:izowork/models/deal_event_view_model.dart';
import 'package:izowork/screens/actions/views/action_deal_list_item_widget.dart';
import 'package:izowork/views/dismiss_indicator_widget.dart';
import 'package:izowork/views/loading_indicator_widget.dart';
import 'package:provider/provider.dart';

class DealEventScreenBodyWidget extends StatefulWidget {
  final DateTime dateTime;

  const DealEventScreenBodyWidget({Key? key, required this.dateTime})
      : super(key: key);

  @override
  _DealEventScreenBodyState createState() => _DealEventScreenBodyState();
}

class _DealEventScreenBodyState extends State<DealEventScreenBodyWidget> {
  late DealEventViewModel _dealEventViewModel;

  @override
  Widget build(BuildContext context) {
    _dealEventViewModel =
        Provider.of<DealEventViewModel>(context, listen: true);

    final _day = DateTime.now().day.toString().length == 1
        ? '0${DateTime.now().day}'
        : '${DateTime.now().day}';
    final _month =
        DateFormat.MMMM(locale).format(widget.dateTime).toLowerCase();
    final _year = '${DateTime.now().year}';

    return SizedBox(
        height: MediaQuery.of(context).size.height * 0.8,
        child: Stack(children: [
          /// DEALS LIST VIEW
          Scrollbar(
              child: ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.only(
                      left: 16.0, right: 16.0, top: 70.0, bottom: 16.0 + 48.0),
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return ActionDealListItemWidget(
                        deal: Deal(),
                        onTap: () =>
                            _dealEventViewModel.showDealScreenWidget(context));
                  })),

          Container(
            width: double.infinity,
            height: 70.0,
            color: HexColors.white,
            child: Padding(
                padding: const EdgeInsets.only(
                    top: 24.0, bottom: 16.0, left: 16.0, right: 16.0),
                child: Material(
                    type: MaterialType.transparency,
                    child: Text(
                        'Задачи на $_day ${_month.substring(0, 3)} $_year',
                        style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: HexColors.black,
                            fontFamily: 'PT Root UI')))),
          ),

          Column(children: const [
            /// DISMISS INDICATOR
            SizedBox(height: 6.0),
            DismissIndicatorWidget(),
          ]),

          /// INDICATOR
          _dealEventViewModel.loadingStatus == LoadingStatus.searching
              ? const LoadingIndicatorWidget()
              : Container()
        ]));
  }
}