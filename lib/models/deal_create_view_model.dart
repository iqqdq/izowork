import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/loading_status.dart';
import 'package:izowork/components/locale.dart';
import 'package:izowork/components/titles.dart';
import 'package:izowork/entities/response/deal.dart';
import 'package:izowork/models/search_view_model.dart';
import 'package:izowork/models/selection_view_model.dart';
import 'package:izowork/screens/search/search_screen.dart';
import 'package:izowork/screens/selection/selection_screen.dart';
import 'package:izowork/views/date_time_wheel_picker_widget.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class DealCreateViewModel with ChangeNotifier {
  // INIT
  final Deal? deal;

  // LoadingStatus loadingStatus = LoadingStatus.searching;
  LoadingStatus loadingStatus = LoadingStatus.empty;

  final DateTime _minDateTime = DateTime(
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)
              .year -
          5,
      1,
      1);

  final DateTime _maxDateTime = DateTime(
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)
              .year +
          5,
      1,
      1);

  DateTime _pickedStartDateTime =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  DateTime _pickedEndDateTime =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  DateTime get minDateTime {
    return _minDateTime;
  }

  DateTime get maxDateTime {
    return _maxDateTime;
  }

  DateTime get pickedStartDateTime {
    return _pickedStartDateTime;
  }

  DateTime get pickedEndDateTime {
    return _pickedEndDateTime;
  }

  DealCreateViewModel(this.deal);

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

  void showSelectionScreenSheet(BuildContext context) {
    showCupertinoModalBottomSheet(
        topRadius: const Radius.circular(16.0),
        barrierColor: Colors.black.withOpacity(0.6),
        backgroundColor: HexColors.white,
        context: context,
        builder: (context) => SelectionScreenWidget(
            selectionType: SelectionType.task, onSelectTap: () => {}));
  }

  void showDateTimeSelectionSheet(BuildContext context, int index) {
    TextStyle textStyle = const TextStyle(
        overflow: TextOverflow.ellipsis, fontFamily: 'PT Root UI');

    showCupertinoModalBottomSheet(
        topRadius: const Radius.circular(16.0),
        barrierColor: Colors.black.withOpacity(0.6),
        backgroundColor: HexColors.white,
        enableDrag: false,
        context: context,
        builder: (context) => DateTimeWheelPickerWidget(
            minDateTime: _minDateTime,
            maxDateTime: _maxDateTime,
            initialDateTime:
                index == 0 ? _pickedStartDateTime : _pickedEndDateTime,
            showDays: true,
            locale: locale,
            backgroundColor: HexColors.white,
            buttonColor: HexColors.primaryMain,
            buttonHighlightColor: HexColors.primaryDark,
            buttonTitle: Titles.apply,
            buttonTextStyle: textStyle.copyWith(
                fontSize: 18.0,
                fontWeight: FontWeight.w700,
                color: HexColors.black),
            selecteTextStyle: textStyle.copyWith(
                fontSize: 14.0,
                color: HexColors.black,
                fontWeight: FontWeight.w400),
            unselectedTextStyle: textStyle.copyWith(
                fontSize: 12.0,
                color: HexColors.grey70,
                fontWeight: FontWeight.w400),
            onTap: (dateTime) => {
                  Navigator.pop(context),
                  index == 0
                      ? _pickedStartDateTime = dateTime
                      : _pickedEndDateTime = dateTime,
                  notifyListeners(),
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
}
