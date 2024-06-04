import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:izowork/components/components.dart';
import 'package:izowork/screens/objects/views/object_list_item_widget.dart';
import 'package:izowork/views/views.dart';
import 'package:izowork/notifiers/notifiers.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
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
  final ScrollController _scrollController = ScrollController();

  Pagination _pagination = Pagination(offset: 0, size: 50);
  bool _isSearching = false;

  late ObjectsViewModel _objectsViewModel;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _pagination.offset += 1;
        _objectsViewModel.getObjectList(
          pagination: _pagination,
          search: _textEditingController.text,
        );
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _textEditingController.dispose();
    _focusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    _objectsViewModel = Provider.of<ObjectsViewModel>(
      context,
      listen: true,
    );

    return Scaffold(
      backgroundColor: HexColors.white,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
          toolbarHeight: 68.0,
          titleSpacing: 0.0,
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
                                setState(() => _isSearching = true),
                                EasyDebounce.debounce('object_debouncer',
                                    const Duration(milliseconds: 500),
                                    () async {
                                  _pagination = Pagination(offset: 0, size: 50);

                                  _objectsViewModel
                                      .getObjectList(
                                        pagination: _pagination,
                                        search: _textEditingController.text,
                                      )
                                      .then((value) => setState(
                                            () => _isSearching = false,
                                          ));
                                })
                              },
                          onClearTap: () => {
                                _objectsViewModel.resetFilter(),
                                _pagination.offset = 0,
                                _objectsViewModel.getObjectList(
                                    pagination: _pagination,
                                    search: _textEditingController.text)
                              }))
                ])),
            const SizedBox(height: 12.0),
            const SeparatorWidget()
          ])),
      floatingActionButton: FloatingButtonWidget(
          onTap: () => _objectsViewModel.showObjectCreateScreen(
                context,
              )),
      body: SizedBox.expand(
        child: Stack(children: [
          /// OBJECTS LIST VIEW
          LiquidPullToRefresh(
              color: HexColors.primaryMain,
              backgroundColor: HexColors.white,
              springAnimationDurationInMilliseconds: 300,
              onRefresh: _onRefresh,
              child: GestureDetector(
                  onTap: () => FocusScope.of(context).unfocus(),
                  child: ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.only(
                        left: 16.0,
                        right: 16.0,
                        top: 16.0,
                        bottom: 64.0,
                      ),
                      itemCount: _objectsViewModel.objects.length,
                      itemBuilder: (context, index) {
                        return ObjectListItemWidget(
                            key: ValueKey(_objectsViewModel.objects[index].id),
                            object: _objectsViewModel.objects[index],
                            onTap: () =>
                                _objectsViewModel.showObjectPageViewScreen(
                                  context,
                                  index,
                                ));
                      }))),

          /// FILTER BUTTON
          SafeArea(
              child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                      padding: const EdgeInsets.only(bottom: 6.0),
                      child: FilterButtonWidget(
                        onTap: () => _objectsViewModel.showObjectsFilterSheet(
                            context,
                            () => {
                                  _pagination = Pagination(offset: 0, size: 50),
                                  _objectsViewModel.getObjectList(
                                    pagination: _pagination,
                                    search: _textEditingController.text,
                                  )
                                }),
                        // onClearTap: () => {}
                      )))),

          /// EMPTY LIST TEXT
          _objectsViewModel.loadingStatus == LoadingStatus.completed &&
                  _objectsViewModel.objects.isEmpty &&
                  !_isSearching
              ? Center(
                  child: Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                      child: Text(Titles.noResult,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 16.0,
                              color: HexColors.grey50))))
              : Container(),

          /// INDICATOR
          _objectsViewModel.loadingStatus == LoadingStatus.searching ||
                  _isSearching
              ? const LoadingIndicatorWidget()
              : Container()
        ]),
      ),
    );
  }

  // MARK: -
  // MARK: - FUNCTIONS

  Future _onRefresh() async {
    _pagination = Pagination(offset: 0, size: 50);
    await _objectsViewModel.getObjectList(
      pagination: _pagination,
      search: _textEditingController.text,
    );
  }
}
