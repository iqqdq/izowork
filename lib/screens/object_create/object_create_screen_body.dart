import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/loading_status.dart';
import 'package:izowork/components/titles.dart';
import 'package:izowork/entities/response/object.dart';
import 'package:izowork/models/object_create_view_model.dart';
import 'package:izowork/screens/object/object_page_view_screen.dart';
import 'package:izowork/views/back_button_widget.dart';
import 'package:izowork/views/border_button_widget.dart';
import 'package:izowork/views/button_widget_widget.dart';
import 'package:izowork/views/checkbox_widget.dart';
import 'package:izowork/views/file_list_widget.dart';
import 'package:izowork/views/input_widget.dart';
import 'package:izowork/views/loading_indicator_widget.dart';
import 'package:izowork/views/selection_input_widget.dart';
import 'package:izowork/views/separator_widget.dart';
import 'package:provider/provider.dart';

class ObjectCreateScreenBodyWidget extends StatefulWidget {
  final Object? object;
  final Function(Object) onUpdate;

  const ObjectCreateScreenBodyWidget(
      {Key? key, this.object, required this.onUpdate})
      : super(key: key);

  @override
  _ObjectCreateScreenBodyState createState() => _ObjectCreateScreenBodyState();
}

class _ObjectCreateScreenBodyState extends State<ObjectCreateScreenBodyWidget> {
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

  final TextEditingController _kisoTextEditingController =
      TextEditingController();
  final FocusNode _kisoFocusNode = FocusNode();

  late ObjectCreateViewModel _objectCreateViewModel;

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
    _kisoTextEditingController.dispose();
    _kisoFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _objectCreateViewModel =
        Provider.of<ObjectCreateViewModel>(context, listen: true);

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
                widget.object == null ? Titles.newObject : Titles.editObject,
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
                            /// NAME INPUT
                            InputWidget(
                              textEditingController: _nameTextEditingController,
                              focusNode: _nameFocusNode,
                              margin: const EdgeInsets.only(bottom: 10.0),
                              height: 56.0,
                              placeholder: Titles.objectName,
                              onTap: () => setState,
                              onChange: (text) => {
                                // TODO OBJECT NAME
                              },
                            ),

                            /// ADDRESS INPUT
                            InputWidget(
                              textEditingController:
                                  _addressTextEditingController,
                              focusNode: _addressFocusNode,
                              margin: const EdgeInsets.only(bottom: 10.0),
                              height: 56.0,
                              placeholder: Titles.address,
                              onTap: () => setState,
                              onChange: (text) => {
                                // TODO OBJECT ADDRESS NAME
                              },
                            ),

                            /// COORDINATES INPUT
                            InputWidget(
                              textEditingController:
                                  _coordinatesTextEditingController,
                              focusNode: _coordinatesFocusNode,
                              textInputType:
                                  const TextInputType.numberWithOptions(
                                      signed: true),
                              margin: const EdgeInsets.only(bottom: 10.0),
                              height: 56.0,
                              placeholder: Titles.coordinates,
                              onTap: () => setState,
                              onChange: (text) => {
                                // TODO OBJECT COORDINATES
                              },
                            ),

                            /// GENERAL CONTRACTOR SELECTION INPUT
                            SelectionInputWidget(
                                margin: const EdgeInsets.only(bottom: 10.0),
                                isVertical: true,
                                title: Titles.generalContractor,
                                value:
                                    _objectCreateViewModel.contractor?.name ??
                                        Titles.notSelected,
                                onTap: () => _objectCreateViewModel
                                    .showSearchCompanyScreenSheet(context, 0)),

                            /// DEVELOPER SELECTION INPUT
                            SelectionInputWidget(
                                margin: const EdgeInsets.only(bottom: 10.0),
                                isVertical: true,
                                title: Titles.developer,
                                value: Titles.notSelected,
                                onTap: () => _objectCreateViewModel
                                    .showSearchCompanyScreenSheet(context, 1)),

                            /// CUSTOMER SELECTION INPUT
                            SelectionInputWidget(
                                margin: const EdgeInsets.only(bottom: 10.0),
                                isVertical: true,
                                title: Titles.customer,
                                value: _objectCreateViewModel.customer?.name ??
                                    Titles.notSelected,
                                onTap: () => _objectCreateViewModel
                                    .showSearchCompanyScreenSheet(context, 2)),

