import 'package:flutter/material.dart';
import 'package:izowork/entities/response/news.dart';
import 'package:izowork/models/news_create_view_model.dart';
import 'package:izowork/screens/news_create/news_create_screen_body.dart';
import 'package:provider/provider.dart';

class NewsCreateScreenWidget extends StatelessWidget {
  final Function(News) onPop;
  const NewsCreateScreenWidget({Key? key, required this.onPop})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => NewsCreateViewModel(),
        child: NewsCreateScreenBodyWidget(onPop: onPop));
  }
}