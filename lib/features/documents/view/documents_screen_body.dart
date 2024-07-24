import 'package:adaptive_dialog/adaptive_dialog.dart';
// import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:izowork/components/components.dart';
import 'package:izowork/features/documents/view_model/documents_view_model.dart';
import 'package:izowork/models/models.dart';

import 'package:izowork/features/action_create/view/action_create_screen.dart';
import 'package:izowork/features/documents/view/documents_filter_sheet/documents_filter_page_view_screen.dart';
import 'package:izowork/features/documents/view/documents_screen.dart';
import 'package:izowork/views/views.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

class DocumentsScreenBodyWidget extends StatefulWidget {
  final String title;

  const DocumentsScreenBodyWidget({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  _DocumentsScreenBodyState createState() => _DocumentsScreenBodyState();
}

class _DocumentsScreenBodyState extends State<DocumentsScreenBodyWidget> {
  final ScrollController _scrollController = ScrollController();
  final Pagination _pagination = Pagination();

  late DocumentsViewModel _documentsViewModel;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _pagination.increase();

        _documentsViewModel.getDocuments(
          pagination: _pagination,
          officeId: _documentsViewModel.officeId,
        );
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();

    super.dispose();
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
        // toolbarHeight: 116.0,
        titleSpacing: 0.0,
        backgroundColor: HexColors.white90,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title:
            // Column(children: [
            Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            BackButtonWidget(onTap: () => Navigator.pop(context)),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 24.0),
                child: Text(
                  widget.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: HexColors.black,
                    fontSize: 18.0,
                    fontFamily: 'PT Root UI',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ]),
        ),
      ),
      floatingActionButton:
          FloatingButtonWidget(onTap: () => _showAddDialogAction()),
      body: SizedBox.expand(
        child: Stack(children: [
          /// DOCUMENTS LIST VIEW
          LiquidPullToRefresh(
            color: HexColors.primaryMain,
            backgroundColor: HexColors.white,
            springAnimationDurationInMilliseconds: 300,
            onRefresh: _onRefresh,
            child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                shrinkWrap: true,
                controller: _scrollController,
                padding: EdgeInsets.only(
                  left: 16.0,
                  right: 16.0,
                  top: 16.0,
                  bottom: 80.0 + MediaQuery.of(context).padding.bottom,
                ),
                itemCount: _documentsViewModel.documents.length,
                itemBuilder: (context, index) {
                  final document = _documentsViewModel.documents[index];
                  final isFolder =
                      document.isFolder || document.filename == null;

                  return FileListItemWidget(
                    key: ValueKey(document.id),
                    fileName: document.name,
                    isFolder: isFolder,
                    isPinned: document.pinned,
                    isDownloading: _documentsViewModel.downloadIndex == index,
                    onTap: () => isFolder
                        ? _openFolder(_documentsViewModel.documents[index])
                        : _documentsViewModel.openDocument(index),
                    onLongPress: () => _showClipOrDeleteDialogAction(
                      isFolder,
                      document,
                    ),
                  );
                }),
          ),
          const SeparatorWidget(),

          /// EMPTY LIST TEXT
          _documentsViewModel.loadingStatus == LoadingStatus.completed &&
                  _documentsViewModel.documents.isEmpty
              ? const NoResultTitle()
              : Container(),

          /// FILTER BUTTON
          SafeArea(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: FilterButtonWidget(
                isSelected: _documentsViewModel.documentsFilter != null,
                onTap: () => _showDocumentsFilterSheet(),
              ),
            ),
          ),

          /// INDICATOR
          _documentsViewModel.loadingStatus == LoadingStatus.searching
              ? const LoadingIndicatorWidget()
              : Container()
        ]),
      ),
    );
  }

  // MARK: -
  // MARK: - FUNCTIONS

  Future _onRefresh() async {
    _pagination.reset();
    _documentsViewModel.objectId == null
        ? await _documentsViewModel.getDocuments(
            pagination: _pagination,
            officeId: _documentsViewModel.officeId,
            params: _documentsViewModel.documentsFilter?.params,
          )
        : await _documentsViewModel.getObjectDocuments(
            pagination: _pagination,
            objectId: _documentsViewModel.objectId,
            params: _documentsViewModel.documentsFilter?.params,
          );
  }

  void _showAddDialogAction() => showModalActionSheet(
        title: Titles.add,
        actions: [
          const SheetAction(
            label: Titles.folder,
            key: 0,
          ),
          const SheetAction(
            label: Titles.file,
            key: 1,
          ),
        ],
        cancelLabel: Titles.cancel,
        context: context,
      ).then((value) => {
            FocusScope.of(context).unfocus(),
            if (value == 0)
              _showTextViewSheetScreen()
            else if (value == 1)
              _documentsViewModel.addFile()
          });

  void _showClipOrDeleteDialogAction(
    bool isFolder,
    Document document,
  ) {
    final actions = [
      const SheetAction(
        label: Titles.delete,
        key: 1,
        isDestructiveAction: true,
      )
    ];

    if (isFolder) {
      actions.insert(
          0,
          SheetAction(
            label: document.pinned ? Titles.unpin : Titles.pin,
            key: 0,
          ));
    }

    showModalActionSheet(
      title: document.name,
      actions: actions,
      cancelLabel: Titles.cancel,
      context: context,
    ).then((value) => {
          FocusScope.of(context).unfocus(),
          if (value == 0)
            {
              _documentsViewModel.objectId == null
                  ? _documentsViewModel.pinCommonFolder(
                      document.pinned,
                      document.id,
                    )
                  : _documentsViewModel.pinObjectFolder(
                      document.pinned,
                      document.id,
                    )
            }
          else if (value == 1)
            {
              if (_documentsViewModel.objectId == null)
                {
                  isFolder
                      ? _documentsViewModel.deleteCommonFolder(document.id)
                      : _documentsViewModel.deleteCommonFile(document.id)
                }
              else
                {
                  isFolder
                      ? _documentsViewModel.deleteObjectFolder(document.id)
                      : _documentsViewModel.deleteObjectFile(document.id)
                }
            }
        });
  }

  void _showTextViewSheetScreen() {
    String? folder;

    showCupertinoModalBottomSheet(
        enableDrag: false,
        topRadius: const Radius.circular(16.0),
        barrierColor: Colors.black.withOpacity(0.6),
        backgroundColor: HexColors.white,
        context: context,
        builder: (sheetContext) => TextViewSheetWidget(
              title: Titles.addFolder,
              label: Titles.folderName,
              onTap: (text) => {
                folder = text,
                Navigator.pop(context),
              },
            )).whenComplete(() {
      if (folder == null) return;
      if (folder!.isEmpty) return;

      _documentsViewModel.objectId == null
          ? _documentsViewModel.createCommonFolder(true, folder!)
          : _documentsViewModel.createObjectFolder(folder!);
    });
  }

  // MARK: -
  // MARK: - PUSH

  void _openFolder(Document document) => Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => DocumentsScreenWidget(
                objectId: _documentsViewModel.objectId,
                officeId: _documentsViewModel.officeId,
                document: document,
              )));

  void _showDocumentsFilterSheet() => showCupertinoModalBottomSheet(
      enableDrag: false,
      topRadius: const Radius.circular(16.0),
      barrierColor: Colors.black.withOpacity(0.6),
      backgroundColor: HexColors.white,
      context: context,
      builder: (sheetContext) => DocumentsFilterPageViewScreenWidget(
          documentsFilter: _documentsViewModel.documentsFilter,
          onPop: (documentsFilter) => {
                if (documentsFilter == null)
                  {
                    // CLEAR
                    _documentsViewModel.resetFilter(),
                    _onRefresh()
                  }
                else
                  {
                    // FILTER
                    _documentsViewModel.updateFilter(documentsFilter),
                    _onRefresh()
                  }
              }));
}
