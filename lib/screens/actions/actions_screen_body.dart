import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/views/filter_button_widget.dart';
import 'package:izowork/views/input_widget.dart';
import 'package:izowork/components/loading_status.dart';
import 'package:izowork/components/titles.dart';
import 'package:izowork/entities/deal.dart';
import 'package:izowork/entities/task.dart';
import 'package:izowork/models/actions_view_model.dart';
import 'package:izowork/screens/actions/views/action_list_item_widget.dart';
import 'package:izowork/views/asset_image_button_widget.dart';
import 'package:izowork/views/floating_button_widget.dart';
import 'package:izowork/views/loading_indicator_widget.dart';
import 'package:izowork/views/segmented_control_widget.dart';
import 'package:izowork/views/separator_widget.dart';
import 'package:provider/provider.dart';

class ActionsScreenBodyWidget extends StatefulWidget {
  const ActionsScreenBodyWidget({Key? key}) : super(key: key);

  @override
  _ActionsScreenBodyState createState() => _ActionsScreenBodyState();
}

class _ActionsScreenBodyState extends State<ActionsScreenBodyWidget>
    with AutomaticKeepAliveClientMixin {
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  late ActionsViewModel _actionsViewModel;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    _actionsViewModel = Provider.of<ActionsViewModel>(context, listen: true);

    return Scaffold(
        backgroundColor: HexColors.white,
        appBar: AppBar(
            toolbarHeight: 130.0,
            titleSpacing: 0.0,
            elevation: 0.0,
            systemOverlayStyle: SystemUiOverlayStyle.dark,
            backgroundColor: Colors.transparent,
            automaticallyImplyLeading: false,
            title: Column(children: [
              /// SEGMENTED CONTROL
              SegmentedControlWidget(
                  titles: const [Titles.deals, Titles.tasks],
                  backgroundColor: HexColors.grey10,
                  activeColor: HexColors.black,
                  disableColor: HexColors.grey40,
                  thumbColor: HexColors.white,
                  borderColor: HexColors.grey20,
                  onTap: (index) => {
                        _textEditingController.clear(),
                        FocusScope.of(context).unfocus(),
                        _actionsViewModel.changeSegmentedControlIndex(index)
                      }),
              const SizedBox(height: 16.0),

              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(children: [
                    Expanded(
                        child:

                            /// SEARCH INPUT
                            InputWidget(
                                textEditingController: _textEditingController,
                                focusNode: _focusNode,
                                margin: const EdgeInsets.only(right: 18.0),
                                isSearchInput: true,
                                placeholder: '${Titles.search}...',
                                onTap: () => setState,
                                onChange: (text) => {
                                      // TODO SEARCH DEAL / TASK
                                    },
                                onClearTap: () => {
                                      // TODO CLEAR DEAL / TASK SEARCH
                                    })),

                    /// CALENDAR BUTTON
                    AssetImageButton(
                        imagePath: 'assets/ic_calendar.png',
                        onTap: () =>
                            _actionsViewModel.showDealCalendarScreen(context))
                  ])),
              const SizedBox(height: 16.0),
              const SeparatorWidget()
            ])),
        floatingActionButton: FloatingButtonWidget(
            onTap: () => {
                  // TODO ADD DEAL / TASK
                }),
        body: SizedBox.expand(
            child: Stack(children: [
          /// DEALS / TASKS LIST VIEW
          ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.only(
                  left: 16.0, right: 16.0, top: 16.0, bottom: 16.0 + 48.0),
              itemCount: 10,
              itemBuilder: (context, index) {
                return ActionListItemWidget(
                    deal: Deal(), task: Task(), onTap: () => {});
              }),

          /// FILTER BUTTON
          SafeArea(
              child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                      padding: const EdgeInsets.only(bottom: 6.0),
                      child: FilterButtonWidget(
                        onTap: () => {},
                        // onClearTap: () => {}
                      )))),

          /// INDICATOR
          _actionsViewModel.loadingStatus == LoadingStatus.searching
              ? const LoadingIndicatorWidget()
              : Container()
        ])));
  }
}
