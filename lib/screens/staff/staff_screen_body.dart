import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:izowork/components/debouncer.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/pagination.dart';
import 'package:izowork/models/staff_view_model.dart';
import 'package:izowork/screens/staff/views/staff_list_item_widget.dart';
import 'package:izowork/views/back_button_widget.dart';
import 'package:izowork/views/input_widget.dart';
import 'package:izowork/components/loading_status.dart';
import 'package:izowork/components/titles.dart';
import 'package:izowork/views/loading_indicator_widget.dart';
import 'package:izowork/views/separator_widget.dart';
import 'package:provider/provider.dart';

class StaffScreenBodyWidget extends StatefulWidget {
  const StaffScreenBodyWidget({Key? key}) : super(key: key);

  @override
  _StaffScreenBodyState createState() => _StaffScreenBodyState();
}

class _StaffScreenBodyState extends State<StaffScreenBodyWidget> {
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  final ScrollController _scrollController = ScrollController();
  final Debouncer _debouncer = Debouncer(milliseconds: 500);

  late StaffViewModel _staffViewModel;

  Pagination _pagination = Pagination(offset: 0, size: 50);
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _pagination.offset += 1;
        _staffViewModel.getUserList(
            pagination: _pagination, search: _textEditingController.text);
      }
    });
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _focusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // MARK: -
  // MARK: - FUNCTIONS

  Future _onRefresh() async {
    _pagination = Pagination(offset: 0, size: 50);
    _staffViewModel.getUserList(
        pagination: _pagination, search: _textEditingController.text);
  }

  @override
  Widget build(BuildContext context) {
    _staffViewModel = Provider.of<StaffViewModel>(context, listen: true);

    return Scaffold(
        backgroundColor: HexColors.white,
        appBar: AppBar(
            toolbarHeight: 116.0,
            titleSpacing: 0.0,
            elevation: 0.0,
            systemOverlayStyle: SystemUiOverlayStyle.dark,
            backgroundColor: Colors.transparent,
            automaticallyImplyLeading: false,
            title: Column(children: [
              Stack(children: [
                Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child:
                        BackButtonWidget(onTap: () => Navigator.pop(context))),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text(Titles.staff,
                      style: TextStyle(
                          color: HexColors.black,
                          fontSize: 18.0,
                          fontFamily: 'PT Root UI',
                          fontWeight: FontWeight.bold)),
                ])
              ]),
              const SizedBox(height: 16.0),
              Row(children: [
                Expanded(
                    child:

                        /// SEARCH INPUT
                        InputWidget(
                            textEditingController: _textEditingController,
                            focusNode: _focusNode,
                            margin:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            isSearchInput: true,
                            placeholder: '${Titles.search}...',
                            onTap: () => setState,
                            onChange: (text) => {
                                  setState(() => _isSearching = true),
                                  _debouncer.run(() {
                                    _pagination =
                                        Pagination(offset: 0, size: 50);

                                    _staffViewModel
                                        .getUserList(
                                            pagination: _pagination,
                                            search: _textEditingController.text)
                                        .then((value) => setState(
                                            () => _isSearching = false));
                                  })
                                },
                            onClearTap: () => {
                                  _pagination.offset = 0,
                                  _staffViewModel.getUserList(
                                      pagination: _pagination)
                                }))
              ])
            ])),
        body: SizedBox.expand(
            child: Stack(children: [
          /// STAFF LIST VIEW
          RefreshIndicator(
              onRefresh: _onRefresh,
              color: HexColors.primaryMain,
              backgroundColor: HexColors.white,
              child: ListView.builder(
                  controller: _scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.only(
                      left: 16.0,
                      right: 16.0,
                      top: 16.0,
                      bottom: MediaQuery.of(context).padding.bottom == 0.0
                          ? 12.0
                          : MediaQuery.of(context).padding.bottom),
                  shrinkWrap: true,
                  itemCount: _staffViewModel.users.length,
                  itemBuilder: (context, index) {
                    return StaffListItemWidget(
                        user: _staffViewModel.users[index],
                        onUserTap: () => _staffViewModel.showProfileScreen(
                            context, _staffViewModel.users[index]),
                        onLinkTap: _staffViewModel.users[index].social.isEmpty
                            ? null
                            : (url) => _staffViewModel.openUrl(url),
                        onChatTap: () =>
                            _staffViewModel.showDialogScreen(context));
                  })),
          const SeparatorWidget(),

          /// EMPTY LIST TEXT
          _staffViewModel.loadingStatus == LoadingStatus.completed &&
                  _staffViewModel.users.isEmpty &&
                  !_isSearching
              ? Center(
                  child: Padding(
                      padding: const EdgeInsets.only(
                          left: 20.0, right: 20.0, bottom: 100.0),
                      child: Text(Titles.noResult,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 16.0,
                              color: HexColors.grey50))))
              : Container(),

          /// INDICATOR
          _staffViewModel.loadingStatus == LoadingStatus.searching ||
                  _isSearching
              ? const LoadingIndicatorWidget()
              : Container()
        ])));
  }
}
