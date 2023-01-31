import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/titles.dart';
import 'package:izowork/models/object_view_model.dart';
import 'package:izowork/screens/object/views/object_comment_list_item_widget.dart';
import 'package:izowork/screens/object/views/object_stage_header_widget.dart';
import 'package:izowork/screens/object/views/object_stage_list_item_widget.dart';
import 'package:izowork/views/back_button_widget.dart';
import 'package:izowork/views/border_button_widget.dart';
import 'package:izowork/views/button_widget_widget.dart';
import 'package:izowork/views/file_list_widget.dart';
import 'package:izowork/views/selection_input_widget.dart';
import 'package:izowork/views/separator_widget.dart';
import 'package:izowork/views/subtitle_widget.dart';
import 'package:izowork/views/title_widget.dart';
import 'package:provider/provider.dart';

class ObjectScreenBodyWidget extends StatefulWidget {
  final Object object;

  const ObjectScreenBodyWidget({Key? key, required this.object})
      : super(key: key);

  @override
  _ObjectScreenBodyState createState() => _ObjectScreenBodyState();
}

class _ObjectScreenBodyState extends State<ObjectScreenBodyWidget> {
  late ObjectViewModel _objectViewModel;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _objectViewModel = Provider.of<ObjectViewModel>(context, listen: true);

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
            title: Text('ЖК Мечта',
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
                        const SubtitleWidget(
                            padding: EdgeInsets.only(bottom: 16.0),
                            text: 'Название'),

                        /// ADDRESS
                        const TitleWidget(
                            padding: EdgeInsets.only(bottom: 4.0),
                            text: Titles.address,
                            isSmall: true),
                        const SubtitleWidget(
                            padding: EdgeInsets.only(bottom: 16.0),
                            text: 'Адресс'),

                        /// COORDINATES
                        const TitleWidget(
                            padding: EdgeInsets.only(bottom: 4.0),
                            text: Titles.address,
                            isSmall: true),
                        GestureDetector(
                          onLongPress: () =>
                              _objectViewModel.copyCoordinates(context),
                          child: const SubtitleWidget(
                              padding: EdgeInsets.only(bottom: 16.0),
                              text: '49.359212, 55.230101'),
                        ),

                        /// GENERAL CONTRACTOR
                        const TitleWidget(
                            padding: EdgeInsets.only(bottom: 4.0),
                            text: Titles.generalContractor,
                            isSmall: true),
                        const SubtitleWidget(
                            padding: EdgeInsets.only(bottom: 16.0),
                            text: 'Имя Фамилия'),

                        /// CUSTOMER
                        const TitleWidget(
                            padding: EdgeInsets.only(bottom: 4.0),
                            text: Titles.customer,
                            isSmall: true),
                        const SubtitleWidget(
                            padding: EdgeInsets.only(bottom: 16.0),
                            text: 'Имя Фамилия'),

                        /// DEGISNER
                        const TitleWidget(
                            padding: EdgeInsets.only(bottom: 4.0),
                            text: Titles.designer,
                            isSmall: true),
                        const SubtitleWidget(
                            padding: EdgeInsets.only(bottom: 16.0),
                            text: 'Имя Фамилия'),

                        /// TYPE
                        const TitleWidget(
                            padding: EdgeInsets.only(bottom: 4.0),
                            text: Titles.objectType,
                            isSmall: true),
                        const SubtitleWidget(
                            padding: EdgeInsets.only(bottom: 16.0),
                            text: 'Тип'),

                        /// FLOOR COUNT
                        const TitleWidget(
                            padding: EdgeInsets.only(bottom: 4.0),
                            text: Titles.floorCount,
                            isSmall: true),
                        const SubtitleWidget(
                            padding: EdgeInsets.only(bottom: 16.0), text: '18'),

                        /// AREA
                        const TitleWidget(
                            padding: EdgeInsets.only(bottom: 4.0),
                            text: Titles.area,
                            isSmall: true),
                        const SubtitleWidget(
                            padding: EdgeInsets.only(bottom: 16.0),
                            text: '64420'),

                        /// BUILDING TIME
                        const TitleWidget(
                            padding: EdgeInsets.only(bottom: 4.0),
                            text: Titles.buildingTime,
                            isSmall: true),
                        const SubtitleWidget(
                            padding: EdgeInsets.only(bottom: 16.0), text: '15'),

                        /// STAGES
                        const TitleWidget(
                            padding: EdgeInsets.only(bottom: 4.0),
                            text: Titles.stages,
                            isSmall: true),
                        const SubtitleWidget(
                            padding: EdgeInsets.only(bottom: 16.0),
                            text: 'Стадия'),

                        /// KISO
                        const TitleWidget(
                            padding: EdgeInsets.only(bottom: 4.0),
                            text: Titles.kiso,
                            isSmall: true),
                        const SubtitleWidget(
                            padding: EdgeInsets.only(bottom: 16.0),
                            text: '100429185'),

                        /// FILE LIST
                        const TitleWidget(
                            padding: EdgeInsets.only(bottom: 10.0),
                            text: Titles.files,
                            isSmall: true),
                        ListView.builder(
                            shrinkWrap: true,
                            padding: const EdgeInsets.only(bottom: 10.0),
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: 3,
                            itemBuilder: (context, index) {
                              return const FileListItemWidget(
                                  fileName: 'file.pdf');
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
                                  ListView.builder(
                                      shrinkWrap: true,
                                      padding: EdgeInsets.zero,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: _objectViewModel.phases.length,
                                      itemBuilder: (context, index) {
                                        return ObjectStageListItemWidget(
                                            title:
                                                _objectViewModel.phases[index],
                                            effectivenes: 50,
                                            readiness: 50,
                                            showSeparator: index < 9,
                                            onTap: () => _objectViewModel
                                                .showPhaseScreen(context));
                                      })
                                ])),
                        const SizedBox(height: 20.0),

