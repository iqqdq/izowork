import 'package:flutter/material.dart';
import 'package:izowork/models/news_filter_view_model.dart';
import 'package:izowork/screens/news/news_filter_sheet/news_filter/news_filter_screen_body.dart';
import 'package:provider/provider.dart';

class NewsFilterScreenWidget extends StatelessWidget {
  final VoidCallback onDeveloperTap;
  final VoidCallback onApplyTap;
  final VoidCallback onResetTap;

  const NewsFilterScreenWidget(
      {Key? key,
      required this.onDeveloperTap,
      required this.onApplyTap,
      required this.onResetTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => NewsFilterViewModel(),
        child: NewsFilterScreenBodyWidget(
            onDeveloperTap: onDeveloperTap,
            onApplyTap: onApplyTap,
            onResetTap: onResetTap));
  }
}
