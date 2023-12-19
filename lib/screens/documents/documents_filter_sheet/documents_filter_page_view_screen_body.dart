import 'package:flutter/material.dart';
import 'package:izowork/models/documents_filter_view_model.dart';
import 'package:izowork/screens/documents/documents_filter_sheet/documents_filter_screen.dart';
import 'package:izowork/views/dismiss_indicator_widget.dart';
import 'package:provider/provider.dart';

class DocumentsFilter {
  final List<int> tags;
  final List<int> tags2;
  final List<String> params;

  DocumentsFilter(this.tags, this.tags2, this.params);
}

class DocumentsFilterPageViewScreenBodyWidget extends StatefulWidget {
  final Function(DocumentsFilter?) onPop;

  const DocumentsFilterPageViewScreenBodyWidget({Key? key, required this.onPop})
      : super(key: key);

  @override
  _DocumentsFilterPageViewScreenBodyState createState() =>
      _DocumentsFilterPageViewScreenBodyState();
}

class _DocumentsFilterPageViewScreenBodyState
    extends State<DocumentsFilterPageViewScreenBodyWidget> {
  final PageController _pageController = PageController();
  late DocumentsFilterViewModel _documentsFilterViewModel;

  @override
  Widget build(BuildContext context) {
    _documentsFilterViewModel = Provider.of<DocumentsFilterViewModel>(
      context,
      listen: true,
    );

    return Material(
        type: MaterialType.transparency,
        child: ListView(
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            children: [
              /// DISMISS INDICATOR
              const SizedBox(height: 6.0),
              const DismissIndicatorWidget(),
              SizedBox(
                  height: MediaQuery.of(context).padding.bottom == 0.0
                      ? 264.0
                      : 294.0,
                  child: PageView(
                      controller: _pageController,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        DocumentsFilterScreenWidget(
                            options: _documentsFilterViewModel.options,
                            tags: _documentsFilterViewModel.tags,
                            options2: _documentsFilterViewModel.options2,
                            tags2: _documentsFilterViewModel.tags2,
                            onTagTap: (index) =>
                                _documentsFilterViewModel.sortByAlphabet(index),
                            onTag2Tap: (index) =>
                                _documentsFilterViewModel.sortByDate(index),
                            onApplyTap: () => {
                                  _documentsFilterViewModel.apply((params) => {
                                        widget.onPop(DocumentsFilter(
                                            _documentsFilterViewModel.tags,
                                            _documentsFilterViewModel.tags2,
                                            params)),
                                        Navigator.pop(context)
                                      })
                                },
                            onResetTap: () => _documentsFilterViewModel.reset(
                                () => {
                                      widget.onPop(null),
                                      Navigator.pop(context)
                                    })),
                      ]))
            ]));
  }
}
