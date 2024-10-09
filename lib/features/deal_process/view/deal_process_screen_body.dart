// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:izowork/components/components.dart';

import 'package:izowork/features/deal/view/sheets/deal_process_info_sheet.dart';
import 'package:izowork/features/deal_process/view_model/deal_process_view_model.dart';
import 'package:izowork/features/deal_process/view/views/deal_process_info_list_item_widget.dart';
import 'package:izowork/features/profile/view/profile_screen.dart';
import 'package:izowork/views/views.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
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

  @override
  Widget build(BuildContext context) {
    _dealProcessViewModel = Provider.of<DealProcessViewModel>(
      context,
      listen: true,
    );

    return Scaffold(
      backgroundColor: HexColors.white,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
          centerTitle: true,
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
      floatingActionButton:
          FloatingButtonWidget(onTap: () => _showDealProcessInfoSheet()),
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
                  bottom: 80.0 + MediaQuery.of(context).padding.bottom,
                ),
                itemCount: _dealProcessViewModel.informations.length,
                itemBuilder: (context, index) {
                  final information = _dealProcessViewModel.informations[index];

                  return DealProcessInfoListItemWidget(
                    key: ValueKey(information.id),
                    information: information,
                    onUserTap: () => _showProfileScreen(index),
                    onFileTap: (fileIndex) => _dealProcessViewModel.openFile(
                      index,
                      fileIndex,
                    ),
                  );
                }),
          ),
          const SeparatorWidget(),

          /// EMPTY LIST TEXT
          _dealProcessViewModel.loadingStatus == LoadingStatus.completed &&
                  _dealProcessViewModel.informations.isEmpty
              ? const NoResultTitle()
              : Container(),

          /// INDICATOR
          _dealProcessViewModel.loadingStatus == LoadingStatus.searching
              ? const LoadingIndicatorWidget()
              : Container()
        ]),
      ),
    );
  }

  // MARK: -
  // MARK: - FUNCTIONS

  Future _onRefresh() async {
    await _dealProcessViewModel
        .getDealProcessInformation(_dealProcessViewModel.dealProcess.id);
  }

  // MARK: -
  // MARK: - PUSH

  void _showDealProcessInfoSheet() => showCupertinoModalBottomSheet(
        enableDrag: false,
        topRadius: const Radius.circular(16.0),
        barrierColor: Colors.black.withValues(alpha: 0.6),
        backgroundColor: HexColors.white,
        context: context,
        builder: (sheetContext) => DealProcessInfoSheetWidget(
            onTap: (text, files) => {
                  // CREATE PROCESS INFO
                  _dealProcessViewModel
                      .createDealProcessInformation(
                    _dealProcessViewModel.dealProcess.id,
                    text,
                  )
                      .whenComplete(() {
                    if (_dealProcessViewModel.information != null) if (files
                        .isEmpty) {
                      Toast().showTopToast(Titles.infoWasAdded);
                    } else {
                      _dealProcessViewModel.uploadDealProccessInfoFiles(
                        _dealProcessViewModel.information!.id,
                        files,
                      );
                    }
                  })
                }),
      );

  void _showProfileScreen(int index) {
    if (_dealProcessViewModel.informations[index].user == null) return;

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ProfileScreenWidget(
                  isMine: false,
                  user: _dealProcessViewModel.informations[index].user!,
                  onPop: (user) => null,
                )));
  }
}
