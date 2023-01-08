import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/titles.dart';
import 'package:izowork/models/news_comments_view_model.dart';
import 'package:izowork/screens/news_comments/views/comment_list_item_widget.dart';
import 'package:izowork/views/back_button_widget.dart';
import 'package:izowork/components/loading_status.dart';
import 'package:izowork/views/chat_message_bar_widget.dart';
import 'package:izowork/views/loading_indicator_widget.dart';
import 'package:izowork/views/title_widget.dart';
import 'package:provider/provider.dart';

class NewsCommentsScreenBodyWidget extends StatefulWidget {
  final String tag;

  const NewsCommentsScreenBodyWidget({Key? key, required this.tag})
      : super(key: key);

  @override
  _NewsCommentsScreenBodyState createState() => _NewsCommentsScreenBodyState();
}

class _NewsCommentsScreenBodyState extends State<NewsCommentsScreenBodyWidget> {
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  late NewsCommentsViewModel _newsCommentsViewModel;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _newsCommentsViewModel =
        Provider.of<NewsCommentsViewModel>(context, listen: true);

    final _day = DateTime.now().day.toString().length == 1
        ? '0${DateTime.now().day}'
        : '${DateTime.now().day}';
    final _month = DateTime.now().month.toString().length == 1
        ? '0${DateTime.now().month}'
        : '${DateTime.now().month}';
    final _year = '${DateTime.now().year}';

    return Scaffold(
        backgroundColor: HexColors.white,
        appBar: AppBar(
            toolbarHeight: 84.0,
            titleSpacing: 16.0,
            elevation: 0.0,
            systemOverlayStyle: SystemUiOverlayStyle.dark,
            backgroundColor: Colors.transparent,
            automaticallyImplyLeading: false,
            title: Row(children: [
              BackButtonWidget(onTap: () => Navigator.pop(context)),
              const SizedBox(width: 12.0),

              /// IMAGE
              Hero(
                  tag: widget.tag,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: CachedNetworkImage(
                          imageUrl:
                              'https://images.unsplash.com/photo-1554469384-e58fac16e23a?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NHx8YnVpbGRpbmd8ZW58MHx8MHx8&w=1000&q=80',
                          width: 85,
                          height: 47.0,
                          memCacheWidth: 85 *
                              (MediaQuery.of(context).devicePixelRatio).round(),
                          memCacheHeight: 47 *
                              (MediaQuery.of(context).devicePixelRatio).round(),
                          fit: BoxFit.cover))),
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    const TitleWidget(text: 'Имя Фамилия', isSmall: true),
                    const TitleWidget(text: 'Заголовок новости'),
                    TitleWidget(text: '$_day.$_month.$_year', isSmall: true)
                  ]))
            ])),
        body: SizedBox.expand(
            child: Stack(children: [
          Column(children: [
            Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
                width: double.infinity,
                color: HexColors.grey20,
                child: Text('${Titles.comments} (15):',
                    style: TextStyle(
                        color: HexColors.black,
                        fontSize: 14.0,
                        fontFamily: 'PT Root UI',
                        fontWeight: FontWeight.w500))),
            Expanded(
                child: Container(
              color: HexColors.grey10,
              child:

                  /// NEWS LIST VIEW
                  ListView.builder(
                      shrinkWrap: true,
                      padding: const EdgeInsets.only(
                          left: 16.0, right: 16.0, top: 12.0, bottom: 12.0),
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        return CommentListItemWidget(
                            tag: index.toString(),
                            dateTime:
                                DateTime.now().subtract(Duration(days: index)),
                            onTap: () => {},
                            onUserTap: () => {},
                            onShowCommentsTap: () => {});
                      }),
            )),
            Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).padding.bottom == 0.0
                            ? 0.0
                            : MediaQuery.of(context).padding.bottom * 0.75),
                    child: ChatMessageBarWidget(
                        textEditingController: _textEditingController,
                        focusNode: _focusNode,
                        hintText: Titles.comment + '...',
                        onSendTap: () => {}))),
          ]),

          /// INDICATOR
          _newsCommentsViewModel.loadingStatus == LoadingStatus.searching
              ? const LoadingIndicatorWidget()
              : Container()
        ])));
  }
}