                            /// DESIGNER SELECTION INPUT
                            SelectionInputWidget(
                                margin: const EdgeInsets.only(bottom: 10.0),
                                isVertical: true,
                                title: Titles.designer,
                                value: _objectCreateViewModel.designer?.name ??
                                    Titles.notSelected,
                                onTap: () => _objectCreateViewModel
                                    .showSearchCompanyScreenSheet(context, 3)),

                            /// TYPE SELECTION INPUT
                            SelectionInputWidget(
                                margin: const EdgeInsets.only(bottom: 10.0),
                                isVertical: true,
                                title: Titles.objectType,
                                value:
                                    _objectCreateViewModel.objectType?.name ??
                                        Titles.notSelected,
                                onTap: () => _objectCreateViewModel
                                    .showTypeSelectionScreenSheet(context)),

                            /// FLOOR COUNT INPUT
                            InputWidget(
                              textEditingController:
                                  _floorCountTextEditingController,
                              focusNode: _floorCountFocusNode,
                              textInputType: TextInputType.number,
                              margin: const EdgeInsets.only(bottom: 10.0),
                              height: 56.0,
                              placeholder: Titles.floorCount,
                              onTap: () => setState,
                              onChange: (text) => {
                                // TODO OBJECT FLOOR COUNT
                              },
                            ),

                            /// AREA INPUT
                            InputWidget(
                              textEditingController:
                                  _areaCountTextEditingController,
                              focusNode: _areaCountFocusNode,
                              textInputType: TextInputType.number,
                              margin: const EdgeInsets.only(bottom: 10.0),
                              height: 56.0,
                              placeholder: Titles.area,
                              onTap: () => setState,
                              onChange: (text) => {
                                // TODO OBJECT AREA
                              },
                            ),

                            /// BUILDING TIME INPUT
                            InputWidget(
                              textEditingController:
                                  _buildingTimeTextEditingController,
                              focusNode: _buildingTimeFocusNode,
                              textInputType: TextInputType.number,
                              margin: const EdgeInsets.only(bottom: 10.0),
                              height: 56.0,
                              placeholder: Titles.buildingTime,
                              onTap: () => setState,
                              onChange: (text) => {
                                // TODO OBJECT BUILDING TIME
                              },
                            ),

                            /// STAGES BUTTON
                            SelectionInputWidget(
                                margin: const EdgeInsets.only(bottom: 30.0),
                                isVertical: true,
                                title: Titles.stage,
                                value:
                                    _objectCreateViewModel.objectStage?.name ??
                                        Titles.notSelected,
                                onTap: () => _objectCreateViewModel
                                    .showStageSelectionScreenSheet(context)),

                            /// KISO CHECKBOX
                            GestureDetector(
                                child: Row(children: [
                                  CheckBoxWidget(
                                      isSelected:
                                          _objectCreateViewModel.isKiso),
                                  const SizedBox(width: 8.0),
                                  Text(Titles.kiso,
                                      style: TextStyle(
                                          color: HexColors.black,
                                          fontSize: 16.0,
                                          fontFamily: 'PT Root UI'))
                                ]),
                                onTap: () =>
                                    _objectCreateViewModel.checkKiso()),

                            /// KISO INPUT
                            _objectCreateViewModel.isKiso
                                ? InputWidget(
                                    textEditingController:
                                        _kisoTextEditingController,
                                    focusNode: _kisoFocusNode,
                                    textInputType: TextInputType.number,
                                    margin: const EdgeInsets.only(
                                        top: 20.0, bottom: 30.0),
                                    height: 56.0,
                                    placeholder: Titles.kisoDocumentNumber,
                                    onTap: () => setState,
                                    onChange: (text) => {
                                          // TODO OBJECT KISO
                                        })
                                : const SizedBox(height: 30.0),

