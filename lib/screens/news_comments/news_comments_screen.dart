import 'package:flutter/material.dart';
import 'package:izowork/models/news_comments_view_model.dart';
import 'package:izowork/screens/news_comments/news_comments_screen_body.dart';
import 'package:provider/provider.dart';

class NewsCommentsScreenWidget extends StatelessWidget {
  final String tag;
  const NewsCommentsScreenWidget({Key? key, required this.tag})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => NewsCommentsViewModel(),
        child: NewsCommentsScreenBodyWidget(tag: tag));
  }
}
