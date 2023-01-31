import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/loading_status.dart';
import 'package:izowork/components/titles.dart';
import 'package:izowork/components/toast.dart';
import 'package:izowork/entities/object.dart';
import 'package:izowork/entities/phase.dart';
import 'package:izowork/screens/dialog/dialog_screen.dart';
import 'package:izowork/screens/documents/documents_screen.dart';
import 'package:izowork/screens/object/comment_screen_body.dart';
import 'package:izowork/screens/object_analytics/object_analytics_page_view_screen.dart';
import 'package:izowork/screens/object_create/object_create_screen.dart';
import 'package:izowork/screens/phase/phase_screen.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ObjectViewModel with ChangeNotifier {
  // LoadingStatus loadingStatus = LoadingStatus.searching;
  LoadingStatus loadingStatus = LoadingStatus.empty;

  final List<String> _phases = [
    'Фундамент',
    'Стены',
    'Кровля',
    'Стяжка',
    'Перегородки',
    'Вентиляция',
    'Дымоудаление',
    'Водопровод',
    'Отопление',
    'Тепловые узлы'
  ];

  List<String> get phases {
    return _phases;
  }

  // MARK: -
  // MARK: - ACTIONS

  void copyCoordinates(BuildContext context) {
    Clipboard.setData(const ClipboardData(text: '49.359212, 55.230101'))
        .then((value) => Toast().showTopToast(context, Titles.didCopied));
  }

  // MARK: -
  // MARK: - PUSH

  void showObjectCreateScreenSheet(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ObjectCreateScreenWidget(object: Object())));
  }

  void showDialogScreen(BuildContext context) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const DialogScreenWidget()));
  }

  void showObjectAnalyticsPageViewScreen(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                const ObjectAnalyticsPageViewScreenBodyWidget()));
  }

  void showDocumentsScreen(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DocumentsScreenWidget(object: Object())));
  }

  void showPhaseScreen(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PhaseScreenWidget(phase: Phase())));
  }

  void showCommentScreen(BuildContext context) {
    showCupertinoModalBottomSheet(
        topRadius: const Radius.circular(16.0),
        barrierColor: Colors.black.withOpacity(0.6),
        backgroundColor: HexColors.white,
        context: context,
        builder: (context) => CommentScreenBodyWidget(onTap: (comment) => {}));
  }
}
