import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/titles.dart';
import 'package:izowork/entities/object.dart';
import 'package:izowork/entities/phase.dart';
import 'package:izowork/models/object_create_view_model.dart';
import 'package:izowork/models/phase_view_model.dart';
import 'package:izowork/models/search_view_model.dart';
import 'package:izowork/screens/object/views/object_stage_header_widget.dart';
import 'package:izowork/screens/object/views/object_stage_list_item_widget.dart';
import 'package:izowork/screens/phase/views/check_list_item_widget.dart';
import 'package:izowork/screens/phase/views/contractor_list_item_widget.dart';
import 'package:izowork/screens/search/views/search_list_item_widget.dart';
import 'package:izowork/views/back_button_widget.dart';
import 'package:izowork/views/border_button_widget.dart';
import 'package:izowork/views/button_widget_widget.dart';
import 'package:izowork/views/checkbox_widget.dart';
import 'package:izowork/views/file_list_widget.dart';
import 'package:izowork/views/input_widget.dart';
import 'package:izowork/views/selection_input_widget.dart';
import 'package:izowork/views/separator_widget.dart';
import 'package:izowork/views/subtitle_widget.dart';
import 'package:izowork/views/title_widget.dart';
import 'package:provider/provider.dart';

class PhaseCreateScreenBodyWidget extends StatefulWidget {
  final Phase phase;

  const PhaseCreateScreenBodyWidget({Key? key, required this.phase})
      : super(key: key);

  @override
  _PhaseScreenBodyState createState() => _PhaseScreenBodyState();
}

class _PhaseScreenBodyState extends State<PhaseCreateScreenBodyWidget> {
  final TextEditingController _nameTextEditingController =
      TextEditingController();
  final FocusNode _nameFocusNode = FocusNode();

  final TextEditingController _addressTextEditingController =
      TextEditingController();
  final FocusNode _addressFocusNode = FocusNode();

  final TextEditingController _coordinatesTextEditingController =
      TextEditingController();
  final FocusNode _coordinatesFocusNode = FocusNode();

  final TextEditingController _floorCountTextEditingController =
      TextEditingController();
  final FocusNode _floorCountFocusNode = FocusNode();

  final TextEditingController _areaCountTextEditingController =
      TextEditingController();
  final FocusNode _areaCountFocusNode = FocusNode();

  final TextEditingController _buildingTimeTextEditingController =
      TextEditingController();
  final FocusNode _buildingTimeFocusNode = FocusNode();

  final TextEditingController _stagesTextEditingController =
      TextEditingController();
  final FocusNode _stagesFocusNode = FocusNode();

  final TextEditingController _kisoTextEditingController =
      TextEditingController();
  final FocusNode _kisoFocusNode = FocusNode();

  late PhaseViewModel _phaseViewModel;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _nameTextEditingController.dispose();
    _nameFocusNode.dispose();
    _addressTextEditingController.dispose();
    _addressFocusNode.dispose();
    _coordinatesTextEditingController.dispose();
    _coordinatesFocusNode.dispose();
    _floorCountTextEditingController.dispose();
    _floorCountFocusNode.dispose();
    _areaCountTextEditingController.dispose();
    _areaCountFocusNode.dispose();
    _buildingTimeTextEditingController.dispose();
    _buildingTimeFocusNode.dispose();
    _stagesTextEditingController.dispose();
    _stagesFocusNode.dispose();
    _kisoTextEditingController.dispose();
    _kisoFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _phaseViewModel = Provider.of<PhaseViewModel>(context, listen: true);

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
            title: Text('Название этапа',
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
                child: Stack(children: [
                  GestureDetector(
                      onTap: () => FocusScope.of(context).unfocus(),
                      child: ListView(
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
                            Text(Titles.contractors,
                                style: TextStyle(
                                    color: HexColors.black,
                                    fontSize: 18.0,
                                    fontFamily: 'PT Root UI',
                                    fontWeight: FontWeight.bold)),

                            /// CONTRACTOR LIST
                            ListView.builder(
                                shrinkWrap: true,
                                padding: const EdgeInsets.only(
                                    top: 16.0, bottom: 10.0),
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: 2,
                                itemBuilder: (context, index) {
                                  return ContractorListItemWidget(
                                      onTap: () => {});
                                }),

                            /// RESPONSIBLE
                            const TitleWidget(
                                padding: EdgeInsets.only(bottom: 4.0),
                                text: Titles.responsible,
                                isSmall: true),
                            const SubtitleWidget(
                                padding: EdgeInsets.only(bottom: 16.0),
                                text: 'Имя фамилия'),

                            /// CO-EXECUTOR
                            const TitleWidget(
                                padding: EdgeInsets.only(bottom: 4.0),
                                text: Titles.coExecutor,
                                isSmall: true),
                            const SubtitleWidget(
                                padding: EdgeInsets.only(bottom: 16.0),
                                text: 'Имя фамилия'),

                            /// OBSERVER
                            const TitleWidget(
                                padding: EdgeInsets.only(bottom: 4.0),
                                text: Titles.observer,
                                isSmall: true),
                            const SubtitleWidget(
                                padding: EdgeInsets.only(bottom: 16.0),
                                text: 'Имя фамилия'),

                            /// DEALS
                            const TitleWidget(
                                padding: EdgeInsets.only(bottom: 10.0),
                                text: Titles.deals,
                                isSmall: true),

                            /// DEAL LIST
                            ListView.builder(
                                shrinkWrap: true,
                                padding: const EdgeInsets.only(bottom: 10.0),
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: 2,
                                itemBuilder: (context, index) {
                                  return SearchListItemWidget(
                                      name: '${Titles.deal}  №${index + 1}',
                                      onTap: () => _phaseViewModel
                                          .showDealScreenWidget(context));
                                }),

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
                                      isSelected: index < 2,
                                      title: 'Позиция чек-листа ${index + 1}',
                                      onTap: () => _phaseViewModel
                                          .showCompleteTaskScreenSheet(
                                              context));
                                }),

                            /// SET TASK BUTTON
                            BorderButtonWidget(
                                title: Titles.setTask,
                                margin: const EdgeInsets.only(bottom: 20.0),
                                onTap: () => _phaseViewModel
                                    .showTaskCreateScreen(context)),

                            /// OPEN DEAL BUTTON
                            BorderButtonWidget(
                                title: Titles.openDeal,
                                margin: const EdgeInsets.only(bottom: 16.0),
                                onTap: () => _phaseViewModel
                                    .showDealCreateScreen(context)),
                          ])),

                  /// EDIT PHASE BUTTON
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: ButtonWidget(
                          isDisabled: false,
                          title: Titles.edit,
                          margin: EdgeInsets.only(
                              left: 16.0,
                              right: 16.0,
                              bottom:
                                  MediaQuery.of(context).padding.bottom == 0.0
                                      ? 20.0
                                      : MediaQuery.of(context).padding.bottom),
                          onTap: () =>
                              _phaseViewModel.showPhaseCreateScreen(context)))
                ]))));
  }
}
