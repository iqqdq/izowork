import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/views/input_widget.dart';
import 'package:izowork/components/loading_status.dart';
import 'package:izowork/components/titles.dart';
import 'package:izowork/entities/object.dart';
import 'package:izowork/models/objects_view_model.dart';
import 'package:izowork/views/asset_image_button_widget.dart';
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
    _objectsViewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    _objectsViewModel = Provider.of<ObjectsViewModel>(context, listen: true);

    return Scaffold(
        backgroundColor: HexColors.white,
        appBar: AppBar(
            toolbarHeight: 74.0,
            titleSpacing: 0.0,
            elevation: 0.0,
            systemOverlayStyle: SystemUiOverlayStyle.dark,
            backgroundColor: Colors.transparent,
            title: Column(children: [
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
                                      // TODO SEARCH OBJECTS
                                    },
                                onClearTap: () => {
                                      // TODO CLEAR OBJECTS SEARCH
                                    })),

                    /// FILTER BUTTON
                    AssetImageButton(
                        imagePath: 'assets/ic_filter.png',
                        onTap: () => {
                              // TODO SHOW OBJECT FILTER
                            }),
                  ])),
              const SizedBox(height: 16.0),
              const SeparatorWidget()
            ])),
        floatingActionButton: FloatingButtonWidget(
            onTap: () => {
                  // TODO ADD OBJECT
                }),
        body: SizedBox.expand(
            child: Stack(children: [
          /// OBJECTS LIST VIEW
          ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.only(
                  left: 16.0, right: 16.0, top: 16.0, bottom: 16.0 + 48.0),
              itemCount: 10,
              itemBuilder: (context, index) {
                return ObjectListItemWidget(object: Object(), onTap: () => {});
              }),

          /// INDICATOR
          _objectsViewModel.loadingStatus == LoadingStatus.searching
              ? const LoadingIndicatorWidget()
              : Container()
        ])));
  }
}
