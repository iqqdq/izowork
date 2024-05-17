import 'package:flutter/material.dart';
import 'package:izowork/notifiers/domain.dart';
import 'package:izowork/screens/news/news_filter_sheet/news_filter_page_view_screen_body.dart';
import 'package:provider/provider.dart';

class NewsFilterPageViewScreenWidget extends StatelessWidget {
  final NewsFilter? newsFilter;
  final Function(NewsFilter?) onPop;

  const NewsFilterPageViewScreenWidget(
      {Key? key, this.newsFilter, required this.onPop})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => NewsFilterViewModel(newsFilter),
        child: NewsFilterPageViewScreenBodyWidget(onPop: onPop));
  }
}
