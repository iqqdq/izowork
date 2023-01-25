import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/titles.dart';
import 'package:izowork/entities/map_object.dart';
import 'package:izowork/screens/map_object/views/map_object_stage_list_item_widget.dart';
import 'package:izowork/views/border_button_widget.dart';
import 'package:izowork/views/dismiss_indicator_widget.dart';
import 'package:izowork/views/subtitle_widget.dart';
import 'package:izowork/views/title_widget.dart';

class MapObjectScreenBodyWidget extends StatelessWidget {
  final MapObject mapObject;
  final VoidCallback onDetailTap;
  final VoidCallback onChatTap;

  const MapObjectScreenBodyWidget(
      {Key? key,
      required this.mapObject,
      required this.onDetailTap,
      required this.onChatTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
        type: MaterialType.transparency,
        child: Container(
            color: HexColors.white,
            child: ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.only(
                    top: 8.0,
                    bottom: MediaQuery.of(context).padding.bottom == 0.0
                        ? 12.0
                        : MediaQuery.of(context).padding.bottom),
                children: [
                  Column(children: const [
                    /// DISMISS INDICATOR
                    SizedBox(height: 6.0),
                    DismissIndicatorWidget(),
                  ]),

                  /// SCROLLABLE LIST
                  ListView(shrinkWrap: true, children: [
                    /// PHOTO LIST VIEW
                    SizedBox(
                        height: 88.0,
                        child: ListView.builder(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            physics: const AlwaysScrollableScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemCount: 10,
                            itemBuilder: (context, index) {
                              return Container(
                                  width: 84.0,
                                  height: 88.0,
                                  decoration: BoxDecoration(
                                    color: HexColors.grey10,
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  margin: EdgeInsets.only(
                                      right: index == 10 ? 0.0 : 10.0),
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10.0),
                                      child: CachedNetworkImage(
                                          imageUrl:
                                              'https://thumbs.dreamstime.com/b/construction-buildings-17322972.jpg',
                                          // cacheKey: ,
                                          width: 84.0,
                                          height: 88.0,
                                          memCacheHeight:
                                              (MediaQuery.of(context)
                                                          .devicePixelRatio *
                                                      88)
                                                  .round(),
                                          fit: BoxFit.cover)));
                            })),
                    const SizedBox(height: 16.0),

                    /// TITLE
                    const TitleWidget(text: 'Название объекта'),
                    const SizedBox(height: 16.0),

                    /// ADDRESS
                    const TitleWidget(text: Titles.placeAddress, isSmall: true),
                    const SizedBox(height: 4.0),
                    const SubtitleWidget(text: 'Адрес'),
                    const SizedBox(height: 16.0),

                    /// DEVELOPER
                    const TitleWidget(text: Titles.developer, isSmall: true),
                    const SizedBox(height: 4.0),
                    const SubtitleWidget(text: 'Имя застройщика'),
                    const SizedBox(height: 16.0),

                    /// STAGE LIST VIEW
                    const TitleWidget(
                        text: Titles.realizationStage, isSmall: true),
                    const SizedBox(height: 4.0),

                    ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: 3,
                        itemBuilder: (context, index) {
                          return MapObjectStageListItemWidget(
                              number: index + 1, text: 'Стадия');
                        }),

                    /// EFFECTIVENESS
                    const TitleWidget(
                        text: Titles.effectiveness, isSmall: true),
                    const SizedBox(height: 4.0),
                    const SubtitleWidget(text: '30 %'),
                    const SizedBox(height: 16.0),
                  ]),
                  Row(children: [
                    Expanded(
                        child: BorderButtonWidget(
                            title: Titles.showDetail,
                            margin:
                                const EdgeInsets.only(left: 16.0, right: 5.0),
                            onTap: () => onDetailTap())),
                    Expanded(
                        child: BorderButtonWidget(
                            title: Titles.chat,
                            margin:
                                const EdgeInsets.only(left: 5.0, right: 16.0),
                            onTap: () => onChatTap())),
                  ])
                ])));
  }
}
