import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/loading_status.dart';
import 'package:izowork/entities/response/phase.dart';
import 'package:izowork/models/search_view_model.dart';
import 'package:izowork/screens/search/search_screen.dart';
import 'package:izowork/screens/task_create/task_create_screen.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class PhaseCreateViewModel with ChangeNotifier {
  // INIT
  final Phase? phase;

  // LoadingStatus loadingStatus = LoadingStatus.searching;
  LoadingStatus loadingStatus = LoadingStatus.empty;

  PhaseCreateViewModel(this.phase);

  // MARK: -
  // MARK: - ACTIONS

  Future addFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf', 'doc']);

    if (result != null) {
      debugPrint(result.files.length.toString());
    }
  }

  void addProduct() {}

  // MARK: -
  // MARK: - PUSH

  void showProductSearchScreenSheet(BuildContext context, int index) {
    showCupertinoModalBottomSheet(
        topRadius: const Radius.circular(16.0),
        barrierColor: Colors.black.withOpacity(0.6),
        backgroundColor: HexColors.white,
        context: context,
        builder: (context) => SearchScreenWidget(
            isRoot: true,
            searchType: SearchType.product,
            onPop: () => {
                  // TODO SET PRODUCT
                }));
  }

  void showSearchScreenSheet(BuildContext context, SearchType searchType) {
    showCupertinoModalBottomSheet(
        topRadius: const Radius.circular(16.0),
        barrierColor: Colors.black.withOpacity(0.6),
        backgroundColor: HexColors.white,
        context: context,
        builder: (context) => SearchScreenWidget(
            isRoot: true,
            searchType: searchType,
            onPop: () => {
                  // TODO SET PRODUCT
                }));
  }

  void showTaskCreateScreen(BuildContext context) {
    // Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //         builder: (context) => const TaskCreateScreenWidget()));
  }
}
