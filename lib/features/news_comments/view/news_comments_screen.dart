import 'package:flutter/material.dart';
import 'package:izowork/features/news_comments/view_model/news_comments_view_model.dart';
import 'package:izowork/models/models.dart';

import 'package:izowork/features/news_comments/view/news_comments_screen_body.dart';
import 'package:provider/provider.dart';

class NewsCommentsScreenWidget extends StatelessWidget {
  final News news;

  const NewsCommentsScreenWidget({
    Key? key,
    required this.news,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => NewsCommentsViewModel(news),
      child: const NewsCommentsScreenBodyWidget(),
    );
  }
}
