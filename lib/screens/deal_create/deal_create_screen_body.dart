import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:izowork/components/components.dart';

import 'package:izowork/models/models.dart';
import 'package:izowork/notifiers/domain.dart';
import 'package:izowork/screens/deal/deal_screen.dart';
import 'package:izowork/screens/deal_create/views/deal_product_list_item_widget.dart';
import 'package:izowork/views/views.dart';
import 'package:provider/provider.dart';

class DealCreateScreenBodyWidget extends StatefulWidget {
  final Function(Deal?, List<DealProduct>) onCreate;

  const DealCreateScreenBodyWidget({Key? key, required this.onCreate})
      : super(key: key);

  @override
  _DealCreateScreenBodyState createState() => _DealCreateScreenBodyState();
}

class _DealCreateScreenBodyState extends State<DealCreateScreenBodyWidget> {
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  late DealCreateViewModel _dealCreateViewModel;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_dealCreateViewModel.deal != null) {
        _textEditingController.text = _dealCreateViewModel.deal?.comment ?? '';
      }
    });
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _dealCreateViewModel = Provider.of<DealCreateViewModel>(
      context,
      listen: true,
    );

    final _startDay =
        _dealCreateViewModel.startDateTime.day.toString().length == 1
            ? '0${_dealCreateViewModel.startDateTime.day}'
            : '${_dealCreateViewModel.startDateTime.day}';
    final _startMonth =
        _dealCreateViewModel.startDateTime.month.toString().length == 1
            ? '0${_dealCreateViewModel.startDateTime.month}'
            : '${_dealCreateViewModel.startDateTime.month}';
    final _startYear = '${_dealCreateViewModel.startDateTime.year}';

    final _endDay = _dealCreateViewModel.endDateTime.day.toString().length == 1
        ? '0${_dealCreateViewModel.endDateTime.day}'
        : '${_dealCreateViewModel.endDateTime.day}';
    final _endMonth =
        _dealCreateViewModel.endDateTime.month.toString().length == 1
            ? '0${_dealCreateViewModel.endDateTime.month}'
            : '${_dealCreateViewModel.endDateTime.month}';
    final _endYear = '${_dealCreateViewModel.endDateTime.year}';

    return Scaffold(
        backgroundColor: HexColors.white,
        appBar: AppBar(
            centerTitle: true,
            elevation: 0.0,
            systemOverlayStyle: SystemUiOverlayStyle.dark,
            backgroundColor: Colors.transparent,
            leading: Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: BackButtonWidget(
                    onTap: () => {
                          widget.onCreate(_dealCreateViewModel.deal,
                              _dealCreateViewModel.dealProducts),
                          Navigator.pop(context)
                        })),
            title: Text(
                _dealCreateViewModel.deal == null
                    ? Titles.newDeal
                    : Titles.editDeal,
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
                                value: _dealCreateViewModel.responsible?.name ??
                                    _dealCreateViewModel
                                        .deal?.responsible?.name ??
                                    Titles.notSelected,
                                onTap: () => _dealCreateViewModel
                                    .showSearchUserSheet(context)),

                            /// OBJECT SELECTION INPUT
                            Opacity(
                                opacity: _dealCreateViewModel.selectedObject !=
                                        null
                                    ? 0.5
                                    : 1.0,
                                child: IgnorePointer(
                                    ignoring: _dealCreateViewModel
                                            .selectedObject !=
                                        null,
                                    child: SelectionInputWidget(
                                        margin: const EdgeInsets
                                            .only(bottom: 10.0),
                                        isVertical: true,
                                        title: Titles.object,
                                        value:
                                            _dealCreateViewModel
                                                    .object?.name ??
                                                _dealCreateViewModel
                                                    .deal?.object?.name ??
                                                _dealCreateViewModel
                                                    .selectedObject?.name ??
                                                Titles.notSelected,
                                        onTap: () => _dealCreateViewModel
                                            .showSearchObjectSheet(context)))),

                            /// PHASE SELECTION INPUT
                            Opacity(
                                opacity: _dealCreateViewModel.object == null
                                    ? 0.5
                                    : 1.0,
                                child: IgnorePointer(
                                    ignoring:
                                        _dealCreateViewModel.object == null,
                                    child: SelectionInputWidget(
                                        margin:
                                            const EdgeInsets.only(bottom: 10.0),
                                        isVertical: true,
                                        title: Titles.phase,
                                        value:
                                            _dealCreateViewModel.phase?.name ??
                                                _dealCreateViewModel
                                                    .selectedPhase?.name ??
                                                Titles.notSelected,
                                        onTap: () => _dealCreateViewModel
                                            .showSelectionSheet(context)))),

                            /// COMPANY SELECTION INPUT
                            SelectionInputWidget(
                                margin: const EdgeInsets.only(bottom: 10.0),
                                isVertical: true,
                                title: Titles.company,
                                value: _dealCreateViewModel.company?.name ??
                                    _dealCreateViewModel.deal?.company?.name ??
                                    Titles.notSelected,
                                onTap: () => _dealCreateViewModel
                                    .showSearchCompanySheet(context)),

                            /// COMMENT INPUT
                            InputWidget(
                                textEditingController: _textEditingController,
                                focusNode: _focusNode,
                                height: 168.0,
                                maxLines: 10,
                                margin: EdgeInsets.zero,
                                placeholder: '${Titles.comment}...',
                                onTap: () => setState,
                                onChange: (text) => setState(() {})),
                            const SizedBox(height: 10.0),

                            /// PRODUCT LIST
                            _dealCreateViewModel.deal == null
                                ? Container()
                                : ListView.builder(
                                    shrinkWrap: true,
                                    padding: EdgeInsets.zero,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: _dealCreateViewModel
                                        .dealProducts.length,
                                    itemBuilder: (context, index) {
                                      return DealProductListItemWidget(
                                        key: ValueKey(_dealCreateViewModel
                                            .dealProducts[index].id),
                                        index: index + 1,
                                        dealProduct: _dealCreateViewModel
                                            .dealProducts[index],
                                        onProductSearchTap: () =>
                                            _dealCreateViewModel
                                                .showSearchProductSheet(
                                                    context, index),
                                        onWeightChange: (weight) =>
                                            _dealCreateViewModel
                                                .changeProductWeight(
                                                    context,
                                                    index,
                                                    int.tryParse(weight) ?? 0),
                                        onDeleteTap: () => _dealCreateViewModel
                                            .deleteDealProduct(context, index),
                                      );
                                    }),

                            /// ADD PRODUCT BUTTON
                            _dealCreateViewModel.deal == null
                                ? Container()
                                : BorderButtonWidget(
                                    title: Titles.addProduct,
                                    margin: const EdgeInsets.only(bottom: 16.0),
                                    onTap: () => _dealCreateViewModel
                                        .addDealProduct(context)),

                            /// FILE LIST
                            ListView.builder(
                                shrinkWrap: true,
                                padding: EdgeInsets.zero,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: _dealCreateViewModel.deal == null
                                    ? _dealCreateViewModel.files.length
                                    : _dealCreateViewModel.deal!.files.length,
                                itemBuilder: (context, index) {
                                  return IgnorePointer(
                                      key: ValueKey(
                                        _dealCreateViewModel.deal == null
                                            ? _dealCreateViewModel.files[index]
                                            : _dealCreateViewModel
                                                .deal!.files[index],
                                      ),
                                      ignoring: _dealCreateViewModel.downloadIndex !=
                                          -1,
                                      child: FileListItemWidget(
                                          fileName: _dealCreateViewModel.deal == null
                                              ? _dealCreateViewModel.files[index].path
                                                  .substring(
                                                      _dealCreateViewModel
                                                              .files[index]
                                                              .path
                                                              .length -
                                                          10,
                                                      _dealCreateViewModel
                                                          .files[index]
                                                          .path
                                                          .length)
                                              : _dealCreateViewModel
                                                  .deal!.files[index].name,
                                          isDownloading:
                                              _dealCreateViewModel.downloadIndex ==
                                                  index,
                                          onTap: () => _dealCreateViewModel
                                              .openFile(context, index),
                                          onRemoveTap: () => _dealCreateViewModel
                                              .deleteFile(context, index)));
                                }),

                            /// ADD FILE BUTTON
                            BorderButtonWidget(
                                title: Titles.addFile,
                                margin: const EdgeInsets.only(bottom: 30.0),
                                onTap: () =>
                                    _dealCreateViewModel.addFile(context)),
                          ]),

                      /// ADD TASK BUTTON
                      Align(
                          alignment: Alignment.bottomCenter,
                          child: ButtonWidget(
                              isDisabled: _dealCreateViewModel.loadingStatus ==
                                      LoadingStatus.searching
                                  ? false
                                  : _dealCreateViewModel.deal == null
                                      ? _dealCreateViewModel.responsible ==
                                              null ||
                                          _dealCreateViewModel.object == null
                                      : false,
                              title: _dealCreateViewModel.deal == null
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
                              onTap: () => _dealCreateViewModel.deal == null
                                  ? _dealCreateViewModel.createNewDeal(
                                      context,
                                      _textEditingController.text,
                                      (deal) => {
                                            if (mounted)
                                              {
                                                if (_dealCreateViewModel
                                                        .phase ==
                                                    null)
                                                  {
                                                    Navigator.pushReplacement(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                DealScreenWidget(
                                                                    id: deal
                                                                        .id)))
                                                  }
                                                else
                                                  {
                                                    widget.onCreate(deal, []),
                                                    Navigator.pop(context)
                                                  }
                                              }
                                          })
                                  : _dealCreateViewModel.editDeal(
                                      context,
                                      _textEditingController.text,
                                      (deal) => {
                                            if (mounted)
                                              {
                                                widget.onCreate(
                                                    deal,
                                                    _dealCreateViewModel
                                                        .dealProducts),
                                                Navigator.pop(context)
                                              }
                                          }))),

                      /// INDICATOR
                      _dealCreateViewModel.loadingStatus ==
                              LoadingStatus.searching
                          ? const LoadingIndicatorWidget()
                          : Container()
                    ])))));
  }
}
