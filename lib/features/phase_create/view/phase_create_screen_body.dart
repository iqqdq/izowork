import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:izowork/features/phase_create/view_model/phase_create_view_model.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

import 'package:izowork/components/components.dart';
import 'package:izowork/models/models.dart';

import 'package:izowork/features/phase_create/view/views/phase_contractor_list_item_widget.dart';
import 'package:izowork/features/phase_create/view/views/phase_product_list_item_widget.dart';
import 'package:izowork/features/product_selection/view/product_selection_screen.dart';
import 'package:izowork/features/search_company/view/search_company_screen.dart';
import 'package:izowork/features/search_user/view/search_user_screen.dart';
import 'package:izowork/views/views.dart';

class PhaseCreateScreenBodyWidget extends StatefulWidget {
  final Function(
    List<PhaseProduct>,
    List<PhaseContractor>,
    List<PhaseChecklist>,
  ) onPop;

  const PhaseCreateScreenBodyWidget({
    Key? key,
    required this.onPop,
  }) : super(key: key);

  @override
  _PhaseCreateScreenBodyState createState() => _PhaseCreateScreenBodyState();
}

class _PhaseCreateScreenBodyState extends State<PhaseCreateScreenBodyWidget> {
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  late PhaseCreateViewModel _phaseCreateViewModel;

