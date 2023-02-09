import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/titles.dart';
import 'package:izowork/entities/response/deal.dart';
import 'package:izowork/models/deal_create_view_model.dart';
import 'package:izowork/models/search_view_model.dart';
import 'package:izowork/screens/deal_create/views/deal_product_list_item_widget.dart';
import 'package:izowork/views/back_button_widget.dart';
import 'package:izowork/views/border_button_widget.dart';
import 'package:izowork/views/button_widget_widget.dart';
import 'package:izowork/views/file_list_widget.dart';
import 'package:izowork/views/input_widget.dart';
import 'package:izowork/views/selection_input_widget.dart';
import 'package:provider/provider.dart';

class DealCreateScreenBodyWidget extends StatefulWidget {
  final Deal? deal;

  const DealCreateScreenBodyWidget({Key? key, this.deal}) : super(key: key);

  @override
  _DealCreateScreenBodyState createState() => _DealCreateScreenBodyState();
}

class _DealCreateScreenBodyState extends State<DealCreateScreenBodyWidget> {
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  late DealCreateViewModel _dealCreateViewModel;

  @override
  void dispose() {
    _textEditingController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _dealCreateViewModel =
        Provider.of<DealCreateViewModel>(context, listen: true);

    final _startDay =
        _dealCreateViewModel.pickedStartDateTime.day.toString().length == 1
            ? '0${_dealCreateViewModel.pickedStartDateTime.day}'
            : '${_dealCreateViewModel.pickedStartDateTime.day}';
    final _startMonth =
        _dealCreateViewModel.pickedStartDateTime.month.toString().length == 1
            ? '0${_dealCreateViewModel.pickedStartDateTime.month}'
            : '${_dealCreateViewModel.pickedStartDateTime.month}';
    final _startYear = '${_dealCreateViewModel.pickedStartDateTime.year}';

    final _endDay =
        _dealCreateViewModel.pickedEndDateTime.day.toString().length == 1
            ? '0${_dealCreateViewModel.pickedEndDateTime.day}'
            : '${_dealCreateViewModel.pickedEndDateTime.day}';
    final _endMonth =
        _dealCreateViewModel.pickedEndDateTime.month.toString().length == 1
            ? '0${_dealCreateViewModel.pickedEndDateTime.month}'
            : '${_dealCreateViewModel.pickedEndDateTime.month}';
    final _endYear = '${_dealCreateViewModel.pickedEndDateTime.year}';

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
            title: Text(widget.deal == null ? Titles.newDeal : Titles.editDeal,
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
                child: GestureDetector(
                    onTap: () => FocusScope.of(context).unfocus(),
                    child: Stack(children: [
                      ListView(
                          shrinkWrap: true,
                          padding: EdgeInsets.only(
                              top: 14.0,
                              left: 16.0,
                              right: 16.0,
                              bottom:
                                  MediaQuery.of(context).padding.bottom == 0.0
                                      ? 20.0 + 54.0
                                      : MediaQuery.of(context).padding.bottom +
                                          54.0),
                          children: [
                            /// START DATE SELECTION INPUT
                            SelectionInputWidget(
                                margin: const EdgeInsets.only(bottom: 10.0),
                                isDate: true,
                                title: Titles.startDate,
                                value: '$_startDay.$_startMonth.$_startYear',
                                onTap: () => _dealCreateViewModel
                                    .showDateTimeSelectionSheet(context, 0)),

                            /// END DATE SELECTION INPUT
                            SelectionInputWidget(
                                margin: const EdgeInsets.only(bottom: 10.0),
                                isDate: true,
                                title: Titles.endDate,
                                value: '$_endDay.$_endMonth.$_endYear',
                                onTap: () => _dealCreateViewModel
                                    .showDateTimeSelectionSheet(context, 1)),

                            /// RESPONSIBLE SELECTION INPUT
                            SelectionInputWidget(
                                margin: const EdgeInsets.only(bottom: 10.0),
                                isVertical: true,
                                title: Titles.responsible,
                                value: Titles.notSelected,
                                onTap: () =>
                                    _dealCreateViewModel.showSearchScreenSheet(
                                        context, SearchType.responsible)),

                            /// OBJECT SELECTION INPUT
                            SelectionInputWidget(
                                margin: const EdgeInsets.only(bottom: 10.0),
                                isVertical: true,
                                title: Titles.object,
                                value: Titles.notSelected,
                                onTap: () =>
                                    _dealCreateViewModel.showSearchScreenSheet(
                                        context, SearchType.object)),

                            /// STAGE SELECTION INPUT
                            SelectionInputWidget(
                                margin: const EdgeInsets.only(bottom: 10.0),
                                isVertical: true,
                                title: Titles.phase,
                                value: Titles.notSelected,
                                onTap: () =>
                                    _dealCreateViewModel.showSearchScreenSheet(
                                        context, SearchType.phase)),

                            /// COMPANY SELECTION INPUT
                            SelectionInputWidget(
                                margin: const EdgeInsets.only(bottom: 10.0),
                                isVertical: true,
                                title: Titles.company,
                                value: Titles.notSelected,
                                onTap: () =>
                                    _dealCreateViewModel.showSearchScreenSheet(
                                        context, SearchType.company)),

                            /// COMMENT INPUT
                            InputWidget(
                                textEditingController: _textEditingController,
                                focusNode: _focusNode,
                                height: 168.0,
                                maxLines: 10,
                                margin: EdgeInsets.zero,
                                placeholder: '${Titles.comment}...',
                                onTap: () => setState,
                                onChange: (text) => {
                                      // TODO COMMENT
                                    }),
                            const SizedBox(height: 10.0),

                            /// PRODUCT LIST
                            ListView.builder(
                                shrinkWrap: true,
                                padding: EdgeInsets.zero,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: 1,
                                itemBuilder: (context, index) {
                                  return DealProductListItemWidget(
                                      index: index + 1,
                                      onDeleteTap: () => {},
                                      onProductSearchTap: () =>
                                          _dealCreateViewModel
                                              .showProductSearchScreenSheet(
                                                  context, index));
                                }),

                            /// ADD PRODUCT BUTTON
                            BorderButtonWidget(
                                title: Titles.addProduct,
                                margin: const EdgeInsets.only(bottom: 16.0),
                                onTap: () => _dealCreateViewModel.addProduct()),

                            /// FILE LIST
                            ListView.builder(
                                shrinkWrap: true,
                                padding: const EdgeInsets.only(top: 10.0),
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: 3,
                                itemBuilder: (context, index) {
                                  return FileListItemWidget(
                                      fileName: 'file.pdf',
                                      onRemoveTap: () => {});
                                }),

                            /// ADD FILE BUTTON
                            BorderButtonWidget(
                                title: Titles.addFile,
                                margin: const EdgeInsets.only(bottom: 30.0),
                                onTap: () => _dealCreateViewModel.addFile()),
                          ]),

                      /// ADD TASK BUTTON
                      Align(
                          alignment: Alignment.bottomCenter,
                          child: ButtonWidget(
                              isDisabled: true,
                              title: widget.deal == null
                                  ? Titles.createDeal
                                  : Titles.save,
                              margin: EdgeInsets.only(
                                  left: 16.0,
                                  right: 16.0,
                                  bottom: MediaQuery.of(context)
                                              .padding
                                              .bottom ==
                                          0.0
                                      ? 20.0
                                      : MediaQuery.of(context).padding.bottom),
                              onTap: () => {}))
                    ])))));
  }
}
