import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/locale.dart';
import 'package:izowork/models/deal_event_view_model.dart';
import 'package:izowork/screens/deals/views/deal_list_item_widget.dart';
import 'package:izowork/views/dismiss_indicator_widget.dart';
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

    final _day = widget.dateTime.day.toString().length == 1
        ? '0${widget.dateTime.day}'
        : '${widget.dateTime.day}';
    final _month =
        DateFormat.MMMM(locale).format(widget.dateTime).toLowerCase();
    final _year = '${widget.dateTime.year}';

    return SizedBox(
        height: MediaQuery.of(context).size.height * 0.8,
        child: Stack(children: [
          /// DEALS LIST VIEW
          SizedBox.expand(
              child: Scrollbar(
                  child: ListView.builder(
                      shrinkWrap: true,
                      padding: const EdgeInsets.only(
                          left: 16.0,
                          right: 16.0,
                          top: 70.0,
                          bottom: 16.0 + 48.0),
                      itemCount: _dealEventViewModel.deals.length,
                      itemBuilder: (context, index) {
                        return DealListItemWidget(
                            deal: _dealEventViewModel.deals[index],
                            onTap: () => _dealEventViewModel
                                .showDealScreenWidget(context, index));
                      }))),

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
                        'Сделки на $_day ${_month.substring(0, 3)} $_year',
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
        ]));
  }
}
