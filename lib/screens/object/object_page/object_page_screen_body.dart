import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/loading_status.dart';
import 'package:izowork/components/titles.dart';
import 'package:izowork/entities/response/object.dart';
import 'package:izowork/models/object_view_model.dart';
import 'package:izowork/screens/object/object_page/views/object_stage_header_widget.dart';
import 'package:izowork/screens/object/object_page/views/object_stage_list_item_widget.dart';
import 'package:izowork/views/border_button_widget.dart';
import 'package:izowork/views/button_widget.dart';
import 'package:izowork/views/file_list_widget.dart';
import 'package:izowork/views/loading_indicator_widget.dart';
import 'package:izowork/views/selection_input_widget.dart';
import 'package:izowork/views/separator_widget.dart';
import 'package:izowork/views/subtitle_widget.dart';
import 'package:izowork/views/title_widget.dart';
import 'package:provider/provider.dart';

class ObjectPageScreenBodyWidget extends StatefulWidget {
  final VoidCallback onCoordCopy;
  final Function(Object) onUpdate;

  const ObjectPageScreenBodyWidget(
      {Key? key, required this.onCoordCopy, required this.onUpdate})
      : super(key: key);

  @override
  _ObjectPageScreenBodyState createState() => _ObjectPageScreenBodyState();
}

