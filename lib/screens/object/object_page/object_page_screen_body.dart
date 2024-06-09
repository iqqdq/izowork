import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:izowork/components/components.dart';
import 'package:izowork/models/models.dart';
import 'package:izowork/notifiers/notifiers.dart';
import 'package:izowork/screens/dialog/dialog_screen.dart';
import 'package:izowork/screens/documents/documents_screen.dart';
import 'package:izowork/screens/object/object_page/views/object_stage_header_widget.dart';
import 'package:izowork/screens/object/object_page/views/object_stage_list_item_widget.dart';
import 'package:izowork/screens/object_analytics/object_analytics_screen.dart';
import 'package:izowork/screens/object_create/object_create_screen.dart';
import 'package:izowork/screens/phase/phase_screen.dart';
import 'package:izowork/screens/single_object_map/single_object_map_screen.dart';
import 'package:izowork/views/views.dart';
import 'package:provider/provider.dart';

class ObjectPageScreenBodyWidget extends StatefulWidget {
  final String? phaseId;
  final Function(MapObject?) onPop;

  const ObjectPageScreenBodyWidget({
    Key? key,
    this.phaseId,
    required this.onPop,
  }) : super(key: key);

  @override
  _ObjectPageScreenBodyState createState() => _ObjectPageScreenBodyState();
}