                            /// CREATE FOLDER CHECKBOX
                            GestureDetector(
                                child: Row(children: [
                                  CheckBoxWidget(
                                      isSelected: _objectCreateViewModel
                                          .isCreateFolder),
                                  const SizedBox(width: 8.0),
                                  Text(Titles.createObjectFolder,
                                      style: TextStyle(
                                          color: HexColors.black,
                                          fontSize: 16.0,
                                          fontFamily: 'PT Root UI'))
                                ]),
                                onTap: () =>
                                    _objectCreateViewModel.checkCreateFolder()),
                            const SizedBox(height: 30.0),

                            /// FILE LIST
                            ListView.builder(
                                shrinkWrap: true,
                                padding: EdgeInsets.zero,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: _objectCreateViewModel.object == null
                                    ? _objectCreateViewModel.files.length
                                    : _objectCreateViewModel
                                        .object!.files.length,
                                itemBuilder: (context, index) {
                                  return IgnorePointer(
                                      ignoring: _objectCreateViewModel.downloadIndex !=
                                          -1,
                                      child: FileListItemWidget(
                                          fileName: _objectCreateViewModel.object == null
                                              ? _objectCreateViewModel.files[index].path.substring(
                                                  _objectCreateViewModel
                                                          .files[index]
                                                          .path
                                                          .length -
                                                      10,
                                                  _objectCreateViewModel
                                                      .files[index].path.length)
                                              : _objectCreateViewModel
                                                  .object!.files[index].name,
                                          isDownloading:
                                              _objectCreateViewModel.downloadIndex ==
                                                  index,
                                          onTap: () => _objectCreateViewModel
                                              .openFile(context, index),
                                          onRemoveTap: () => _objectCreateViewModel
                                              .deleteObjectFile(context, index)));
                                }),

                            /// ADD FILE BUTTON
                            BorderButtonWidget(
                                title: Titles.addFile,
                                margin: const EdgeInsets.only(bottom: 30.0),
                                onTap: () => _objectCreateViewModel.addFile()),
                          ])),

                  /// CREATE TASK BUTTON
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: ButtonWidget(
                          isDisabled: true,
                          title: widget.object == null
                              ? Titles.createObject
                              : Titles.save,
                          margin: EdgeInsets.only(
                              left: 16.0,
                              right: 16.0,
                              bottom:
                                  MediaQuery.of(context).padding.bottom == 0.0
                                      ? 20.0
                                      : MediaQuery.of(context).padding.bottom),
                          onTap: () => _objectCreateViewModel.object == null
                              ? _objectCreateViewModel.createNewObject(
                                  context,
                                  _addressTextEditingController.text,
                                  int.tryParse(
                                      _areaCountTextEditingController.text),
                                  int.tryParse(
                                      _buildingTimeTextEditingController.text),
                                  int.tryParse(
                                      _floorCountTextEditingController.text),
                                  (double.tryParse(
                                      _coordinatesTextEditingController.text
                                          .split(', ')[0]))!,
                                  (double.tryParse(
                                      _coordinatesTextEditingController.text
                                          .split(', ')[1]))!,
                                  _nameTextEditingController.text,
                                  (object) => {
                                        if (mounted)
                                          {
                                            Navigator.pushAndRemoveUntil(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ObjectPageViewScreenWidget(
                                                            object: object)),
                                                (route) => false)
                                          }
                                      })
                              : _objectCreateViewModel.editObject(
                                  context,
                                  _addressTextEditingController.text,
                                  int.tryParse(
                                      _areaCountTextEditingController.text),
                                  int.tryParse(
                                      _buildingTimeTextEditingController.text),
                                  int.tryParse(_floorCountTextEditingController.text),
                                  (double.tryParse(_coordinatesTextEditingController.text.split(', ')[0]))!,
                                  (double.tryParse(_coordinatesTextEditingController.text.split(', ')[1]))!,
                                  _nameTextEditingController.text,
                                  (object) => {
                                        if (mounted)
                                          {
                                            widget.onUpdate(object),
                                            Navigator.pop(context)
                                          }
                                      }))),
                  const SeparatorWidget(),

                  /// INDICATOR
                  _objectCreateViewModel.loadingStatus ==
                          LoadingStatus.searching
                      ? const LoadingIndicatorWidget()
                      : Container()
                ]))));
  }
}