                        /// ANALYTICS BUTTON
                        SelectionInputWidget(
                            margin: const EdgeInsets.only(bottom: 10.0),
                            title: '',
                            value: Titles.analytics,
                            onTap: () => _objectViewModel
                                .showObjectAnalyticsPageViewScreen(context)),

                        /// DOCUMENT BUTTON
                        SelectionInputWidget(
                            margin: const EdgeInsets.only(bottom: 20.0),
                            title: '',
                            value: Titles.documents,
                            onTap: () =>
                                _objectViewModel.showDocumentsScreen(context)),

                        /// COMMENT LIST VIEW
                        ListView.builder(
                            shrinkWrap: true,
                            padding: const EdgeInsets.only(bottom: 10.0),
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: 2,
                            itemBuilder: (context, index) {
                              return ObjectCommentListItemWidget(
                                  onTap: () => {});
                            }),

                        /// ADD COMMENT BUTTON
                        BorderButtonWidget(
                            title: Titles.addComment,
                            margin: const EdgeInsets.only(bottom: 16.0),
                            onTap: () =>
                                _objectViewModel.showCommentScreen(context)),

                        /// SHOW CHAT BUTTON
                        BorderButtonWidget(
                            title: Titles.goChat,
                            margin: const EdgeInsets.only(bottom: 30.0),
                            onTap: () =>
                                _objectViewModel.showDialogScreen(context)),
                      ]),

                  /// EDIT TASK BUTTON
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: ButtonWidget(
                          title: Titles.edit,
                          margin: EdgeInsets.only(
                              left: 16.0,
                              right: 16.0,
                              bottom:
                                  MediaQuery.of(context).padding.bottom == 0.0
                                      ? 20.0
                                      : MediaQuery.of(context).padding.bottom),
                          onTap: () => _objectViewModel
                              .showObjectCreateScreenSheet(context)))
                ]))));
  }
}
