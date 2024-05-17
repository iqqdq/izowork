import 'package:flutter/material.dart';
import 'package:izowork/notifiers/news_page_view_model.dart';
import 'package:izowork/screens/news_page/news_page_screen_body.dart';
import 'package:provider/provider.dart';

class NewsPageScreenWidget extends StatelessWidget {
  final String id;

  const NewsPageScreenWidget({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => NewsPageViewModel(id),
      child: const NewsPageScreenBodyWidget(),
    );
  }
}
