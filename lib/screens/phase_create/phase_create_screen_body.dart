import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/loading_status.dart';
import 'package:izowork/components/titles.dart';
import 'package:izowork/entities/response/phase_checklist.dart';
import 'package:izowork/entities/response/phase_contractor.dart';
import 'package:izowork/entities/response/phase_product.dart';
import 'package:izowork/models/phase_create_view_model.dart';
import 'package:izowork/screens/phase_create/views/phase_contractor_list_item_widget.dart';
import 'package:izowork/screens/phase_create/views/phase_product_list_item_widget.dart';
import 'package:izowork/views/back_button_widget.dart';
import 'package:izowork/views/border_button_widget.dart';
import 'package:izowork/views/loading_indicator_widget.dart';
import 'package:izowork/views/separator_widget.dart';
import 'package:provider/provider.dart';

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
            elevation: 0.0,
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
                    color: HexColors.black))),
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
                                      bottom: MediaQuery.of(context)
                                                  .padding
                                                  .bottom ==
                                              0.0
                                          ? 20.0
                                          : MediaQuery.of(context)
                                              .padding
                                              .bottom),
                                  children: [
                                    /// PRODUCT TITLE
                                    _phaseCreateViewModel.phaseProducts.isEmpty
                                        ? Container()
                                        : Text(Titles.products,
                                            style: TextStyle(
                                                color: HexColors.black,
                                                fontSize: 18.0,
                                                fontFamily: 'PT Root UI',
                                                fontWeight: FontWeight.bold)),

                                    /// PRODUCT LIST
                                    ListView.builder(
                                        shrinkWrap: true,
                                        padding: EdgeInsets.only(
                                            top: _phaseCreateViewModel
                                                    .phaseProducts.isEmpty
                                                ? 0.0
                                                : 16.0,
                                            bottom: 4.0),
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount: _phaseCreateViewModel
                                            .phaseProducts.length,
                                        itemBuilder: (context, index) {
                                          return PhaseProductListItemWidget(
                                              index: index + 1,
                                              phaseProduct:
                                                  _phaseCreateViewModel
                                                      .phaseProducts[index],
                                              onCountChange: (count) =>
                                                  _phaseCreateViewModel
                                                      .changeProductCount(
                                                          context,
                                                          index,
                                                          int.parse(
                                                            count.isEmpty
                                                                ? '0'
                                                                : count,
                                                          )),
                                              onTimeChange: (days) =>
                                                  _phaseCreateViewModel
                                                      .changeProductTermInDays(
                                                          context,
                                                          index,
                                                          int.parse(
                                                            days.isEmpty
                                                                ? '0'
                                                                : days,
                                                          )),
                                              onProductSearchTap: () =>
                                                  _phaseCreateViewModel
                                                      .showProductSearchSheet(
                                                    context,
                                                    index,
                                                  ),
                                              onDeleteTap: () =>
                                                  _phaseCreateViewModel
                                                      .deletePhaseProduct(
                                                    context,
                                                    index,
                                                  ));
                                        }),

                                    /// ADD PRODUCT BUTTON
                                    BorderButtonWidget(
                                        title: Titles.addProduct,
                                        margin:
                                            const EdgeInsets.only(bottom: 20.0),
                                        onTap: () => _phaseCreateViewModel
                                            .createProduct(context)),

                                    /// CONTRACTOR TITLE
                                    _phaseCreateViewModel
                                            .phaseContractors.isEmpty
                                        ? Container()
                                        : Text(Titles.contractors,
                                            style: TextStyle(
                                                color: HexColors.black,
                                                fontSize: 18.0,
                                                fontFamily: 'PT Root UI',
                                                fontWeight: FontWeight.bold)),

                                    /// CONTRACTOR LIST
                                    ListView.builder(
                                        shrinkWrap: true,
                                        padding: EdgeInsets.only(
                                            top: _phaseCreateViewModel
                                                    .phaseContractors.isEmpty
                                                ? 0.0
                                                : 16.0,
                                            bottom: 4.0),
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount: _phaseCreateViewModel
                                            .phaseContractors.length,
                                        itemBuilder: (context, index) {
                                          return PhaseContractorListItemWidget(
                                              index: index + 1,
                                              phaseContractor: _phaseCreateViewModel
                                                  .phaseContractors[index],
                                              onContractorTap: () =>
                                                  _phaseCreateViewModel.changeContractor(
                                                      context, index),
                                              onResponsibleTap: () => _phaseCreateViewModel
                                                  .changeContractorResponsible(
                                                      context, index),
                                              onCoExecutorTap: () => _phaseCreateViewModel
                                                  .changeContractorCoExecutor(
                                                      context, index),
                                              onObserverTap: () =>
                                                  _phaseCreateViewModel
                                                      .changeContractorObserver(
                                                          context, index),
                                              onDeleteTap: () => _phaseCreateViewModel.deleteContractor(context, index));
                                        }),

                                    /// ADD CONTRACTOR BUTTON
                                    BorderButtonWidget(
                                        title: Titles.addContractor,
                                        margin:
                                            const EdgeInsets.only(bottom: 20.0),
                                        onTap: () => _phaseCreateViewModel
                                            .createContractor(context, null)),
                                  ]))),

                      const SeparatorWidget(),

                      /// INDICATOR
                      _phaseCreateViewModel.loadingStatus ==
                              LoadingStatus.searching
                          ? const Padding(
                              padding: EdgeInsets.only(bottom: 60.0),
                              child: LoadingIndicatorWidget())
                          : Container()
                    ])))));
  }
}
