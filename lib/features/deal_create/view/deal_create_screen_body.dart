import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:izowork/components/components.dart';
import 'package:izowork/extensions/extensions.dart';
import 'package:izowork/features/deal_create/view_model/deal_create_view_model.dart';

import 'package:izowork/models/models.dart';

import 'package:izowork/features/deal/view/deal_screen.dart';
import 'package:izowork/features/deal_create/view/views/deal_product_list_item_widget.dart';
import 'package:izowork/features/search_company/view/search_company_screen.dart';
import 'package:izowork/features/search_object/view/search_object_screen.dart';
import 'package:izowork/features/search_product/view/search_product_screen.dart';
import 'package:izowork/features/search_user/view/search_user_screen.dart';
import 'package:izowork/features/selection/view/selection_screen.dart';
import 'package:izowork/views/views.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
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

    return Scaffold(
      backgroundColor: HexColors.white,
      appBar: AppBar(
        centerTitle: true,
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
          _dealCreateViewModel.deal == null ? Titles.newDeal : Titles.editDeal,
          style: TextStyle(
            overflow: TextOverflow.ellipsis,
            fontFamily: 'PT Root UI',
            fontSize: 18.0,
            fontWeight: FontWeight.w700,
            color: HexColors.black,
          ),
        ),
      ),
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
                      bottom: MediaQuery.of(context).padding.bottom == 0.0
                          ? 20.0 + 54.0
                          : MediaQuery.of(context).padding.bottom + 54.0),
                  children: [
                    /// START DATE SELECTION INPUT
                    SelectionInputWidget(
                      margin: const EdgeInsets.only(bottom: 10.0),
                      isDate: true,
                      title: Titles.startDate,
                      value: _dealCreateViewModel.startDateTime.toShortDate(),
                      onTap: () => _showDateTimeSelectionSheet(0),
                    ),

                    /// END DATE SELECTION INPUT
                    SelectionInputWidget(
                      margin: const EdgeInsets.only(bottom: 10.0),
                      isDate: true,
                      title: Titles.endDate,
                      value: _dealCreateViewModel.endDateTime.toShortDate(),
                      onTap: () => _showDateTimeSelectionSheet(1),
                    ),

                    /// RESPONSIBLE SELECTION INPUT
                    SelectionInputWidget(
                      margin: const EdgeInsets.only(bottom: 10.0),
                      isVertical: true,
                      title: Titles.responsible,
                      value: _dealCreateViewModel.responsible?.name ??
                          _dealCreateViewModel.deal?.responsible?.name ??
                          Titles.notSelected,
                      onTap: () => _showSearchUserSheet(),
                    ),

                    /// OBJECT SELECTION INPUT
                    Opacity(
                      opacity: _dealCreateViewModel.selectedObject != null
                          ? 0.5
                          : 1.0,
                      child: IgnorePointer(
                        ignoring: _dealCreateViewModel.selectedObject != null,
                        child: SelectionInputWidget(
                          margin: const EdgeInsets.only(bottom: 10.0),
                          isVertical: true,
                          title: Titles.object,
                          value: _dealCreateViewModel.object?.name ??
                              _dealCreateViewModel.deal?.object?.name ??
                              _dealCreateViewModel.selectedObject?.name ??
                              Titles.notSelected,
                          onTap: () => _showSearchObjectSheet(),
                        ),
                      ),
                    ),

                    /// PHASE SELECTION INPUT
                    Opacity(
                      opacity: _dealCreateViewModel.object == null ? 0.5 : 1.0,
                      child: IgnorePointer(
                        ignoring: _dealCreateViewModel.object == null,
                        child: SelectionInputWidget(
                          margin: const EdgeInsets.only(bottom: 10.0),
                          isVertical: true,
                          title: Titles.phase,
                          value: _dealCreateViewModel.phase?.name ??
                              _dealCreateViewModel.selectedPhase?.name ??
                              Titles.notSelected,
                          onTap: () => _showSelectionSheet(),
                        ),
                      ),
                    ),

                    /// COMPANY SELECTION INPUT
                    SelectionInputWidget(
                      margin: const EdgeInsets.only(bottom: 10.0),
                      isVertical: true,
                      title: Titles.company,
                      value: _dealCreateViewModel.company?.name ??
                          _dealCreateViewModel.deal?.company?.name ??
                          Titles.notSelected,
                      onTap: () => _showSearchCompanySheet(),
                    ),

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
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _dealCreateViewModel.dealProducts.length,
                            itemBuilder: (context, index) {
                              final dealProduct =
                                  _dealCreateViewModel.dealProducts[index];

                              return DealProductListItemWidget(
                                key: ValueKey(dealProduct.id),
                                index: index + 1,
                                dealProduct: dealProduct,
                                onProductSearchTap: () =>
                                    _showSearchProductSheet(index),
                                onWeightChange: (weight) =>
                                    _dealCreateViewModel.changeProductWeight(
                                  index,
                                  int.tryParse(weight) ?? 0,
                                ),
                                onDeleteTap: () => _dealCreateViewModel
                                    .deleteDealProduct(index),
                              );
                            }),

                    /// ADD PRODUCT BUTTON
                    _dealCreateViewModel.deal == null
                        ? Container()
                        : BorderButtonWidget(
                            title: Titles.addProduct,
                            margin: const EdgeInsets.only(bottom: 16.0),
                            onTap: () => _dealCreateViewModel.addDealProduct(),
                          ),

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
                                  : _dealCreateViewModel.deal!.files[index],
                            ),
                            ignoring: _dealCreateViewModel.downloadIndex != -1,
                            child: FileListItemWidget(
                              fileName: _dealCreateViewModel.deal == null
                                  ? _dealCreateViewModel.files[index].path
                                      .substring(
                                          _dealCreateViewModel
                                                  .files[index].path.length -
                                              10,
                                          _dealCreateViewModel
                                              .files[index].path.length)
                                  : _dealCreateViewModel
                                      .deal!.files[index].name,
                              isDownloading:
                                  _dealCreateViewModel.downloadIndex == index,
                              onTap: () => _dealCreateViewModel.openFile(index),
                              onRemoveTap: () =>
                                  _dealCreateViewModel.deleteFile(index),
                            ),
                          );
                        }),

                    /// ADD FILE BUTTON
                    BorderButtonWidget(
                      title: Titles.addFile,
                      margin: const EdgeInsets.only(bottom: 30.0),
                      onTap: () => _dealCreateViewModel.addFile(),
                    ),
                  ]),

              /// ADD TASK BUTTON
              Align(
                alignment: Alignment.bottomCenter,
                child: ButtonWidget(
                  isDisabled: _dealCreateViewModel.loadingStatus ==
                          LoadingStatus.searching
                      ? false
                      : _dealCreateViewModel.deal == null
                          ? _dealCreateViewModel.responsible == null ||
                              _dealCreateViewModel.object == null
                          : false,
                  title: _dealCreateViewModel.deal == null
                      ? Titles.createDeal
                      : Titles.save,
                  margin: EdgeInsets.only(
                    left: 16.0,
                    right: 16.0,
                    bottom: MediaQuery.of(context).padding.bottom == 0.0
                        ? 20.0
                        : MediaQuery.of(context).padding.bottom,
                  ),
                  onTap: () => _dealCreateViewModel.deal == null
                      ? _createDeal()
                      : _updateDeal(),
                ),
              ),

              /// INDICATOR
              _dealCreateViewModel.loadingStatus == LoadingStatus.searching
                  ? const LoadingIndicatorWidget()
                  : Container()
            ]),
          ),
        ),
      ),
    );
  }

  // MARK: -
  // MARK: - FUNCTIONS

  void _createDeal() => _dealCreateViewModel.createNewDeal(
      _textEditingController.text,
      (deal) => {
            if (mounted)
              {
                if (_dealCreateViewModel.phase == null)
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DealScreenWidget(id: deal.id)))
                else
                  {widget.onCreate(deal, []), Navigator.pop(context)}
              }
          });

  void _updateDeal() => _dealCreateViewModel.editDeal(
      _textEditingController.text,
      (deal) => {
            if (mounted)
              {
                widget.onCreate(deal, _dealCreateViewModel.dealProducts),
                Navigator.pop(context)
              }
          });

  // MARK: -
  // MARK: - PUSH

  void _showSelectionSheet() {
    List<String> items = [];
    if (_dealCreateViewModel.phases.isNotEmpty) {
      for (var element in _dealCreateViewModel.phases) {
        items.add(element.name);
      }
    }

    String? newStage;

    showCupertinoModalBottomSheet(
        enableDrag: false,
        topRadius: const Radius.circular(16.0),
        barrierColor: Colors.black.withValues(alpha: 0.6),
        backgroundColor: HexColors.white,
        context: context,
        builder: (sheetContext) => SelectionScreenWidget(
              title: Titles.phase,
              value: _dealCreateViewModel.phase?.name ??
                  _dealCreateViewModel.selectedPhase?.name ??
                  '',
              items: items,
              onSelectTap: (stage) => newStage = stage,
            )).whenComplete(() => _dealCreateViewModel.changePhase(newStage));
  }

  void _showDateTimeSelectionSheet(int index) {
    TextStyle textStyle = const TextStyle(
      overflow: TextOverflow.ellipsis,
      fontFamily: 'PT Root UI',
    );

    DateTime newDateTime = index == 0
        ? _dealCreateViewModel.startDateTime
        : _dealCreateViewModel.endDateTime;

    showCupertinoModalBottomSheet(
        enableDrag: false,
        topRadius: const Radius.circular(16.0),
        barrierColor: Colors.black.withValues(alpha: 0.6),
        backgroundColor: HexColors.white,
        context: context,
        builder: (sheetContext) => DateTimeWheelPickerWidget(
            minDateTime: _dealCreateViewModel.minDateTime,
            maxDateTime: _dealCreateViewModel.maxDateTime,
            initialDateTime: index == 0
                ? _dealCreateViewModel.startDateTime
                : _dealCreateViewModel.endDateTime,
            showDays: true,
            locale: Platform.localeName,
            backgroundColor: HexColors.white,
            buttonColor: HexColors.primaryMain,
            buttonHighlightColor: HexColors.primaryDark,
            buttonTitle: Titles.apply,
            buttonTextStyle: textStyle.copyWith(
              fontSize: 18.0,
              fontWeight: FontWeight.w700,
              color: HexColors.black,
            ),
            selecteTextStyle: textStyle.copyWith(
              fontSize: 14.0,
              color: HexColors.black,
              fontWeight: FontWeight.w400,
            ),
            unselectedTextStyle: textStyle.copyWith(
              fontSize: 12.0,
              color: HexColors.grey70,
              fontWeight: FontWeight.w400,
            ),
            onTap: (dateTime) => {
                  Navigator.pop(context),
                  newDateTime = dateTime,
                })).whenComplete(() => index == 0
        ? _dealCreateViewModel.changeStartDateTime(newDateTime)
        : _dealCreateViewModel.changeEndDateTime(newDateTime));
  }

  void _showSearchUserSheet() {
    User? newUser;

    showCupertinoModalBottomSheet(
      enableDrag: false,
      topRadius: const Radius.circular(16.0),
      barrierColor: Colors.black.withValues(alpha: 0.6),
      backgroundColor: HexColors.white,
      context: context,
      builder: (sheetContext) => SearchUserScreenWidget(
        title: Titles.responsible,
        isRoot: true,
        onFocus: () => {},
        onPop: (user) => {
          newUser = user,
          Navigator.pop(context),
        },
      ),
    ).whenComplete(() {
      if (newUser == null) return;
      _dealCreateViewModel.changeResponsible(newUser!);
    });
  }

  void _showSearchObjectSheet() {
    MapObject? newObject;

    showCupertinoModalBottomSheet(
      enableDrag: false,
      topRadius: const Radius.circular(16.0),
      barrierColor: Colors.black.withValues(alpha: 0.6),
      backgroundColor: HexColors.white,
      context: context,
      builder: (sheetContext) => SearchObjectScreenWidget(
          title: Titles.object,
          isRoot: true,
          onFocus: () => {},
          onPop: (object) => {
                newObject = object,
                Navigator.pop(context),
              }),
    ).whenComplete(() {
      if (newObject != null) {
        _dealCreateViewModel.changeObject(newObject);
        _dealCreateViewModel.getPhaseList(newObject!.id);
      }
    });
  }

  void _showSearchCompanySheet() {
    Company? newCompany;

    showCupertinoModalBottomSheet(
      enableDrag: false,
      topRadius: const Radius.circular(16.0),
      barrierColor: Colors.black.withValues(alpha: 0.6),
      backgroundColor: HexColors.white,
      context: context,
      builder: (sheetContext) => SearchCompanyScreenWidget(
          title: Titles.company,
          isRoot: true,
          onFocus: () => {},
          onPop: (company) => {
                newCompany = company,
                Navigator.pop(context),
              }),
    ).whenComplete(() => _dealCreateViewModel.changeCompany(newCompany));
  }

  void _showSearchProductSheet(int index) {
    Product? newProduct;

    showCupertinoModalBottomSheet(
      enableDrag: false,
      topRadius: const Radius.circular(16.0),
      barrierColor: Colors.black.withValues(alpha: 0.6),
      backgroundColor: HexColors.white,
      context: context,
      builder: (sheetContext) => SearchProductScreenWidget(
          isRoot: true,
          onFocus: () => {},
          onPop: (product) => {
                newProduct = product,
                Navigator.pop(context),
              }),
    ).whenComplete(() => _dealCreateViewModel.changeProduct(
          index,
          newProduct,
        ));
  }
}
