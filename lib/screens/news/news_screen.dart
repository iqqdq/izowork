import 'package:flutter/material.dart';
import 'package:izowork/notifiers/notifiers.dart';
import 'package:izowork/screens/news/news_screen_body.dart';
import 'package:provider/provider.dart';

class NewsScreenWidget extends StatelessWidget {
  const NewsScreenWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => NewsViewModel(),
        child: const NewsScreenBodyWidget());
  }
}
