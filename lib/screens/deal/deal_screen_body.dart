import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/titles.dart';
import 'package:izowork/entities/deal.dart';
import 'package:izowork/models/deal_view_model.dart';
import 'package:izowork/screens/deal/views/process_list_item_widget.dart';
import 'package:izowork/views/back_button_widget.dart';
import 'package:izowork/views/border_button_widget.dart';
import 'package:izowork/views/button_widget_widget.dart';
import 'package:izowork/views/file_list_widget.dart';
import 'package:izowork/views/subtitle_widget.dart';
import 'package:izowork/views/title_widget.dart';
import 'package:provider/provider.dart';
import 'package:spreadsheet_table/spreadsheet_table.dart';

class DealScreenBodyWidget extends StatefulWidget {
  final Deal deal;

  const DealScreenBodyWidget({Key? key, required this.deal}) : super(key: key);

  @override
  _DealScreenBodyState createState() => _DealScreenBodyState();
}

class _DealScreenBodyState extends State<DealScreenBodyWidget> {
  late DealViewModel _dealViewModel;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _dealViewModel = Provider.of<DealViewModel>(context, listen: true);

    final _startDay = DateTime.now().day.toString().length == 1
        ? '0${DateTime.now().day}'
        : '${DateTime.now().day}';
    final _startMonth = DateTime.now().month.toString().length == 1
        ? '0${DateTime.now().month}'
        : '${DateTime.now().month}';
    final _startYear = '${DateTime.now().year}';

    final _endDay = DateTime.now().day.toString().length == 1
        ? '0${DateTime.now().day}'
        : '${DateTime.now().day}';
    final _endMonth = DateTime.now().month.toString().length == 1
        ? '0${DateTime.now().month}'
        : '${DateTime.now().month}';
    final _endYear = '${DateTime.now().year}';

