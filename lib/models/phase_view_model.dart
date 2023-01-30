import 'package:flutter/material.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/loading_status.dart';
import 'package:izowork/entities/deal.dart';
import 'package:izowork/entities/phase.dart';
import 'package:izowork/models/search_view_model.dart';
import 'package:izowork/screens/deal/deal_screen.dart';
import 'package:izowork/screens/deal_create/deal_create_screen.dart';
import 'package:izowork/screens/phase/complete_task_screen_body.dart';
import 'package:izowork/screens/phase_create/phase_create_screen.dart';
import 'package:izowork/screens/search/search_screen.dart';
import 'package:izowork/screens/task_create/task_create_screen.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class PhaseViewModel with ChangeNotifier {
  // INIT
  final Phase? phase;

  // LoadingStatus loadingStatus = LoadingStatus.searching;
  LoadingStatus loadingStatus = LoadingStatus.empty;

  PhaseViewModel(this.phase);

  // MARK: -
  // MARK: - ACTIONS

  // MARK: -
  // MARK: - PUSH

  void showDealScreenWidget(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DealScreenWidget(deal: Deal())));
  }

  void showCompleteTaskScreenSheet(BuildContext context) {
    showCupertinoModalBottomSheet(
        topRadius: const Radius.circular(16.0),
        barrierColor: Colors.black.withOpacity(0.6),
        backgroundColor: HexColors.white,
        context: context,
        builder: (context) =>
            CompleteTaskScreenBodyWidget(onTap: (text, files) => {}));
  }

  void showDealCreateScreen(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const DealCreateScreenWidget()));
  }

  void showTaskCreateScreen(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const TaskCreateScreenWidget()));
  }

  void showPhaseCreateScreen(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const PhaseCreateScreenWidget()));
  }
}