class _ObjectPageScreenBodyState extends State<ObjectPageScreenBodyWidget>
    with AutomaticKeepAliveClientMixin {
  late ObjectPageViewModel _objectPageViewModel;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    // PUSH FROM NOTIFICATION's SCREEN
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (widget.phaseId == null) return;

      if (mounted) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PhaseScreenWidget(
                      id: widget.phaseId!,
                    ))).whenComplete(() => _objectPageViewModel.getPhaseList());
      }
    });
  }

  @override
  void dispose() {
    widget.onPop(_objectPageViewModel.object);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    _objectPageViewModel = Provider.of<ObjectPageViewModel>(
      context,
      listen: true,
    );

    String _kiso = _objectPageViewModel.object?.kiso ?? '';

    return Scaffold(
      backgroundColor: HexColors.white,
      body: _objectPageViewModel.object == null
          ? const LoadingIndicatorWidget()
          : Material(
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
                            ? 74.0
                            : MediaQuery.of(context).padding.bottom + 54.0,
                      ),
                      children: [
                        ///  NAME
                        const TitleWidget(
                          padding: EdgeInsets.only(bottom: 4.0),
                          text: Titles.objectName,
                          isSmall: true,
                        ),
                        SubtitleWidget(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          text: _objectPageViewModel.object?.name ?? '',
                        ),

                        /// ADDRESS
                        const TitleWidget(
                          padding: EdgeInsets.only(bottom: 4.0),
                          text: Titles.address,
                          isSmall: true,
                        ),
                        SubtitleWidget(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          text: _objectPageViewModel.object?.address ?? '',
                        ),

                        Row(children: [
                          Expanded(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  /// COORDINATES
                                  const TitleWidget(
                                    padding: EdgeInsets.only(bottom: 4.0),
                                    text: Titles.coordinates,
                                    isSmall: true,
                                  ),

                                  _objectPageViewModel.object == null
                                      ? Container()
                                      : SubtitleWidget(
                                          padding: const EdgeInsets.only(
                                              bottom: 16.0),
                                          text:
                                              '${_objectPageViewModel.object!.lat}, ${_objectPageViewModel.object!.long}',
                                        )
                                ]),
                          ),
                          GestureDetector(
                              onTap: () => _showObjectOnMap(),
                              child: SvgPicture.asset(
                                'assets/ic_map.svg',
                                colorFilter: ColorFilter.mode(
                                  HexColors.primaryMain,
                                  BlendMode.srcIn,
                                ),
                              ))
                        ]),

                        /// TECHNICAL MANAGER
                        const TitleWidget(
                          padding: EdgeInsets.only(bottom: 4.0),
                          text: Titles.techManager,
                          isSmall: true,
                        ),
                        SubtitleWidget(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          text:
                              _objectPageViewModel.object?.techManager?.name ??
                                  '-',
                        ),

                        /// OFFICE
                        const TitleWidget(
                          padding: EdgeInsets.only(bottom: 4.0),
                          text: Titles.filial,
                          isSmall: true,
                        ),
                        SubtitleWidget(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          text:
                              _objectPageViewModel.object?.office?.name ?? '-',
                        ),

                        /// MANAGER
                        const TitleWidget(
                          padding: EdgeInsets.only(bottom: 4.0),
                          text: Titles.manager,
                          isSmall: true,
                        ),
                        SubtitleWidget(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          text:
                              _objectPageViewModel.object?.manager?.name ?? '-',
                        ),

                        /// GENERAL CONTRACTOR
                        const TitleWidget(
                          padding: EdgeInsets.only(bottom: 4.0),
                          text: Titles.generalContractor,
                          isSmall: true,
                        ),
                        SubtitleWidget(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          text: _objectPageViewModel.object?.contractor?.name ??
                              '-',
                        ),

                        /// CUSTOMER
                        const TitleWidget(
                          padding: EdgeInsets.only(bottom: 4.0),
                          text: Titles.customer,
                          isSmall: true,
                        ),
                        SubtitleWidget(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          text: _objectPageViewModel.object?.customer?.name ??
                              '-',
                        ),

                        /// DEGISNER
                        const TitleWidget(
                          padding: EdgeInsets.only(bottom: 4.0),
                          text: Titles.designer,
                          isSmall: true,
                        ),
                        SubtitleWidget(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          text: _objectPageViewModel.object?.designer?.name ??
                              '-',
                        ),

                        /// TYPE
                        const TitleWidget(
                          padding: EdgeInsets.only(bottom: 4.0),
                          text: Titles.objectType,
                          isSmall: true,
                        ),
                        SubtitleWidget(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          text: _objectPageViewModel.object?.objectType?.name ??
                              '-',
                        ),

                        /// FLOOR COUNT
                        const TitleWidget(
                          padding: EdgeInsets.only(bottom: 4.0),
                          text: Titles.floorCount,
                          isSmall: true,
                        ),
                        SubtitleWidget(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          text:
                              _objectPageViewModel.object?.floors.toString() ??
                                  '-',
                        ),

                        /// AREA
                        const TitleWidget(
                          padding: EdgeInsets.only(bottom: 4.0),
                          text: Titles.area,
                          isSmall: true,
                        ),
                        SubtitleWidget(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          text: _objectPageViewModel.object?.area.toString() ??
                              '-',
                        ),

                        /// BUILDING TIME
                        const TitleWidget(
                          padding: EdgeInsets.only(bottom: 4.0),
                          text: Titles.buildingTime,
                          isSmall: true,
                        ),
                        SubtitleWidget(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          text: _objectPageViewModel.object?.constructionPeriod
                                  ?.toString() ??
                              '-',
                        ),

                        /// STAGE
                        const TitleWidget(
                          padding: EdgeInsets.only(bottom: 4.0),
                          text: Titles.stages,
                          isSmall: true,
                        ),
                        SubtitleWidget(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          text:
                              _objectPageViewModel.object?.objectStage?.name ??
                                  '-',
                        ),

                        /// KISO
                        const TitleWidget(
                          padding: EdgeInsets.only(bottom: 4.0),
                          text: Titles.kiso,
                          isSmall: true,
                        ),
                        SubtitleWidget(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          text: _kiso.isEmpty ? '-' : _kiso,
                        ),

                        /// FILE LIST
                        _objectPageViewModel.object == null
                            ? Container()
                            : _objectPageViewModel.object!.files.isEmpty
                                ? Container()
                                : const TitleWidget(
                                    padding: EdgeInsets.only(bottom: 10.0),
                                    text: Titles.files,
                                    isSmall: true,
                                  ),

                        ListView.builder(
                            shrinkWrap: true,
                            padding: const EdgeInsets.only(bottom: 10.0),
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount:
                                _objectPageViewModel.object?.files.length ?? 0,
                            itemBuilder: (context, index) {
                              return FileListItemWidget(
                                  key: ValueKey(_objectPageViewModel
                                      .object?.files[index].id),
                                  fileName: _objectPageViewModel
                                          .object?.files[index].name ??
                                      '',
                                  isDownloading:
                                      _objectPageViewModel.downloadIndex ==
                                          index,
                                  onTap: () =>
                                      _objectPageViewModel.openFile(index));
                            }),

                        /// PHASE LIST
                        Container(
                            decoration: BoxDecoration(
                                color: HexColors.white,
                                borderRadius: BorderRadius.circular(16.0),
                                border: Border.all(
                                  width: 1.0,
                                  color: HexColors.grey20,
                                )),
                            child: ListView(
                                physics: const NeverScrollableScrollPhysics(),
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                children: [
                                  const ObjectStageHeaderWidget(),
                                  const SizedBox(height: 10.0),
                                  const SeparatorWidget(),
                                  ListView.builder(
                                      shrinkWrap: true,
                                      padding: EdgeInsets.zero,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount:
                                          _objectPageViewModel.phases.length,
                                      itemBuilder: (context, index) {
                                        var phase =
                                            _objectPageViewModel.phases[index];

                                        return ObjectStageListItemWidget(
                                          key: ValueKey(phase.id),
                                          phase: phase,
                                          showSeparator: index <
                                              _objectPageViewModel
                                                      .phases.length -
                                                  1,
                                          onTap: () => _showPhaseScreen(
                                              _objectPageViewModel
                                                  .phases[index].id),
                                        );
                                      })
                                ])),
                        const SizedBox(height: 20.0),

                        /// DOCUMENTS BUTTON
                        SelectionInputWidget(
                          margin: const EdgeInsets.only(bottom: 10.0),
                          title: '',
                          value: Titles.documents,
                          onTap: () => _showDocumentsScreen(),
                        ),

                        /// ANALYTICS BUTTON
                        SelectionInputWidget(
                          margin: const EdgeInsets.only(bottom: 10.0),
                          title: '',
                          value: Titles.analytics,
                          onTap: () => _showObjectAnalyticsPageViewScreen(),
                        ),

                        /// SHOW CHAT BUTTON
                        _objectPageViewModel.object?.chat == null
                            ? Container()
                            : SelectionInputWidget(
                                margin: const EdgeInsets.only(bottom: 20.0),
                                title: '',
                                value: Titles.chat,
                                onTap: () => _showDialogScreen(),
                              ),

                        /// CHANGE OBJECT STAGE DIRECTOR BUTTON
                        !_objectPageViewModel.isDirector
                            ? _objectPageViewModel.object?.objectStage?.name ==
                                        'Закончен' ||
                                    _objectPageViewModel
                                            .object?.objectStage?.name ==
                                        'На доработке'
                                ? Container()
                                : BorderButtonWidget(
                                    title: Titles.sendToRevision,
                                    margin: const EdgeInsets.only(bottom: 16.0),
                                    onTap: () => _objectPageViewModel
                                        .changeObjectStage()
                                        .whenComplete(() => {
                                              if (_objectPageViewModel
                                                      .loadingStatus ==
                                                  LoadingStatus.completed)
                                                {
                                                  Toast().showTopToast(
                                                      Titles.objectStageChanged)
                                                }
                                            }),
                                  )

                            /// CHANGE OBJECT STAGE DIRECTOR BUTTON
                            : _objectPageViewModel.object?.objectStage?.name ==
                                        'Закончен' ||
                                    _objectPageViewModel
                                            .object?.objectStage?.name ==
                                        'На рассмотрении руководителя'
                                ? Container()
                                : BorderButtonWidget(
                                    title: Titles.sendToApproval,
                                    margin: const EdgeInsets.only(bottom: 16.0),
                                    onTap: () => _objectPageViewModel
                                        .changeObjectStage()
                                        .whenComplete(() => {
                                              if (_objectPageViewModel
                                                      .loadingStatus ==
                                                  LoadingStatus.completed)
                                                {
                                                  Toast().showTopToast(
                                                      Titles.objectStageChanged)
                                                }
                                            }),
                                  ),

                        /// COMPLETE OBJECT BUTTON
                        _objectPageViewModel.object?.objectStage?.name ==
                                    'Закончен' ||
                                !_objectPageViewModel.isDirector
                            ? Container()
                            : BorderButtonWidget(
                                isDestructive: true,
                                title: Titles.complete,
                                margin: const EdgeInsets.only(bottom: 30.0),
                                onTap: () => _objectPageViewModel
                                    .completeObject()
                                    .whenComplete(() => {
                                          if (_objectPageViewModel
                                                  .loadingStatus ==
                                              LoadingStatus.completed)
                                            {
                                              Toast().showTopToast(
                                                  Titles.objectStageChanged)
                                            }
                                        }),
                              ),
                      ]),

                  /// EDIT TASK BUTTON
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: ButtonWidget(
                        title: Titles.edit,
                        margin: EdgeInsets.only(
                          right: 16.0,
                          left: 16.0,
                          bottom: MediaQuery.of(context).padding.bottom == 0.0
                              ? 20.0
                              : MediaQuery.of(context).padding.bottom,
                        ),
                        onTap: () => _showObjectCreateSheet(),
                      )),
                  const SeparatorWidget(),

                  /// INDICATOR
                  _objectPageViewModel.loadingStatus == LoadingStatus.searching
                      ? const LoadingIndicatorWidget()
                      : Container()
                ]),
              ),
            ),
    );
  }

// MARK: -
// MARK: - PUSH

  void _showObjectCreateSheet() => Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ObjectCreateScreenWidget(
              object: _objectPageViewModel.object,
              onPop: (object) => _objectPageViewModel.updateObject(object))));

  void _showObjectOnMap() => Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => SingleObjectMapScreenWidget(
              object: _objectPageViewModel.object!)));

  void _showObjectAnalyticsPageViewScreen() => Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ObjectAnalyticsScreenWidget(
                object: _objectPageViewModel.object!,
                phases: _objectPageViewModel.phases,
              )));

  void _showDocumentsScreen() => Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              DocumentsScreenWidget(id: _objectPageViewModel.objectId)));

  void _showPhaseScreen(String id) => Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => PhaseScreenWidget(
                id: id,
              ))).whenComplete(() => _objectPageViewModel.getPhaseList());

  void _showDialogScreen() => Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => DialogScreenWidget(
                id: _objectPageViewModel.object!.chat!.id,
                onPop: (message) => {},
              )));
}
