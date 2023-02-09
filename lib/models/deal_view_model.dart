import 'package:flutter/material.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/loading_status.dart';
import 'package:izowork/entities/response/deal.dart';
import 'package:izowork/models/selection_view_model.dart';
import 'package:izowork/screens/deal/close_deal_sheet.dart';
import 'package:izowork/screens/deal/complete_deal_sheet.dart';
import 'package:izowork/screens/deal/edit_deal_process_sheet.dart';
import 'package:izowork/screens/deal/process_action_sheet.dart';
import 'package:izowork/screens/deal_create/deal_create_screen.dart';
import 'package:izowork/screens/selection/selection_screen.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class DealViewModel with ChangeNotifier {
  // LoadingStatus loadingStatus = LoadingStatus.searching;
  LoadingStatus loadingStatus = LoadingStatus.empty;

  final List<int> _expanded = [];

  List<int> get expanded {
    return _expanded;
  }

  // MARK: -
  // MARK: - ACTIONS

  void expand(int index) {
    if (_expanded.contains(index)) {
      _expanded.removeWhere((element) => element == index);
    } else {
      _expanded.add(index);
    }

    notifyListeners();
  }

  // MARK: -
  // MARK: - PUSH

  void showDealCreateScreenSheet(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DealCreateScreenWidget(deal: Deal())));
  }

  void showSelectionScreenSheet(BuildContext context) {
    showCupertinoModalBottomSheet(
        topRadius: const Radius.circular(16.0),
        barrierColor: Colors.black.withOpacity(0.6),
        backgroundColor: HexColors.white,
        context: context,
        builder: (context) => SelectionScreenWidget(
            selectionType: SelectionType.deal, onSelectTap: () => {}));
  }

  void showProcessActionScreenSheet(BuildContext context) {
    showCupertinoModalBottomSheet(
        topRadius: const Radius.circular(16.0),
        barrierColor: Colors.black.withOpacity(0.6),
        backgroundColor: HexColors.white,
        context: context,
        builder: (context) => ProcessActionSheet(
            title: 'Позиция',
            onTap: (index) => {
                  if (index == 0)
                    {
                      Future.delayed(const Duration(milliseconds: 200),
                          () => showEditDealProcessScreenSheet(context))
                    }
                }));
  }

  void showCompleteDealScreenSheet(BuildContext context) {
    showCupertinoModalBottomSheet(
        topRadius: const Radius.circular(16.0),
        barrierColor: Colors.black.withOpacity(0.6),
        backgroundColor: HexColors.white,
        context: context,
        builder: (context) =>
            CompleteDealSheetWidget(onTap: (text, files) => {}));
  }

  void showEditDealProcessScreenSheet(BuildContext context) {
    showCupertinoModalBottomSheet(
        topRadius: const Radius.circular(16.0),
        barrierColor: Colors.black.withOpacity(0.6),
        backgroundColor: HexColors.white,
        context: context,
        builder: (context) =>
            EditDealProcessSheetWidget(onTap: (text, files) => {}));
  }

  void showCloseDealScreenSheet(BuildContext context) {
    showCupertinoModalBottomSheet(
        topRadius: const Radius.circular(16.0),
        barrierColor: Colors.black.withOpacity(0.6),
        backgroundColor: HexColors.white,
        context: context,
        builder: (context) => CloseDealSheetWidget(onTap: (text, files) => {}));
  }
}
