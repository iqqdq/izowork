import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/models/deal_process_view_model.dart';
import 'package:izowork/screens/deal_process/views/deal_process_info_list_item_widget.dart';
import 'package:izowork/views/back_button_widget.dart';
import 'package:izowork/components/loading_status.dart';
import 'package:izowork/components/titles.dart';
import 'package:izowork/views/floating_button_widget.dart';
import 'package:izowork/views/loading_indicator_widget.dart';
import 'package:izowork/views/separator_widget.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:provider/provider.dart';

class DealProcessScreenBodyWidget extends StatefulWidget {
  const DealProcessScreenBodyWidget({Key? key}) : super(key: key);

  @override
  _DealProcessScreenBodyState createState() => _DealProcessScreenBodyState();
}

class _DealProcessScreenBodyState extends State<DealProcessScreenBodyWidget> {
  final ScrollController _scrollController = ScrollController();

  late DealProcessViewModel _dealProcessViewModel;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _dealProcessViewModel
            .getDealProcessInformation(_dealProcessViewModel.dealProcess.id);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // MARK: -
  // MARK: - FUNCTIONS

  Future _onRefresh() async {
    _dealProcessViewModel
        .getDealProcessInformation(_dealProcessViewModel.dealProcess.id);
  }

  @override
  Widget build(BuildContext context) {
    _dealProcessViewModel =
        Provider.of<DealProcessViewModel>(context, listen: true);

    return Scaffold(
        backgroundColor: HexColors.white,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
            centerTitle: true,
            elevation: 0.0,
            systemOverlayStyle: SystemUiOverlayStyle.dark,
            backgroundColor: Colors.transparent,
            leading: Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: BackButtonWidget(onTap: () => Navigator.pop(context))),
            title: Text(_dealProcessViewModel.dealProcess.name,
                style: TextStyle(
                    overflow: TextOverflow.ellipsis,
                    fontFamily: 'PT Root UI',
                    fontSize: 18.0,
                    fontWeight: FontWeight.w700,
                    color: HexColors.black))),
        floatingActionButton: FloatingButtonWidget(
            onTap: () =>
                _dealProcessViewModel.showDealProcessInfoSheet(context)),
        body: SizedBox.expand(
            child: Stack(children: [
          /// TASKS LIST VIEW
          LiquidPullToRefresh(
              color: HexColors.primaryMain,
              backgroundColor: HexColors.white,
              springAnimationDurationInMilliseconds: 300,
              onRefresh: _onRefresh,
              child: ListView.builder(
                  controller: _scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.only(
                      left: 16.0,
                      right: 16.0,
                      top: 16.0,
                      bottom: 80.0 + MediaQuery.of(context).padding.bottom),
                  itemCount: _dealProcessViewModel.informations.length,
                  itemBuilder: (context, index) {
                    return DealProcessInfoListItemWidget(
                        information: _dealProcessViewModel.informations[index],
                        onUserTap: () => _dealProcessViewModel
                            .showProfileScreen(context, index),
                        onFileTap: (fileIndex) => _dealProcessViewModel
                            .openFile(context, index, fileIndex));
                  })),
          const SeparatorWidget(),

          /// EMPTY LIST TEXT
          _dealProcessViewModel.loadingStatus == LoadingStatus.completed &&
                  _dealProcessViewModel.informations.isEmpty
              ? Center(
                  child: Padding(
                      padding: const EdgeInsets.only(
                          left: 20.0, right: 20.0, bottom: 100.0),
                      child: Text(Titles.noResult,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 16.0,
                              color: HexColors.grey50))))
              : Container(),

          /// INDICATOR
          _dealProcessViewModel.loadingStatus == LoadingStatus.searching
              ? const LoadingIndicatorWidget()
              : Container()
        ])));
  }
}
