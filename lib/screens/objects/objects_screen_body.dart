import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/views/filter_button_widget.dart';
import 'package:izowork/views/input_widget.dart';
import 'package:izowork/components/loading_status.dart';
import 'package:izowork/components/titles.dart';
import 'package:izowork/entities/response/object.dart';
import 'package:izowork/models/objects_view_model.dart';
import 'package:izowork/views/floating_button_widget.dart';
import 'package:izowork/views/loading_indicator_widget.dart';
import 'package:izowork/screens/objects/views/object_list_item_widget.dart';
import 'package:izowork/views/separator_widget.dart';
import 'package:provider/provider.dart';

class ObjectsScreenBodyWidget extends StatefulWidget {
  const ObjectsScreenBodyWidget({Key? key}) : super(key: key);

  @override
  _ObjectsScreenBodyState createState() => _ObjectsScreenBodyState();
}

class _ObjectsScreenBodyState extends State<ObjectsScreenBodyWidget>
    with AutomaticKeepAliveClientMixin {
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  late ObjectsViewModel _objectsViewModel;

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

    _objectsViewModel = Provider.of<ObjectsViewModel>(context, listen: true);

    return Scaffold(
        backgroundColor: HexColors.white,
        appBar: AppBar(
            toolbarHeight: 68.0,
            titleSpacing: 0.0,
            elevation: 0.0,
            systemOverlayStyle: SystemUiOverlayStyle.dark,
            backgroundColor: Colors.transparent,
            automaticallyImplyLeading: false,
            title: Column(children: [
              const SizedBox(height: 10.0),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(children: [
                    /// SEARCH INPUT
                    Expanded(
                        child: InputWidget(
                            textEditingController: _textEditingController,
                            focusNode: _focusNode,
                            margin: EdgeInsets.zero,
                            isSearchInput: true,
                            placeholder: '${Titles.search}...',
                            onTap: () => setState,
                            onChange: (text) => {
                                  // TODO SEARCH OBJECTS
                                },
                            onClearTap: () => {
                                  // TODO CLEAR OBJECTS SEARCH
                                }))
                  ])),
              const SizedBox(height: 12.0),
              const SeparatorWidget()
            ])),
        floatingActionButton: FloatingButtonWidget(
            onTap: () => _objectsViewModel.showObjectCreateScreen(context)),
        body: SizedBox.expand(
            child: Stack(children: [
          /// OBJECTS LIST VIEW
          ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.only(
                  left: 16.0, right: 16.0, top: 16.0, bottom: 16.0 + 48.0),
              itemCount: 10,
              itemBuilder: (context, index) {
                return ObjectListItemWidget(
                    object: Object(),
                    onTap: () => _objectsViewModel.showObjectScreen(context));
              }),

          /// FILTER BUTTON
          SafeArea(
              child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                      padding: const EdgeInsets.only(bottom: 6.0),
                      child: FilterButtonWidget(
                        onTap: () =>
                            _objectsViewModel.showObjectsFilterSheet(context),
                        // onClearTap: () => {}
                      )))),

          /// INDICATOR
          _objectsViewModel.loadingStatus == LoadingStatus.searching
              ? const LoadingIndicatorWidget()
              : Container()
        ])));
  }
}
