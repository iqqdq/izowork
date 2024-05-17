import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:izowork/components/components.dart';
import 'package:izowork/models/models.dart';
import 'package:izowork/notifiers/domain.dart';
import 'package:izowork/screens/object/object_page_view_screen.dart';
import 'package:izowork/views/views.dart';
import 'package:provider/provider.dart';

class ObjectCreateScreenBodyWidget extends StatefulWidget {
  final String? address;
  final double? lat;
  final double? long;
  final Function(MapObject?) onPop;

  const ObjectCreateScreenBodyWidget({
    Key? key,
    this.address,
    this.lat,
    this.long,
    required this.onPop,
  }) : super(key: key);

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
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_objectCreateViewModel.object != null) {
        _nameTextEditingController.text = _objectCreateViewModel.object!.name;

        _addressTextEditingController.text =
            _objectCreateViewModel.object!.address;

        _coordinatesTextEditingController.text = _objectCreateViewModel
                    .object?.lat ==
                null
            ? ''
            : '${_objectCreateViewModel.object?.lat}, ${_objectCreateViewModel.object?.long}';

        _floorCountTextEditingController.text =
            _objectCreateViewModel.object!.floors.toString();

        _areaCountTextEditingController.text =
            _objectCreateViewModel.object!.area.toString();

        _buildingTimeTextEditingController.text =
            _buildingTimeTextEditingController.text.isEmpty
                ? _objectCreateViewModel.object!.constructionPeriod.toString()
                : _buildingTimeTextEditingController.text;

        _kisoTextEditingController.text =
            _objectCreateViewModel.object!.kiso ?? '';
      } else {
        _addressTextEditingController.text = widget.address ?? '';

        _coordinatesTextEditingController.text =
            widget.lat == null || widget.long == null
                ? ''
                : '${widget.lat}, ${widget.long}';
      }
    });
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

    _kisoTextEditingController.dispose();
    _kisoFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _objectCreateViewModel = Provider.of<ObjectCreateViewModel>(
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
                child: BackButtonWidget(onTap: () => Navigator.pop(context))),
            title: Text(
                _objectCreateViewModel.object == null
                    ? Titles.newObject
                    : Titles.editObject,
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
                                textEditingController:
                                    _nameTextEditingController,
                                focusNode: _nameFocusNode,
                                margin: const EdgeInsets.only(bottom: 10.0),
                                height: 56.0,
                                placeholder: '${Titles.objectName}*',
                                onTap: () => setState(() {}),
                                onChange: (text) => setState(() {}),
                                onEditingComplete: () => setState(() {})),

                            /// ADDRESS INPUT
                            InputWidget(
                                textEditingController:
                                    _addressTextEditingController,
                                focusNode: _addressFocusNode,
                                margin: const EdgeInsets.only(bottom: 10.0),
                                height: 56.0,
                                placeholder: '${Titles.address}*',
                                onTap: () => setState(() {}),
                                onChange: (text) => setState(() {}),
                                onEditingComplete: () => setState(() {})),

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
                                placeholder: '${Titles.coordinates}*',
                                onTap: () => setState(() {}),
                                onChange: (text) => setState(() {}),
                                onEditingComplete: () => setState(() {})),

                            /// TECHNICAL MANAGER SELECTION INPUT
                            SelectionInputWidget(
                                margin: const EdgeInsets.only(bottom: 10.0),
                                isVertical: true,
                                title: Titles.techManager,
                                value:
                                    _objectCreateViewModel.techManager?.name ??
                                        _objectCreateViewModel
                                            .object?.techManager?.name ??
                                        Titles.notSelected,
                                onTap: () => _objectCreateViewModel
                                    .showSearchUserSheet(context, 0)),

                            /// OFFICE SELECTION INPUT
                            SelectionInputWidget(
                                margin: const EdgeInsets.only(bottom: 10.0),
                                isVertical: true,
                                title: Titles.filial,
                                value: _objectCreateViewModel.office?.name ??
                                    // _objectCreateViewModel
                                    //     .object?.office?.name ??
                                    Titles.notSelected,
                                onTap: () => _objectCreateViewModel
                                    .showSearchOfficeSheet(context)),

                            /// MANAGER SELECTION INPUT
                            SelectionInputWidget(
                                margin: const EdgeInsets.only(bottom: 10.0),
                                isVertical: true,
                                title: Titles.manager,
                                value: _objectCreateViewModel.manager?.name ??
                                    _objectCreateViewModel
                                        .object?.manager?.name ??
                                    Titles.notSelected,
                                onTap: () => _objectCreateViewModel
                                    .showSearchUserSheet(context, 1)),

                            /// GENERAL CONTRACTOR SELECTION INPUT
                            SelectionInputWidget(
                                margin: const EdgeInsets.only(bottom: 10.0),
                                isVertical: true,
                                title: Titles.generalContractor,
                                value:
                                    _objectCreateViewModel.contractor?.name ??
                                        _objectCreateViewModel
                                            .object?.contractor?.name ??
                                        Titles.notSelected,
                                onTap: () => _objectCreateViewModel
                                    .showSearchCompanySheet(context, 0)),

                            /// CUSTOMER SELECTION INPUT
                            SelectionInputWidget(
                                margin: const EdgeInsets.only(bottom: 10.0),
                                isVertical: true,
                                title: Titles.customer,
                                value: _objectCreateViewModel.customer?.name ??
                                    _objectCreateViewModel
                                        .object?.customer?.name ??
                                    Titles.notSelected,
                                onTap: () => _objectCreateViewModel
                                    .showSearchCompanySheet(context, 2)),

                            /// DESIGNER SELECTION INPUT
                            SelectionInputWidget(
                                margin: const EdgeInsets.only(bottom: 10.0),
                                isVertical: true,
                                title: Titles.designer,
                                value: _objectCreateViewModel.designer?.name ??
                                    _objectCreateViewModel
                                        .object?.designer?.name ??
                                    Titles.notSelected,
                                onTap: () => _objectCreateViewModel
                                    .showSearchCompanySheet(context, 3)),

                            /// TYPE SELECTION INPUT
                            SelectionInputWidget(
                                margin: const EdgeInsets.only(bottom: 10.0),
                                isVertical: true,
                                title: '${Titles.objectType}*',
                                value:
                                    _objectCreateViewModel.objectType?.name ??
                                        Titles.notSelected,
                                onTap: () => _objectCreateViewModel
                                    .showTypeSelectionSheet(context)),

                            /// FLOOR COUNT INPUT
                            InputWidget(
                                textEditingController:
                                    _floorCountTextEditingController,
                                focusNode: _floorCountFocusNode,
                                textInputType: TextInputType.number,
                                margin: const EdgeInsets.only(bottom: 10.0),
                                height: 56.0,
                                placeholder: Titles.floorCount,
                                onTap: () => setState(() {}),
                                onChange: (text) => setState(() {}),
                                onEditingComplete: () => setState(() {})),

                            /// AREA INPUT
                            InputWidget(
                                textEditingController:
                                    _areaCountTextEditingController,
                                focusNode: _areaCountFocusNode,
                                textInputType: TextInputType.number,
                                margin: const EdgeInsets.only(bottom: 10.0),
                                height: 56.0,
                                placeholder: Titles.area,
                                onTap: () => setState(() {}),
                                onChange: (text) => setState(() {}),
                                onEditingComplete: () => setState(() {})),

                            /// BUILDING TIME INPUT
                            InputWidget(
                                textEditingController:
                                    _buildingTimeTextEditingController,
                                focusNode: _buildingTimeFocusNode,
                                textInputType: TextInputType.number,
                                margin: const EdgeInsets.only(bottom: 10.0),
                                height: 56.0,
                                placeholder: Titles.buildingTime,
                                onTap: () => setState(() {}),
                                onChange: (text) => setState(() {}),
                                onEditingComplete: () => setState(() {})),

                            /// STAGES BUTTON
                            SelectionInputWidget(
                                margin: const EdgeInsets.only(bottom: 20.0),
                                isVertical: true,
                                title: '${Titles.stage}*',
                                value:
                                    _objectCreateViewModel.objectStage?.name ??
                                        Titles.notSelected,
                                onTap: () => _objectCreateViewModel
                                    .showStageSelectionSheet(context)),

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
                                        top: 20.0, bottom: 20.0),
                                    height: 56.0,
                                    placeholder: Titles.kisoDocumentNumber,
                                    onTap: () => setState(() {}),
                                    onChange: (text) => setState(() {}),
                                    onEditingComplete: () => setState(() {}))
                                : const SizedBox(height: 30.0),

                            /// CREATE FOLDER CHECKBOX
                            GestureDetector(
                                child: Row(children: [
                                  CheckBoxWidget(
                                      isSelected:
                                          !_objectCreateViewModel.hideDir),
                                  const SizedBox(width: 8.0),
                                  Text(Titles.createObjectFolder,
                                      style: TextStyle(
                                          color: HexColors.black,
                                          fontSize: 16.0,
                                          fontFamily: 'PT Root UI'))
                                ]),
                                onTap: () =>
                                    _objectCreateViewModel.checkCreateFolder()),
                            const SizedBox(height: 24.0),

                            /// FILE LIST
                            ListView.builder(
                                shrinkWrap: true,
                                padding: EdgeInsets.zero,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: _objectCreateViewModel.object == null
                                    ? _objectCreateViewModel.files.length
                                    : _objectCreateViewModel.documents.length,
                                itemBuilder: (context, index) {
                                  return IgnorePointer(
                                      key: ValueKey(
                                          _objectCreateViewModel.object == null
                                              ? _objectCreateViewModel
                                                  .files[index].path
                                              : _objectCreateViewModel
                                                  .documents[index].id),
                                      ignoring: _objectCreateViewModel
                                              .downloadIndex !=
                                          -1,
                                      child: FileListItemWidget(
                                          fileName: _objectCreateViewModel
                                                      .object ==
                                                  null
                                              ? _objectCreateViewModel
                                                  .files[index].path
                                                  .substring(
                                                  _objectCreateViewModel
                                                          .files[index]
                                                          .path
                                                          .length -
                                                      10,
                                                  _objectCreateViewModel
                                                      .files[index].path.length,
                                                )
                                              : _objectCreateViewModel
                                                  .documents[index].name,
                                          isDownloading: _objectCreateViewModel
                                                  .downloadIndex ==
                                              index,
                                          onTap: () =>
                                              _objectCreateViewModel.openFile(
                                                context,
                                                index,
                                              ),
                                          onRemoveTap: () =>
                                              _objectCreateViewModel
                                                  .deleteObjectFile(
                                                context,
                                                index,
                                              )));
                                }),

                            /// ADD IMAGE BUTTON
                            BorderButtonWidget(
                                title: Titles.addImage,
                                margin: const EdgeInsets.only(bottom: 30.0),
                                onTap: () =>
                                    _objectCreateViewModel.addFile(context)),
                          ])),

                  /// CREATE TASK BUTTON
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: ButtonWidget(
                        isDisabled: _nameTextEditingController.text.isEmpty ||
                            _addressTextEditingController.text.isEmpty ||
                            !_coordinatesTextEditingController.text
                                .contains(',') ||
                            _objectCreateViewModel.objectType == null ||
                            _objectCreateViewModel.objectStage == null,
                        title: _objectCreateViewModel.object == null
                            ? Titles.createObject
                            : Titles.save,
                        margin: EdgeInsets.only(
                            left: 16.0,
                            right: 16.0,
                            bottom: MediaQuery.of(context).padding.bottom == 0.0
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
                                _coordinatesTextEditingController.text,
                                _nameTextEditingController.text,
                                _kisoTextEditingController.text,
                                (object) => {
                                  /// SHOW CREATED OBJECT
                                  if (mounted)
                                    {
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ObjectPageViewScreenWidget(
                                                      id: object.id)))
                                    }
                                },
                              )
                            : _objectCreateViewModel.editObject(
                                context,
                                _addressTextEditingController.text,
                                int.tryParse(
                                    _areaCountTextEditingController.text),
                                int.tryParse(
                                    _buildingTimeTextEditingController.text),
                                int.tryParse(
                                    _floorCountTextEditingController.text),
                                _coordinatesTextEditingController.text,
                                _nameTextEditingController.text,
                                _kisoTextEditingController.text,
                                (object) => {
                                  if (mounted)
                                    {
                                      widget.onPop(object),
                                      Navigator.pop(context)
                                    }
                                },
                              )),
                  ),
                  const SeparatorWidget(),

                  /// INDICATOR
                  _objectCreateViewModel.loadingStatus ==
                          LoadingStatus.searching
                      ? const Padding(
                          padding: EdgeInsets.only(bottom: 60.0),
                          child: LoadingIndicatorWidget())
                      : Container()
                ]))));
  }
}
