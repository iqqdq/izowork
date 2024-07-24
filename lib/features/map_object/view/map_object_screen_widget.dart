import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:izowork/components/components.dart';
import 'package:izowork/models/models.dart';
import 'package:izowork/features/dialog/view/dialog_screen.dart';
import 'package:izowork/features/object/view/object_page_view_screen.dart';
import 'package:izowork/api/api.dart';
import 'package:izowork/views/views.dart';

class MapObjectScreenWidget extends StatefulWidget {
  final MapObject object;
  final bool? hideInfoButton;

  const MapObjectScreenWidget({
    Key? key,
    required this.object,
    this.hideInfoButton,
  }) : super(key: key);

  @override
  _MapObjectScreenState createState() => _MapObjectScreenState();
}

class _MapObjectScreenState extends State<MapObjectScreenWidget> {
  late MapObject _object;
  final List<String> _urls = [];

  @override
  void initState() {
    _object = widget.object;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _urls.clear();

    if (_object.files.isNotEmpty) {
      for (var element in _object.files) {
        if (element.mimeType != null) {
          if (element.mimeType!.contains('image')) {
            _urls.add(element.filename ?? '');
          }
        }
      }
    }

    return Material(
      type: MaterialType.transparency,
      child: Container(
        padding: EdgeInsets.only(
          top: 16.0,
          bottom: MediaQuery.of(context).padding.bottom == 0.0
              ? 12.0
              : MediaQuery.of(context).padding.bottom,
        ),
        color: HexColors.white,
        child: Column(children: [
          // const Column(children: [
          /// DISMISS INDICATOR
          // DismissIndicatorWidget(),
          // ]),

          /// TITLE
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Expanded(
                  child: TitleWidget(
                    padding: EdgeInsets.zero,
                    text: _object.name,
                  ),
                ),

                /// CLOSE BUTTON
                BackButtonWidget(
                  asset: 'assets/ic_close.svg',
                  onTap: () => Navigator.pop(context),
                )
              ],
            ),
          ),
          const SizedBox(height: 16.0),

          /// SCROLLABLE LIST
          Expanded(
            child:
                ListView(shrinkWrap: true, padding: EdgeInsets.zero, children: [
              const SizedBox(height: 12.0),

              /// PHOTO LIST VIEW
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: EdgeInsets.only(bottom: _urls.isEmpty ? 0.0 : 16.0),
                height: _urls.isEmpty ? 0.0 : 88.0,
                child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    physics: const AlwaysScrollableScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: _urls.length,
                    itemBuilder: (context, index) {
                      return Container(
                          key: ValueKey(_urls[index]),
                          width: 84.0,
                          height: 88.0,
                          decoration: BoxDecoration(
                            color: HexColors.grey10,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          margin: EdgeInsets.only(
                              right: index == _urls.length - 1 ? 0.0 : 10.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: CachedNetworkImage(
                              imageUrl: objectMediaUrl + _urls[index],
                              cacheKey: _urls[index],
                              width: 84.0,
                              height: 88.0,
                              memCacheWidth: 88 *
                                  MediaQuery.of(context)
                                      .devicePixelRatio
                                      .toInt(),
                              fit: BoxFit.cover,
                            ),
                          ));
                    }),
              ),

              /// RESPONSIBLE
              const TitleWidget(
                text: Titles.responsible,
                isSmall: true,
              ),
              const SizedBox(height: 4.0),
              SubtitleWidget(text: _object.manager?.name ?? '-'),
              const SizedBox(height: 16.0),

              /// TYPE
              const TitleWidget(
                text: Titles.objectType,
                isSmall: true,
              ),
              const SizedBox(height: 4.0),
              SubtitleWidget(text: _object.objectType?.name ?? '-'),
              const SizedBox(height: 16.0),

              /// ADDRESS
              const TitleWidget(
                text: Titles.address,
                isSmall: true,
              ),
              const SizedBox(height: 4.0),
              SubtitleWidget(text: _object.address),
              const SizedBox(height: 16.0),

              /// DEVELOPER
              const TitleWidget(
                text: Titles.developer,
                isSmall: true,
              ),
              const SizedBox(height: 4.0),
              SubtitleWidget(text: _object.contractor?.name ?? '-'),
              const SizedBox(height: 16.0),

              /// REALIZATION STAGE
              const TitleWidget(
                text: Titles.realizationStage,
                isSmall: true,
              ),
              const SizedBox(height: 4.0),
              SubtitleWidget(text: _object.objectStage?.name ?? '-'),
              const SizedBox(height: 16.0),

              /// EFFECTIVENESS
              const TitleWidget(
                text: Titles.effectiveness,
                isSmall: true,
              ),
              const SizedBox(height: 4.0),
              SubtitleWidget(text: '${_object.efficiency} %'),
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
                                _object.chat == null
                            ? 0.0
                            : 12.0),

                    /// CHAT BUTTON
                    _object.chat == null
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
        ]),
      ),
    );
  }

  // MARK: -
  // MARK: - PUSH

  void _showObjectScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ObjectPageViewScreenWidget(
          id: _object.id,
          onPop: (object) => _object = object ?? _object,
        ),
      ),
    ).whenComplete(() => Future.delayed(
        const Duration(milliseconds: 500), () => setState(() {})));
  }

  void _showDialogScreen() => Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => DialogScreenWidget(id: _object.chat!.id)));
}
