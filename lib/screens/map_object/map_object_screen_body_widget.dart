import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/titles.dart';
import 'package:izowork/models/map_object_view_model.dart';
import 'package:izowork/services/urls.dart';
import 'package:izowork/views/border_button_widget.dart';
import 'package:izowork/views/dismiss_indicator_widget.dart';
import 'package:izowork/views/subtitle_widget.dart';
import 'package:izowork/views/title_widget.dart';
import 'package:provider/provider.dart';

class MapObjectScreenBodyWidget extends StatelessWidget {
  final bool? hideInfoButton;

  const MapObjectScreenBodyWidget({Key? key, this.hideInfoButton})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _mapViewModel =
        Provider.of<MapObjectViewModel>(context, listen: true);

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
                  ListView(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      children: [
                        /// PHOTO LIST VIEW
                        AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: EdgeInsets.only(
                                bottom:
                                    _mapViewModel.urls.isEmpty ? 0.0 : 16.0),
                            height: _mapViewModel.urls.isEmpty ? 0.0 : 88.0,
                            child: ListView.builder(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                physics: const AlwaysScrollableScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemCount: _mapViewModel.urls.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                      width: 84.0,
                                      height: 88.0,
                                      decoration: BoxDecoration(
                                        color: HexColors.grey10,
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      margin: EdgeInsets.only(
                                          right: index ==
                                                  _mapViewModel.urls.length - 1
                                              ? 0.0
                                              : 10.0),
                                      child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          child: CachedNetworkImage(
                                              imageUrl: objectMediaUrl +
                                                  _mapViewModel.urls[index],
                                              cacheKey:
                                                  _mapViewModel.urls[index],
                                              width: 84.0,
                                              height: 88.0,
                                              memCacheWidth: 88 *
                                                  MediaQuery.of(context)
                                                      .devicePixelRatio
                                                      .toInt(),
                                              fit: BoxFit.cover)));
                                })),

                        /// TITLE
                        TitleWidget(text: _mapViewModel.object.name),
                        const SizedBox(height: 16.0),

                        /// RESPONSIBLE
                        const TitleWidget(
                            text: Titles.responsible, isSmall: true),
                        const SizedBox(height: 4.0),
                        SubtitleWidget(
                            text: _mapViewModel.object.manager?.name ?? '-'),
                        const SizedBox(height: 16.0),

                        /// TYPE
                        const TitleWidget(
                            text: Titles.objectType, isSmall: true),
                        const SizedBox(height: 4.0),
                        SubtitleWidget(
                            text: _mapViewModel.object.objectType?.name ?? '-'),
                        const SizedBox(height: 16.0),

                        /// ADDRESS
                        const TitleWidget(text: Titles.address, isSmall: true),
                        const SizedBox(height: 4.0),
                        SubtitleWidget(text: _mapViewModel.object.address),
                        const SizedBox(height: 16.0),

                        /// DEVELOPER
                        const TitleWidget(
                            text: Titles.developer, isSmall: true),
                        const SizedBox(height: 4.0),
                        SubtitleWidget(
                            text: _mapViewModel.object.contractor?.name ?? '-'),
                        const SizedBox(height: 16.0),

                        /// REALIZATION STAGE
                        const TitleWidget(
                            text: Titles.realizationStage, isSmall: true),
                        const SizedBox(height: 4.0),
                        SubtitleWidget(
                            text:
                                _mapViewModel.object.objectStage?.name ?? '-'),
                        const SizedBox(height: 16.0),

                        /// EFFECTIVENESS
                        const TitleWidget(
                            text: Titles.effectiveness, isSmall: true),
                        const SizedBox(height: 4.0),
                        SubtitleWidget(
                            text: '${_mapViewModel.object.efficiency} %'),
                        const SizedBox(height: 16.0)
                      ]),
                  hideInfoButton != null
                      ? Container()
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(children: [
                            Expanded(
                                child: BorderButtonWidget(
                                    title: Titles.showDetail,
                                    margin: EdgeInsets.zero,
                                    onTap: () => _mapViewModel
                                        .showObjectScreen(context))),
                            _mapViewModel.object.chat == null
                                ? Container()
                                : Expanded(
                                    child: BorderButtonWidget(
                                        title: Titles.chat,
                                        margin: EdgeInsets.zero,
                                        onTap: () => _mapViewModel
                                            .showDialogScreen(context))),
                          ]))
                ])));
  }
}
