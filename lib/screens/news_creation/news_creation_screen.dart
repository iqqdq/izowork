import 'package:flutter/material.dart';
import 'package:izowork/models/news_creation_view_model.dart';
import 'package:izowork/screens/news_creation/news_creation_screen_body.dart';
import 'package:provider/provider.dart';

class NewsCreationScreenWidget extends StatelessWidget {
  const NewsCreationScreenWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => NewsCreationViewModel(),
        child: const NewsCreationScreenBodyWidget());
  }
}