class _ObjectPageScreenBodyState extends State<ObjectPageScreenBodyWidget>
    with AutomaticKeepAliveClientMixin {
  late ObjectPageViewModel _objectPageViewModel;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    _objectPageViewModel =
        Provider.of<ObjectPageViewModel>(context, listen: true);

    String _kiso = _objectPageViewModel.object?.kiso ??
        _objectPageViewModel.selectedObject.kiso ??
        '';

    return Scaffold(
        backgroundColor: HexColors.white,
        body: Material(
            type: MaterialType.transparency,
            child: Container(
                color: HexColors.white,
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
                        ///  NAME
                        const TitleWidget(
                            padding: EdgeInsets.only(bottom: 4.0),
                            text: Titles.objectName,
                            isSmall: true),
                        SubtitleWidget(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            text: _objectPageViewModel.object?.name ??
                                _objectPageViewModel.selectedObject.name),

                        /// ADDRESS
                        const TitleWidget(
                            padding: EdgeInsets.only(bottom: 4.0),
                            text: Titles.address,
                            isSmall: true),
                        SubtitleWidget(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            text: _objectPageViewModel.object?.address ??
                                _objectPageViewModel.selectedObject.address),

                        Row(children: [
                          Expanded(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                /// COORDINATES
                                const TitleWidget(
                                    padding: EdgeInsets.only(bottom: 4.0),
                                    text: Titles.coordinates,
                                    isSmall: true),

                                GestureDetector(
                                    onLongPress: () => _objectPageViewModel
                                        .copyCoordinates(
                                            context,
                                            _objectPageViewModel.object?.lat ??
                                                _objectPageViewModel
                                                    .selectedObject.lat,
                                            _objectPageViewModel.object?.long ??
                                                _objectPageViewModel
                                                    .selectedObject.long)
                                        .then((value) => widget.onCoordCopy()),
                                    child: SubtitleWidget(
                                        padding:
                                            const EdgeInsets.only(bottom: 16.0),
                                        text: _objectPageViewModel.object ==
                                                null
                                            ? '${_objectPageViewModel.selectedObject.lat}, ${_objectPageViewModel.selectedObject.long}'
                                            : '${_objectPageViewModel.object?.lat}, ${_objectPageViewModel.object?.long}'))
                              ])),
                          GestureDetector(
                              onTap: () => _objectPageViewModel
                                  .showSingleObjectMap(context),
                              child: SvgPicture.asset('assets/ic_map.svg',
                                  color: HexColors.primaryMain))
                        ]),

                        /// TECHNICAL MANAGER
                        const TitleWidget(
                            padding: EdgeInsets.only(bottom: 4.0),
                            text: Titles.techManager,
                            isSmall: true),
                        SubtitleWidget(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            text: _objectPageViewModel
                                    .object?.techManager?.name ??
                                '-'),

                        /// MANAGER
                        const TitleWidget(
                            padding: EdgeInsets.only(bottom: 4.0),
                            text: Titles.manager,
                            isSmall: true),
                        SubtitleWidget(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            text: _objectPageViewModel.object?.manager?.name ??
                                '-'),

                        /// GENERAL CONTRACTOR
                        const TitleWidget(
                            padding: EdgeInsets.only(bottom: 4.0),
                            text: Titles.generalContractor,
                            isSmall: true),
                        SubtitleWidget(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            text:
                                _objectPageViewModel.object?.contractor?.name ??
                                    '-'),

                        /// CUSTOMER
                        const TitleWidget(
                            padding: EdgeInsets.only(bottom: 4.0),
                            text: Titles.customer,
                            isSmall: true),
                        SubtitleWidget(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            text: _objectPageViewModel.object?.customer?.name ??
                                '-'),

                        /// DEGISNER
                        const TitleWidget(
                            padding: EdgeInsets.only(bottom: 4.0),
                            text: Titles.designer,
                            isSmall: true),
                        SubtitleWidget(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            text: _objectPageViewModel.object?.designer?.name ??
                                '-'),

                        /// TYPE
                        const TitleWidget(
                            padding: EdgeInsets.only(bottom: 4.0),
                            text: Titles.objectType,
                            isSmall: true),
                        SubtitleWidget(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            text:
                                _objectPageViewModel.object?.objectType?.name ??
                                    _objectPageViewModel
                                        .selectedObject.objectType?.name ??
                                    '-'),

                        /// FLOOR COUNT
                        const TitleWidget(
                            padding: EdgeInsets.only(bottom: 4.0),
                            text: Titles.floorCount,
                            isSmall: true),
                        SubtitleWidget(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            text: _objectPageViewModel.object?.floors
                                    .toString() ??
                                _objectPageViewModel.selectedObject.floors
                                    .toString()),

                        /// AREA
                        const TitleWidget(
                            padding: EdgeInsets.only(bottom: 4.0),
                            text: Titles.area,
                            isSmall: true),
                        SubtitleWidget(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            text:
                                _objectPageViewModel.object?.area.toString() ??
                                    _objectPageViewModel.selectedObject.area
                                        .toString()),

                        /// BUILDING TIME
                        const TitleWidget(
                            padding: EdgeInsets.only(bottom: 4.0),
                            text: Titles.buildingTime,
                            isSmall: true),
                        const SubtitleWidget(
                            padding: EdgeInsets.only(bottom: 16.0), text: '15'),

                        /// STAGE
                        const TitleWidget(
                            padding: EdgeInsets.only(bottom: 4.0),
                            text: Titles.stages,
                            isSmall: true),
                        SubtitleWidget(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            text: _objectPageViewModel
                                    .object?.objectStage?.name ??
                                _objectPageViewModel
                                    .selectedObject.objectStage?.name ??
                                '-'),

                        /// KISO
                        const TitleWidget(
                            padding: EdgeInsets.only(bottom: 4.0),
                            text: Titles.kiso,
                            isSmall: true),
                        SubtitleWidget(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            text: _kiso.isEmpty ? '-' : _kiso),

                        /// FILE LIST
                        _objectPageViewModel.selectedObject.files.isEmpty
                            ? Container()
                            : const TitleWidget(
                                padding: EdgeInsets.only(bottom: 10.0),
                                text: Titles.files,
                                isSmall: true),

                        ListView.builder(
                            shrinkWrap: true,
                            padding: const EdgeInsets.only(bottom: 10.0),
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount:
                                _objectPageViewModel.object?.files.length ??
                                    _objectPageViewModel
                                        .selectedObject.files.length,
                            itemBuilder: (context, index) {
                              return FileListItemWidget(
                                  fileName: _objectPageViewModel
                                          .object?.files[index].name ??
                                      _objectPageViewModel
                                          .selectedObject.files[index].name,
                                  isDownloading:
                                      _objectPageViewModel.downloadIndex ==
                                          index,
                                  onTap: () => _objectPageViewModel.openFile(
                                      context, index));
                            }),

                        /// PHASES TABLE
                        Container(
                            decoration: BoxDecoration(
                                color: HexColors.white,
                                borderRadius: BorderRadius.circular(16.0),
                                border: Border.all(
                                    width: 1.0, color: HexColors.grey20)),
                            child: ListView(
                                physics: const NeverScrollableScrollPhysics(),
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                children: [
                                  const ObjectStageHeaderWidget(),
                                  const SizedBox(height: 10.0),
                                  const SeparatorWidget(),
                                  _objectPageViewModel.phases.isEmpty
                                      ? const SizedBox(
                                          height: 400.0,
                                          child: LoadingIndicatorWidget())
                                      : ListView.builder(
                                          shrinkWrap: true,
                                          padding: EdgeInsets.zero,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemCount: _objectPageViewModel
                                              .phases.length,
                                          itemBuilder: (context, index) {
                                            return ObjectStageListItemWidget(
                                                title: _objectPageViewModel
                                                    .phases[index].name,
                                                effectivenes:
                                                    _objectPageViewModel
                                                        .phases[index]
                                                        .efficiency,
                                                readiness: _objectPageViewModel
                                                    .phases[index].readiness,
                                                showSeparator: index <
                                                    _objectPageViewModel
                                                            .phases.length -
                                                        1,
                                                onTap: () =>
                                                    _objectPageViewModel
                                                        .showPhaseScreen(
                                                            context, index));
                                          })
                                ])),
                        const SizedBox(height: 20.0),

                        /// DOCUMENTS BUTTON
                        SelectionInputWidget(
                            margin: const EdgeInsets.only(bottom: 10.0),
                            title: '',
                            value: Titles.documents,
                            onTap: () => _objectPageViewModel
                                .showDocumentsScreen(context)),

                        /// ANALYTICS BUTTON
                        SelectionInputWidget(
                            margin: const EdgeInsets.only(bottom: 20.0),
                            title: '',
                            value: Titles.analytics,
                            onTap: () => _objectPageViewModel
                                .showObjectAnalyticsPageViewScreen(context)),

                        /// SHOW CHAT BUTTON
                        _objectPageViewModel.object?.chat == null
                            ? Container()
                            : BorderButtonWidget(
                                title: Titles.goChat,
                                margin: const EdgeInsets.only(bottom: 30.0),
                                onTap: () => _objectPageViewModel
                                    .showDialogScreen(context)),
                      ]),

                  Align(
                      alignment: Alignment.bottomCenter,
                      child:

                          /// EDIT TASK BUTTON
                          ButtonWidget(
                              title: Titles.edit,
                              margin: EdgeInsets.only(
                                  right: 16.0,
                                  left: 16.0,
                                  // left: 4.0,
                                  bottom: MediaQuery.of(context)
                                              .padding
                                              .bottom ==
                                          0.0
                                      ? 20.0
                                      : MediaQuery.of(context).padding.bottom),
                              onTap: () =>
                                  _objectPageViewModel.showObjectCreateSheet(
                                      context,
                                      () => widget.onUpdate(
                                          _objectPageViewModel.object!)))),
                  const SeparatorWidget(),

                  /// INDICATOR
                  _objectPageViewModel.loadingStatus == LoadingStatus.searching
                      ? const Padding(
                          padding: EdgeInsets.only(bottom: 90.0),
                          child: LoadingIndicatorWidget())
                      : Container()
                ]))));
  }
}
