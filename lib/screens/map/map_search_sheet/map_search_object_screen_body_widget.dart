import 'package:flutter/material.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/models/map_search_object_view_model.dart';
import 'package:izowork/views/input_widget.dart';
import 'package:izowork/components/titles.dart';
import 'package:izowork/entities/map_object.dart';
import 'package:izowork/screens/map/map_search_sheet/views/search_object_list_item_widget.dart';
import 'package:izowork/views/dismiss_indicator_widget.dart';
import 'package:izowork/views/separator_widget.dart';
import 'package:provider/provider.dart';

class MapSearchObjectScreenBodyWidget extends StatefulWidget {
  final Function(MapObject) onObjectReturn;

  const MapSearchObjectScreenBodyWidget(
      {Key? key, required this.onObjectReturn})
      : super(key: key);

  @override
  _MapSearchObjectScreenBodyState createState() =>
      _MapSearchObjectScreenBodyState();
}

class _MapSearchObjectScreenBodyState
    extends State<MapSearchObjectScreenBodyWidget> {
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  late MapSearchObjectViewModel _mapSearchObjectViewModel;

  bool _show = false; // TODO DELETE

  @override
  void dispose() {
    _textEditingController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height * 0.8;

    _mapSearchObjectViewModel =
        Provider.of<MapSearchObjectViewModel>(context, listen: true);

    return Material(
        type: MaterialType.transparency,
        child: Container(
            height: _height,
            color: HexColors.white,
            padding: const EdgeInsets.only(top: 8.0),
            child: Stack(children: [
              ListView(
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    /// DISMISS INDICATOR
                    const DismissIndicatorWidget(),

                    /// SEARCH INPUT
                    InputWidget(
                        textEditingController: _textEditingController,
                        focusNode: _focusNode,
                        isSearchInput: true,
                        placeholder: '${Titles.search}...',
                        onTap: () => setState,
                        onChange: (text) =>
                            // TODO SEARCH MAP OBJECT
                            setState(() => _show = text.isEmpty ? false : true),
                        onClearTap: () =>
                            // TODO CLEAR MAP OBJECT SEARCH
                            setState(() => _show = false)),
                    const SizedBox(height: 16.0),

                    /// SEPARATOR
                    const SeparatorWidget(),

                    /// OBJECT ADDRESS LIST VIEW
                    _show
                        ? SizedBox(
                            height: _height - 86.0,
                            child: ListView.builder(
                                physics: const AlwaysScrollableScrollPhysics(),
                                padding: EdgeInsets.only(
                                    top: 12.0,
                                    left: 16.0,
                                    right: 16.0,
                                    bottom: MediaQuery.of(context)
                                                .viewInsets
                                                .bottom !=
                                            0.0
                                        ? MediaQuery.of(context)
                                            .viewInsets
                                            .bottom
                                        : MediaQuery.of(context)
                                                    .padding
                                                    .bottom ==
                                                0.0
                                            ? 12.0
                                            : MediaQuery.of(context)
                                                .padding
                                                .bottom),
                                itemCount: 20,
                                itemBuilder: (context, index) {
                                  return SearchObjectListItemWidget(
                                      address: 'Адресс',
                                      name: 'Название объекта',
                                      onTap: () => {});
                                }))
                        : Container()
                  ]),

              /// PLACEHOLDER
              !_show
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                          Row(children: [
                            Expanded(
                                child: Text(Titles.enterObjectName,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w400,
                                        color: HexColors.grey30,
                                        fontFamily: 'PT Root UI')))
                          ])
                        ])
                  : Container()
            ])));
  }
}
