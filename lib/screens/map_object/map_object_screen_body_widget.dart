import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/titles.dart';
import 'package:izowork/models/map_object_view_model.dart';
import 'package:izowork/screens/dialog/dialog_screen.dart';
import 'package:izowork/screens/object/object_page_view_screen.dart';
import 'package:izowork/services/urls.dart';
import 'package:izowork/views/border_button_widget.dart';
import 'package:izowork/views/dismiss_indicator_widget.dart';
import 'package:izowork/views/subtitle_widget.dart';
import 'package:izowork/views/title_widget.dart';
import 'package:provider/provider.dart';

class MapObjectScreenBodyWidget extends StatefulWidget {
  final bool? hideInfoButton;

  const MapObjectScreenBodyWidget({
    Key? key,
    this.hideInfoButton,
  }) : super(key: key);

  @override
  _MapObjectScreenBodyState createState() => _MapObjectScreenBodyState();
}

class _MapObjectScreenBodyState extends State<MapObjectScreenBodyWidget> {
  late MapObjectViewModel _mapObjectViewModel;

  void _showObjectScreen() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ObjectPageViewScreenWidget(
                object: _mapObjectViewModel.object)));
  }

  void _showDialogScreen() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                DialogScreenWidget(chat: _mapObjectViewModel.object.chat!)));
  }

  @override
  Widget build(BuildContext context) {
    _mapObjectViewModel = Provider.of<MapObjectViewModel>(
      context,
      listen: true,
    );

    return Material(
      type: MaterialType.transparency,
      child: Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).padding.bottom == 0.0
              ? 12.0
              : MediaQuery.of(context).padding.bottom,
        ),
        color: HexColors.white,
        child: Column(children: [
          const Column(children: [
            /// DISMISS INDICATOR
            SizedBox(height: 6.0),
            DismissIndicatorWidget(),
          ]),

          /// SCROLLABLE LIST
          Expanded(
            child:
                ListView(shrinkWrap: true, padding: EdgeInsets.zero, children: [
              const SizedBox(height: 12.0),

              /// PHOTO LIST VIEW
              AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: EdgeInsets.only(
                      bottom: _mapObjectViewModel.urls.isEmpty ? 0.0 : 16.0),
                  height: _mapObjectViewModel.urls.isEmpty ? 0.0 : 88.0,
                  child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      physics: const AlwaysScrollableScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: _mapObjectViewModel.urls.length,
                      itemBuilder: (context, index) {
                        return Container(
                            key: ValueKey(_mapObjectViewModel.urls[index]),
                            width: 84.0,
                            height: 88.0,
                            decoration: BoxDecoration(
                              color: HexColors.grey10,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            margin: EdgeInsets.only(
                                right:
                                    index == _mapObjectViewModel.urls.length - 1
                                        ? 0.0
                                        : 10.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: CachedNetworkImage(
                                  imageUrl: objectMediaUrl +
                                      _mapObjectViewModel.urls[index],
                                  cacheKey: _mapObjectViewModel.urls[index],
                                  width: 84.0,
                                  height: 88.0,
                                  memCacheWidth: 88 *
                                      MediaQuery.of(context)
                                          .devicePixelRatio
                                          .toInt(),
                                  fit: BoxFit.cover),
                            ));
                      })),

              /// TITLE
              TitleWidget(text: _mapObjectViewModel.object.name),
              const SizedBox(height: 16.0),

              /// RESPONSIBLE
              const TitleWidget(
                text: Titles.responsible,
                isSmall: true,
              ),
              const SizedBox(height: 4.0),
              SubtitleWidget(
                  text: _mapObjectViewModel.object.manager?.name ?? '-'),
              const SizedBox(height: 16.0),

              /// TYPE
              const TitleWidget(
                text: Titles.objectType,
                isSmall: true,
              ),
              const SizedBox(height: 4.0),
              SubtitleWidget(
                  text: _mapObjectViewModel.object.objectType?.name ?? '-'),
              const SizedBox(height: 16.0),

              /// ADDRESS
              const TitleWidget(
                text: Titles.address,
                isSmall: true,
              ),
              const SizedBox(height: 4.0),
              SubtitleWidget(text: _mapObjectViewModel.object.address),
              const SizedBox(height: 16.0),

              /// DEVELOPER
              const TitleWidget(
                text: Titles.developer,
                isSmall: true,
              ),
              const SizedBox(height: 4.0),
              SubtitleWidget(
                  text: _mapObjectViewModel.object.contractor?.name ?? '-'),
              const SizedBox(height: 16.0),

              /// REALIZATION STAGE
              const TitleWidget(
                text: Titles.realizationStage,
                isSmall: true,
              ),
              const SizedBox(height: 4.0),
              SubtitleWidget(
                  text: _mapObjectViewModel.object.objectStage?.name ?? '-'),
              const SizedBox(height: 16.0),

              /// EFFECTIVENESS
              const TitleWidget(
                text: Titles.effectiveness,
                isSmall: true,
              ),
              const SizedBox(height: 4.0),
              SubtitleWidget(
                  text: '${_mapObjectViewModel.object.efficiency} %'),
              const SizedBox(height: 16.0)
            ]),
          ),

          /// BOTTOM BUTTON'S
          widget.hideInfoButton != null
              ? Container()
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(children: [
                    /// INFO BUTTON
                    Expanded(
                      child: BorderButtonWidget(
                        title: Titles.showDetail,
                        margin: EdgeInsets.zero,
                        onTap: () => _showObjectScreen(),
                      ),
                    ),
                    SizedBox(
                        width: widget.hideInfoButton != null ||
                                _mapObjectViewModel.object.chat == null
                            ? 0.0
                            : 12.0),

                    /// CHAT BUTTON
                    _mapObjectViewModel.object.chat == null
                        ? Container()
                        : Expanded(
                            child: BorderButtonWidget(
                              title: Titles.chat,
                              margin: EdgeInsets.zero,
                              onTap: () => _showDialogScreen(),
                            ),
                          ),
                  ]),
                ),

          /// CLOSE SHEET BUTTON
          Container(
            margin: const EdgeInsets.only(
              left: 16.0,
              top: 12.0,
              right: 16.0,
            ),
            child: BorderButtonWidget(
              title: Titles.close,
              margin: EdgeInsets.zero,
              onTap: () => Navigator.pop(context),
            ),
          )
        ]),
      ),
    );
  }
}
