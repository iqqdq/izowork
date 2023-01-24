import 'package:flutter/material.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/models/deals_filter_search_view_model.dart';
import 'package:izowork/screens/map/map_filter_sheet/map_filter_search/views/map_filter_search_list_item_widget.dart';
import 'package:izowork/views/back_button_widget.dart';
import 'package:izowork/views/input_widget.dart';
import 'package:izowork/components/titles.dart';
import 'package:izowork/views/separator_widget.dart';
import 'package:izowork/views/title_widget.dart';
import 'package:provider/provider.dart';

class DealFilterSearchBodyScreenWidget extends StatefulWidget {
  final int type;
  final VoidCallback onPop;

  const DealFilterSearchBodyScreenWidget(
      {Key? key, required this.type, required this.onPop})
      : super(key: key);

  @override
  _DealFilterSearchBodyState createState() => _DealFilterSearchBodyState();
}

class _DealFilterSearchBodyState
    extends State<DealFilterSearchBodyScreenWidget> {
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  late DealsFilterSearchViewModel _dealsFilterSearchViewModel;
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

    _dealsFilterSearchViewModel =
        Provider.of<DealsFilterSearchViewModel>(context, listen: true);

    return Material(
        type: MaterialType.transparency,
        child: Container(
            height: _height,
            color: HexColors.white,
            padding: const EdgeInsets.only(top: 8.0),
            child: Stack(children: [
              ListView(
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  children: [
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Stack(children: [
                          BackButtonWidget(
                            title: Titles.back,
                            onTap: () => widget.onPop(),
                          ),
                          Center(
                              child: TitleWidget(
                                  text: widget.type == 0
                                      ? Titles.responsible
                                      : widget.type == 1
                                          ? Titles.object
                                          : Titles.company))
                        ])),
                    const SizedBox(height: 16.0),

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

                    /// USER LIST VIEW
                    _show
                        ? SizedBox(
                            height: _height - 86.0,
                            child: ListView.builder(
                                physics: const AlwaysScrollableScrollPhysics(),
                                padding: EdgeInsets.only(
                                    top: 12.0,
                                    left: 16.0,
                                    right: 16.0,
                                    bottom: (MediaQuery.of(context)
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
                                                    .bottom) +
                                        124.0),
                                itemCount: 20,
                                itemBuilder: (context, index) {
                                  return MapFilterSearchListItemWidget(
                                      name: 'Имя Фамилия',
                                      onTap: () => widget.onPop());
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
                                child: Text(
                                    widget.type == 0
                                        ? Titles.enterResponsibleName
                                        : widget.type == 1
                                            ? Titles.enterObjectName
                                            : Titles.enterCompanyName,
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
