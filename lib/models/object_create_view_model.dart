import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/loading_status.dart';
import 'package:izowork/entities/object.dart';
import 'package:izowork/models/search_view_model.dart';
import 'package:izowork/models/selection_view_model.dart';
import 'package:izowork/screens/search/search_screen.dart';
import 'package:izowork/screens/selection/selection_screen.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ObjectCreateViewModel with ChangeNotifier {
  // INIT
  final Object? object;

  // LoadingStatus loadingStatus = LoadingStatus.searching;
  LoadingStatus loadingStatus = LoadingStatus.empty;

  bool _isKiso = false;
  bool _isCreateFolder = false;

  bool get isKiso {
    return _isKiso;
  }

  bool get isCreateFolder {
    return _isCreateFolder;
  }

  ObjectCreateViewModel(this.object);

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

  void checkKiso() {
    _isKiso = !_isKiso;
    notifyListeners();
  }

  void checkCreateFolder() {
    _isCreateFolder = !_isCreateFolder;
    notifyListeners();
  }

  // MARK: -
  // MARK: - PUSH

  void showSelectionScreenSheet(BuildContext context) {
    showCupertinoModalBottomSheet(
        topRadius: const Radius.circular(16.0),
        barrierColor: Colors.black.withOpacity(0.6),
        backgroundColor: HexColors.white,
        context: context,
        builder: (context) => SelectionScreenWidget(
            selectionType: SelectionType.object, onSelectTap: () => {}));
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
}
