import 'package:flutter/material.dart';
import 'package:izowork/models/news_search_view_model.dart';
import 'package:izowork/screens/news/news_filter_sheet/news_filter_search/news_filter_search_screen_body.dart';
import 'package:provider/provider.dart';

class NewsFilterSearchScreenWidget extends StatelessWidget {
  final VoidCallback onPop;

  const NewsFilterSearchScreenWidget({Key? key, required this.onPop})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => NewsSearchViewModel(),
        child: NewsFilterSearchBodyScreenWidget(onPop: onPop));
  }
}
