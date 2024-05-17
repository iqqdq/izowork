import 'package:flutter/material.dart';
import 'package:izowork/models/models.dart';
import 'package:izowork/notifiers/domain.dart';
import 'package:izowork/screens/news_comments/news_comments_screen_body.dart';
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
        child: const NewsCommentsScreenBodyWidget());
  }
}
