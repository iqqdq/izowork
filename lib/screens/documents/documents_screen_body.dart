import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/loading_status.dart';
import 'package:izowork/components/titles.dart';
import 'package:izowork/models/documents_view_model.dart';
import 'package:izowork/screens/documents/views/documents_list_item_widget.dart';
import 'package:izowork/views/back_button_widget.dart';
import 'package:izowork/views/filter_button_widget.dart';
import 'package:izowork/views/input_widget.dart';
import 'package:izowork/views/loading_indicator_widget.dart';
import 'package:izowork/views/separator_widget.dart';
import 'package:provider/provider.dart';

class DocumentsScreenBodyWidget extends StatefulWidget {
  const DocumentsScreenBodyWidget({Key? key}) : super(key: key);

  @override
  _DocumentsScreenBodyState createState() => _DocumentsScreenBodyState();
}

class _DocumentsScreenBodyState extends State<DocumentsScreenBodyWidget> {
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  late DocumentsViewModel _documentsViewModel;

  final List<int> _list = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _documentsViewModel =
        Provider.of<DocumentsViewModel>(context, listen: true);

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
                    child:
                        BackButtonWidget(onTap: () => Navigator.pop(context))),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text(Titles.documents,
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
                            margin:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            isSearchInput: true,
                            placeholder: '${Titles.search}...',
                            onTap: () => setState,
                            onChange: (text) => {
                                  // TODO DOCUMENTS CONTACTS
                                },
                            onClearTap: () => {
                                  // TODO CLEAR DOCUMENTS SEARCH
                                }))
              ])
            ])),
        body: SizedBox.expand(
            child: Stack(children: [
          /// DOCUMENTS LIST VIEW
          ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.only(
                  left: 16.0,
                  right: 16.0,
                  top: 16.0,
                  bottom: 80.0 + MediaQuery.of(context).padding.bottom),
              itemCount: _documentsViewModel.object == null ? 10 : 1,
              itemBuilder: (context, index) {
                return DocumentListItemWidget(
                    isExpanded: _documentsViewModel.object == null
                        ? _list.contains(index)
                        : true,
                    onTap: () => setState(() => _list.contains(index)
                        ? _list.removeWhere((element) => element == index)
                        : _list.add(index)));
              }),
          const SeparatorWidget(),

          /// FILTER BUTTON
          SafeArea(
              child: Align(
                  alignment: Alignment.bottomCenter,
                  child: FilterButtonWidget(
                      onTap: () =>
                          _documentsViewModel.showFilesFilterSheet(context)

                      // onClearTap: () => {}
                      ))),

          /// INDICATOR
          _documentsViewModel.loadingStatus == LoadingStatus.searching
              ? const LoadingIndicatorWidget()
              : Container()
        ])));
  }
}
