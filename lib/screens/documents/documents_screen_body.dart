import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:izowork/components/components.dart';
import 'package:izowork/notifiers/domain.dart';
import 'package:izowork/views/views.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:provider/provider.dart';

class DocumentsScreenBodyWidget extends StatefulWidget {
  final String? title;

  const DocumentsScreenBodyWidget({Key? key, this.title}) : super(key: key);

  @override
  _DocumentsScreenBodyState createState() => _DocumentsScreenBodyState();
}

class _DocumentsScreenBodyState extends State<DocumentsScreenBodyWidget> {
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  late DocumentsViewModel _documentsViewModel;
  Pagination _pagination = Pagination(offset: 0, size: 50);
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _pagination.offset += 1;
        _documentsViewModel.getDealList(
            pagination: _pagination, search: _textEditingController.text);
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

  // MARK: -
  // MARK: - FUNCTIONS

  Future _onRefresh() async {
    _pagination = Pagination(offset: 0, size: 50);
    await _documentsViewModel.getDealList(
      pagination: _pagination,
      search: _textEditingController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    _documentsViewModel = Provider.of<DocumentsViewModel>(
      context,
      listen: true,
    );

    return Scaffold(
      extendBodyBehindAppBar: false,
      backgroundColor: HexColors.white,
      appBar: AppBar(
          toolbarHeight: 116.0,
          titleSpacing: 0.0,
          elevation: 0.0,
          backgroundColor: HexColors.white90,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          automaticallyImplyLeading: false,
          title: Column(children: [
            Stack(children: [
              Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: BackButtonWidget(onTap: () => Navigator.pop(context))),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(widget.title ?? Titles.documents,
                    style: TextStyle(
                        color: HexColors.black,
                        fontSize: 18.0,
                        fontFamily: 'PT Root UI',
                        fontWeight: FontWeight.bold)),
              ])
            ]),
            const SizedBox(height: 16.0),
            Row(children: [
              Expanded(
                  child:

                      /// SEARCH INPUT
                      InputWidget(
                          textEditingController: _textEditingController,
                          focusNode: _focusNode,
                          margin: const EdgeInsets.symmetric(horizontal: 16.0),
                          isSearchInput: true,
                          placeholder: '${Titles.search}...',
                          onTap: () => setState,
                          onChange: (text) => {
                                setState(() => _isSearching = true),
                                EasyDebounce.debounce('document_debouncer',
                                    const Duration(milliseconds: 500),
                                    () async {
                                  _pagination = Pagination(offset: 0, size: 50);

                                  _documentsViewModel
                                      .getDealList(
                                          pagination: _pagination,
                                          search: _textEditingController.text)
                                      .then((value) =>
                                          setState(() => _isSearching = false));
                                })
                              },
                          onClearTap: () => {
                                _documentsViewModel.resetFilter(),
                                _pagination.offset = 0,
                                _documentsViewModel.getDealList(
                                    pagination: _pagination,
                                    search: _textEditingController.text)
                              }))
            ])
          ])),
      body: SizedBox.expand(
        child: Stack(children: [
          /// DOCUMENTS LIST VIEW
          LiquidPullToRefresh(
              color: HexColors.primaryMain,
              backgroundColor: HexColors.white,
              springAnimationDurationInMilliseconds: 300,
              onRefresh: _onRefresh,
              child: ListView.builder(
                  shrinkWrap: true,
                  controller: _scrollController,
                  padding: EdgeInsets.only(
                      left: 16.0,
                      right: 16.0,
                      top: 16.0,
                      bottom: 80.0 + MediaQuery.of(context).padding.bottom),
                  itemCount: _documentsViewModel.documents.length,
                  itemBuilder: (context, index) {
                    bool isFolder =
                        _documentsViewModel.documents[index].type == 'dir';

                    return FileListItemWidget(
                        key: ValueKey(_documentsViewModel.documents[index].id),
                        fileName: _documentsViewModel.documents[index].name,
                        isFolder: isFolder,
                        isDownloading:
                            _documentsViewModel.downloadIndex == index,
                        onTap: () => isFolder
                            ? _documentsViewModel.openFolder(context, index)
                            : _documentsViewModel.openFile(context, index));
                  })),
          const SeparatorWidget(),

          /// EMPTY LIST TEXT
          _documentsViewModel.loadingStatus == LoadingStatus.completed &&
                  _documentsViewModel.documents.isEmpty &&
                  !_isSearching
              ? Center(
                  child: Padding(
                      padding: const EdgeInsets.only(
                          left: 20.0, right: 20.0, bottom: 100.0),
                      child: Text(Titles.noResult,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 16.0,
                              color: HexColors.grey50))))
              : Container(),

          /// FILTER BUTTON
          SafeArea(
              child: Align(
                  alignment: Alignment.bottomCenter,
                  child: FilterButtonWidget(
                      onTap: () => _documentsViewModel.showDocumentsFilterSheet(
                          context,
                          () => {
                                _pagination = Pagination(offset: 0, size: 50),
                                _documentsViewModel.getDealList(
                                    pagination: _pagination,
                                    search: _textEditingController.text)
                              })

                      // onClearTap: () => {}
                      ))),

          /// INDICATOR
          _documentsViewModel.loadingStatus == LoadingStatus.searching
              ? const LoadingIndicatorWidget()
              : Container()
        ]),
      ),
    );
  }
}
