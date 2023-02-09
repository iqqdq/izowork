import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/titles.dart';
import 'package:izowork/entities/response/phase.dart';
import 'package:izowork/models/phase_create_view_model.dart';
import 'package:izowork/models/search_view_model.dart';
import 'package:izowork/screens/phase/views/check_list_item_widget.dart';
import 'package:izowork/screens/phase_create/views/phase_contractor_list_item_widget.dart';
import 'package:izowork/screens/phase_create/views/phase_product_list_item_widget.dart';
import 'package:izowork/views/back_button_widget.dart';
import 'package:izowork/views/border_button_widget.dart';
import 'package:izowork/views/button_widget_widget.dart';
import 'package:izowork/views/selection_input_widget.dart';
import 'package:izowork/views/title_widget.dart';
import 'package:provider/provider.dart';

class PhaseCreateScreenBodyWidget extends StatefulWidget {
  final Phase? phase;

  const PhaseCreateScreenBodyWidget({Key? key, this.phase}) : super(key: key);

  @override
  _PhaseCreateScreenBodyState createState() => _PhaseCreateScreenBodyState();
}

class _PhaseCreateScreenBodyState extends State<PhaseCreateScreenBodyWidget> {
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  late PhaseCreateViewModel _phaseCreateViewModel;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _phaseCreateViewModel =
        Provider.of<PhaseCreateViewModel>(context, listen: true);

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
            title: Text(
                widget.phase == null ? Titles.newPhase : Titles.editPhase,
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
                            /// TITLE
                            Text(Titles.products,
                                style: TextStyle(
                                    color: HexColors.black,
                                    fontSize: 18.0,
                                    fontFamily: 'PT Root UI',
                                    fontWeight: FontWeight.bold)),

                            /// PRODUCT LIST
                            ListView.builder(
                                shrinkWrap: true,
                                padding: const EdgeInsets.only(
                                    top: 16.0, bottom: 4.0),
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: 1,
                                itemBuilder: (context, index) {
                                  return PhaseProductListItemWidget(
                                      index: index + 1,
                                      onContractorSearchTap: () =>
                                          _phaseCreateViewModel
                                              .showSearchScreenSheet(context,
                                                  SearchType.responsible),
                                      onProductSearchTap: () =>
                                          _phaseCreateViewModel
                                              .showProductSearchScreenSheet(
                                                  context, index),
                                      onDeleteTap: () => {});
                                }),

                            /// ADD PRODUCT BUTTON
                            BorderButtonWidget(
                                title: Titles.addProduct,
                                margin: const EdgeInsets.only(bottom: 20.0),
                                onTap: () => {}),

                            /// CONTRACTOR LIST
                            ListView.builder(
                                shrinkWrap: true,
                                padding: const EdgeInsets.only(bottom: 4.0),
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: 1,
                                itemBuilder: (context, index) {
                                  return PhaseContractorListItemWidget(
                                      index: index + 1,
                                      onContractorTap: () => _phaseCreateViewModel
                                          .showSearchScreenSheet(
                                              context, SearchType.contractor),
                                      onResponsibleTap: () => _phaseCreateViewModel
                                          .showSearchScreenSheet(
                                              context, SearchType.responsible),
                                      onCoExecutorTap: () => _phaseCreateViewModel
                                          .showSearchScreenSheet(
                                              context, SearchType.responsible),
                                      onObserverTap: () => _phaseCreateViewModel
                                          .showSearchScreenSheet(
                                              context, SearchType.responsible),
                                      onDeleteTap: () => {});
                                }),

                            /// ADD CONTRACTOR BUTTON
                            BorderButtonWidget(
                                title: Titles.addContractor,
                                margin: const EdgeInsets.only(bottom: 20.0),
                                onTap: () => {}),

                            /// CHECK
                            const TitleWidget(
                                padding: EdgeInsets.zero,
                                text: Titles.checkList,
                                isSmall: true),

                            /// CHECKBOX LIST
                            ListView.builder(
                                shrinkWrap: true,
                                padding: const EdgeInsets.only(bottom: 20.0),
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: 4,
                                itemBuilder: (context, index) {
                                  return CheckListItemWidget(
                                      isSelected: index == 0,
                                      title: 'Позиция чек-листа ${index + 1}',
                                      onTap: () => {});
                                }),

                            /// SET TASK BUTTON
                            BorderButtonWidget(
                                title: Titles.addTask,
                                margin: const EdgeInsets.only(bottom: 20.0),
                                onTap: () => _phaseCreateViewModel
                                    .showTaskCreateScreen(context)),
                          ]),

                      /// ADD PHASE BUTTON
                      Align(
                          alignment: Alignment.bottomCenter,
                          child: ButtonWidget(
                              isDisabled: true,
                              title: widget.phase == null
                                  ? Titles.createPhase
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
