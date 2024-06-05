import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:izowork/notifiers/notifiers.dart';
import 'package:izowork/screens/news_page/news_page_screen_body.dart';

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