    return Scaffold(
        backgroundColor: HexColors.white,
        appBar: AppBar(
            centerTitle: true,
            elevation: 0.0,
            systemOverlayStyle: SystemUiOverlayStyle.dark,
            backgroundColor: Colors.transparent,
            leading: Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: BackButtonWidget(onTap: () => Navigator.pop(context))),
            title: Text('Название сделки',
                style: TextStyle(
                    overflow: TextOverflow.ellipsis,
                    fontFamily: 'PT Root UI',
                    fontSize: 18.0,
                    fontWeight: FontWeight.w700,
                    color: HexColors.black))),
        body: Material(
            type: MaterialType.transparency,
            child: Container(
                color: HexColors.white,
                child: ListView(
                    shrinkWrap: true,
                    padding: EdgeInsets.only(
                        top: 14.0,
                        bottom: MediaQuery.of(context).padding.bottom == 0.0
                            ? 20.0
                            : MediaQuery.of(context).padding.bottom),
                    children: [
                      /// START DATE
                      const TitleWidget(
                          padding: EdgeInsets.only(
                              left: 16.0, right: 16.0, bottom: 4.0),
                          text: Titles.startDate,
                          isSmall: true),
                      SubtitleWidget(
                          padding: const EdgeInsets.only(
                              left: 16.0, right: 16.0, bottom: 16.0),
                          text: '$_startDay.$_startMonth.$_startYear'),

                      /// END DATE
                      const TitleWidget(
                          padding: EdgeInsets.only(
                              left: 16.0, right: 16.0, bottom: 4.0),
                          text: Titles.endDate,
                          isSmall: true),
                      SubtitleWidget(
                          padding: const EdgeInsets.only(
                              left: 16.0, right: 16.0, bottom: 16.0),
                          text: '$_endDay.$_endMonth.$_endYear'),

                      /// RESPONSIBLE
                      const TitleWidget(
                          padding: EdgeInsets.only(
                              left: 16.0, right: 16.0, bottom: 4.0),
                          text: Titles.responsible,
                          isSmall: true),
                      const SubtitleWidget(
                          padding: EdgeInsets.only(
                              left: 16.0, right: 16.0, bottom: 16.0),
                          text: 'Имя Фамилия'),

                      /// OBJECT
                      const TitleWidget(
                          padding: EdgeInsets.only(
                              left: 16.0, right: 16.0, bottom: 4.0),
                          text: Titles.object,
                          isSmall: true),
                      const SubtitleWidget(
                          padding: EdgeInsets.only(
                              left: 16.0, right: 16.0, bottom: 16.0),
                          text: 'Название объекта'),

                      /// PHASE
                      const TitleWidget(
                          padding: EdgeInsets.only(
                              left: 16.0, right: 16.0, bottom: 4.0),
                          text: Titles.phase,
                          isSmall: true),
                      const SubtitleWidget(
                          padding: EdgeInsets.only(
                              left: 16.0, right: 16.0, bottom: 16.0),
                          text: 'Название этапа'),

                      /// COMPANY
                      const TitleWidget(
                          padding: EdgeInsets.only(
                              left: 16.0, right: 16.0, bottom: 4.0),
                          text: Titles.company,
                          isSmall: true),
                      const SubtitleWidget(
                          padding: EdgeInsets.only(
                              left: 16.0, right: 16.0, bottom: 16.0),
                          text: 'Название компании'),

                      /// СCOMMENT
                      const TitleWidget(
                          padding: EdgeInsets.only(
                              left: 16.0, right: 16.0, bottom: 4.0),
                          text: Titles.comment,
                          isSmall: true),
                      const SubtitleWidget(
                          padding: EdgeInsets.only(
                              left: 16.0, right: 16.0, bottom: 16.0),
                          text:
                              'Принимая во внимание показатели успешности, дальнейшее развитие различных форм деятельности влечет за собой процесс внедрения и модернизации форм воздействия.'),

                      /// TABLE
                      SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 36.0 * 4,
                          child: SpreadsheetTable(
                            cellBuilder: (_, int row, int col) => Container(
                                height: 36.0,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 2.0),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 0.65, color: HexColors.grey20)),
                                child: Center(
                                    child: Text('Кол-во',
                                        style: TextStyle(
                                            fontSize: 14.0,
                                            color: HexColors.black,
                                            fontFamily: 'PT Root UI')))),
                            legendBuilder: (_) => Container(
                                height: 36.0,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 0.65, color: HexColors.grey20)),
                                child: Row(children: [
                                  Text(Titles.product,
                                      style: TextStyle(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w500,
                                          color: HexColors.black,
                                          fontFamily: 'PT Root UI'))
                                ])),
                            rowHeaderBuilder: (_, index) => Container(
                                height: 36.0,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 0.65, color: HexColors.grey20)),
                                child: Center(
                                    child: Text('Название товара',
                                        style: TextStyle(
                                            fontSize: 14.0,
                                            color: HexColors.black,
                                            fontFamily: 'PT Root UI')))),
                            colHeaderBuilder: (_, index) => Container(
                                height: 36.0,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 2.0),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 0.65, color: HexColors.grey20)),
                                child: Center(
                                    child: Text('$index',
                                        style: TextStyle(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w500,
                                            color: HexColors.black,
                                            fontFamily: 'PT Root UI')))),
                            rowHeaderWidth: 144.0,
                            colsHeaderHeight: 36.0,
                            cellHeight: 36.0,
                            cellWidth: 84.0,
                            rowsCount: 3,
                            colCount: 10,
                          )),

                      /// FILE LIST
                      const TitleWidget(
                          padding: EdgeInsets.only(
                              top: 20.0, left: 16.0, right: 16.0, bottom: 10.0),
                          text: Titles.files,
                          isSmall: true),
                      ListView.builder(
                          shrinkWrap: true,
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: 3,
                          itemBuilder: (context, index) {
                            return const FileListItemWidget(
                                fileName: 'file.pdf');
                          }),

                      /// PROCESS LIST
                      const TitleWidget(
                          padding: EdgeInsets.only(
                              top: 16.0, left: 16.0, right: 16.0, bottom: 10.0),
                          text: Titles.processes,
                          isSmall: true),
                      ListView.builder(
                          shrinkWrap: true,
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: 2,
                          itemBuilder: (context, index) {
                            return ProcessListItemWidget(
                              isExpanded:
                                  _dealViewModel.expanded.contains(index),
                              isReady: index == 0,
                              onExpandTap: () => _dealViewModel.expand(index),
                              onMenuTap: (index) => _dealViewModel
                                  .showProcessActionScreenSheet(context),
                              onAddProcessTap: () => _dealViewModel
                                  .showSelectionScreenSheet(context),
                            );
                          }),

                      /// CLOSE DEAL BUTTON
                      BorderButtonWidget(
                          title: Titles.closeDeal,
                          margin: const EdgeInsets.only(
                              left: 16.0, top: 6.0, right: 16.0, bottom: 16.0),
                          onTap: () =>
                              _dealViewModel.showCloseDealScreenSheet(context)),

                      /// EDIT DEAL BUTTON
                      ButtonWidget(
                          title: Titles.edit,
                          margin: const EdgeInsets.symmetric(horizontal: 16.0),
                          onTap: () =>
                              _dealViewModel.showDealCreateScreenSheet(context))
                    ]))));
  }
}
