import 'package:flutter/material.dart';
import 'package:izowork/features/news_page/view_model/news_page_view_model.dart';
import 'package:provider/provider.dart';

import 'package:izowork/features/news_page/view/news_page_screen_body.dart';

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
