import 'package:flutter/material.dart';
import 'package:izowork/features/news/view_model/news_view_model.dart';
import 'package:izowork/features/news/view/news_screen_body.dart';
import 'package:provider/provider.dart';

class NewsScreenWidget extends StatelessWidget {
  const NewsScreenWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => NewsViewModel(),
      child: const NewsScreenBodyWidget(),
    );
  }
}