  @override
  void dispose() {
    _textEditingController.dispose();
    _focusNode.dispose();

    widget.onPop(
      _phaseCreateViewModel.phaseProducts,
      _phaseCreateViewModel.phaseContractors,
      _phaseCreateViewModel.phaseChecklists,
    );

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _phaseCreateViewModel = Provider.of<PhaseCreateViewModel>(
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
            child: BackButtonWidget(onTap: () => {Navigator.pop(context)})),
        title: Text(_phaseCreateViewModel.phase.name,
            style: TextStyle(
              overflow: TextOverflow.ellipsis,
              fontFamily: 'PT Root UI',
              fontSize: 18.0,
              fontWeight: FontWeight.w700,
              color: HexColors.black,
            )),
      ),
      body: Material(
        type: MaterialType.transparency,
        child: SizedBox.expand(
          child: Container(
            color: HexColors.white,
            child: Stack(children: [
              SizedBox.expand(
                child: GestureDetector(
                  onTap: () => FocusScope.of(context).unfocus(),
                  child: ListView(
                      shrinkWrap: true,
                      padding: EdgeInsets.only(
                        top: 14.0,
                        left: 16.0,
                        right: 16.0,
                        bottom: MediaQuery.of(context).padding.bottom == 0.0
                            ? 20.0
                            : MediaQuery.of(context).padding.bottom,
                      ),
                      children: [
                        /// PRODUCT TITLE
                        _phaseCreateViewModel.phaseProducts.isEmpty
                            ? Container()
                            : Text(Titles.products,
                                style: TextStyle(
                                  color: HexColors.black,
                                  fontSize: 18.0,
                                  fontFamily: 'PT Root UI',
                                  fontWeight: FontWeight.bold,
                                )),

                        /// PRODUCT LIST
                        ListView.builder(
                            shrinkWrap: true,
                            padding: EdgeInsets.only(
                              top: _phaseCreateViewModel.phaseProducts.isEmpty
                                  ? 0.0
                                  : 16.0,
                              bottom: 4.0,
                            ),
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount:
                                _phaseCreateViewModel.phaseProducts.length,
                            itemBuilder: (context, index) {
                              final phaseProduct =
                                  _phaseCreateViewModel.phaseProducts[index];

                              return PhaseProductListItemWidget(
                                key: ValueKey(phaseProduct.id),
                                index: index + 1,
                                phaseProduct: phaseProduct,
                                onCountChange: (count) =>
                                    _phaseCreateViewModel.changeProductCount(
                                  index,
                                  int.parse(count.isEmpty ? '0' : count),
                                ),
                                onTimeChange: (days) => _phaseCreateViewModel
                                    .changeProductTermInDays(
                                  index,
                                  int.parse(days.isEmpty ? '0' : days),
                                ),
                                onProductSearchTap: () =>
                                    _showProductSearchSheet(index),
                                onDeleteTap: () => _phaseCreateViewModel
                                    .deletePhaseProduct(index),
                              );
                            }),

                        /// ADD PRODUCT BUTTON
                        BorderButtonWidget(
                          title: Titles.addProduct,
                          margin: const EdgeInsets.only(bottom: 20.0),
                          onTap: () => _phaseCreateViewModel.createProduct(),
                        ),

                        /// CONTRACTOR TITLE
                        _phaseCreateViewModel.phaseContractors.isEmpty
                            ? Container()
                            : Text(Titles.contractors,
                                style: TextStyle(
                                  color: HexColors.black,
                                  fontSize: 18.0,
                                  fontFamily: 'PT Root UI',
                                  fontWeight: FontWeight.bold,
                                )),

                        /// CONTRACTOR LIST
                        ListView.builder(
                            shrinkWrap: true,
                            padding: EdgeInsets.only(
                              top:
                                  _phaseCreateViewModel.phaseContractors.isEmpty
                                      ? 0.0
                                      : 16.0,
                              bottom: 4.0,
                            ),
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount:
                                _phaseCreateViewModel.phaseContractors.length,
                            itemBuilder: (context, index) {
                              final phaseContractor =
                                  _phaseCreateViewModel.phaseContractors[index];

                              return PhaseContractorListItemWidget(
                                key: ValueKey(phaseContractor.id),
                                index: index + 1,
                                phaseContractor: phaseContractor,
                                onContractorTap: () => _changeContractor(index),
                                onResponsibleTap: () =>
                                    _changeContractorResponsible(index),
                                onCoExecutorTap: () =>
                                    _changeContractorCoExecutor(index),
                                onObserverTap: () =>
                                    _changeContractorObserver(index),
                                onDeleteTap: () => _phaseCreateViewModel
                                    .deleteContractor(index),
                              );
                            }),

                        /// ADD CONTRACTOR BUTTON
                        BorderButtonWidget(
                          title: Titles.addContractor,
                          margin: const EdgeInsets.only(bottom: 20.0),
                          onTap: () =>
                              _phaseCreateViewModel.createContractor(null),
                        ),
                      ]),
                ),
              ),

              const SeparatorWidget(),

              /// INDICATOR
              _phaseCreateViewModel.loadingStatus == LoadingStatus.searching
                  ? const LoadingIndicatorWidget()
                  : Container()
            ]),
          ),
        ),
      ),
    );
  }

  // MARK: -
  // MARK: - PUSH

  void _changeContractor(int index) {
    Company? newCompany;

    showCupertinoModalBottomSheet(
      enableDrag: false,
      topRadius: const Radius.circular(16.0),
      barrierColor: Colors.black.withOpacity(0.6),
      backgroundColor: HexColors.white,
      context: context,
      builder: (sheetContext) => SearchCompanyScreenWidget(
          title: Titles.contractor,
          isRoot: true,
          onFocus: () => {},
          onPop: (company) => {
                newCompany = company,
                Navigator.pop(context),
              }),
    ).whenComplete(() => _phaseCreateViewModel.changeContracor(
          newCompany,
          index,
        ));
  }

  void _changeContractorResponsible(int index) {
    User? newUser;

    showCupertinoModalBottomSheet(
      enableDrag: false,
      topRadius: const Radius.circular(16.0),
      barrierColor: Colors.black.withOpacity(0.6),
      backgroundColor: HexColors.white,
      context: context,
      builder: (sheetContext) => SearchUserScreenWidget(
          title: Titles.responsible,
          isRoot: true,
          onFocus: () => {},
          onPop: (user) => {
                newUser = user,
                Navigator.pop(context),
              }),
    ).whenComplete(() => _phaseCreateViewModel.changeResponsible(
          newUser,
          index,
        ));
  }

  void _changeContractorCoExecutor(int index) {
    User? newUser;

    showCupertinoModalBottomSheet(
      enableDrag: false,
      topRadius: const Radius.circular(16.0),
      barrierColor: Colors.black.withOpacity(0.6),
      backgroundColor: HexColors.white,
      context: context,
      builder: (sheetContext) => SearchUserScreenWidget(
          title: Titles.coExecutor,
          isRoot: true,
          onFocus: () => {},
          onPop: (user) => {
                newUser = user,
                Navigator.pop(context),
              }),
    ).whenComplete(() => _phaseCreateViewModel.changeCoExecutor(
          newUser,
          index,
        ));
  }

  void _changeContractorObserver(int index) {
    User? newUser;

    showCupertinoModalBottomSheet(
      enableDrag: false,
      topRadius: const Radius.circular(16.0),
      barrierColor: Colors.black.withOpacity(0.6),
      backgroundColor: HexColors.white,
      context: context,
      builder: (sheetContext) => SearchUserScreenWidget(
          title: Titles.observer,
          isRoot: true,
          onFocus: () => {},
          onPop: (user) => {
                newUser = user,
                Navigator.pop(context),
              }),
    ).whenComplete(() => _phaseCreateViewModel.changeObserver(
          newUser,
          index,
        ));
  }

  void _showProductSearchSheet(int index) {
    Product? newProduct;

    showCupertinoModalBottomSheet(
      enableDrag: false,
      topRadius: const Radius.circular(16.0),
      barrierColor: Colors.black.withOpacity(0.6),
      backgroundColor: HexColors.white,
      context: context,
      builder: (sheetContext) => ProductSelectionScreenWidget(
          title: Titles.product,
          onPop: (product) => {
                newProduct = product,
                Navigator.pop(context),
              }),
    ).whenComplete(() => _phaseCreateViewModel.changeProduct(
          newProduct,
          index,
        ));
  }

  // void _showTaskCreateScreen() => Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => TaskCreateScreenWidget(
  //           onCreate: (task) => {
  //                 if (task != null)
  //                   Toast()
  //                       .showTopToast('${Titles.task} "${task.name}" создана')
  //               }),
  //     ));
}
