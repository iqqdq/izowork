import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/models/companies_view_model.dart';
import 'package:izowork/screens/companies/views/companies_list_item_widget.dart';
import 'package:izowork/views/back_button_widget.dart';
import 'package:izowork/views/filter_button_widget.dart';
import 'package:izowork/views/input_widget.dart';
import 'package:izowork/components/loading_status.dart';
import 'package:izowork/components/titles.dart';
import 'package:izowork/views/loading_indicator_widget.dart';
import 'package:izowork/views/separator_widget.dart';
import 'package:provider/provider.dart';

class CompaniesScreenBodyWidget extends StatefulWidget {
  const CompaniesScreenBodyWidget({Key? key}) : super(key: key);

  @override
  _CompaniesScreenBodyState createState() => _CompaniesScreenBodyState();
}

class _CompaniesScreenBodyState extends State<CompaniesScreenBodyWidget> {
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  late CompaniesViewModel _companiesViewModel;

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
    _companiesViewModel =
        Provider.of<CompaniesViewModel>(context, listen: true);

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
                  Text(Titles.companies,
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
                                  // TODO SEARCH COMPANIES
                                },
                            onClearTap: () => {
                                  // TODO CLEAR COMPANIES SEARCH
                                }))
              ])
            ])),
        body: SizedBox.expand(
            child: Stack(children: [
          /// COMPANIES LIST VIEW
          ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.only(
                  left: 16.0,
                  right: 16.0,
                  top: 16.0,
                  bottom: 60.0 + MediaQuery.of(context).padding.bottom),
              itemCount: 10,
              itemBuilder: (context, index) {
                return CompaniesListItemWidget(
                    onTap: () => _companiesViewModel.showCompanyPageViewScreen(
                        context, index));
              }),
          const SeparatorWidget(),

          /// FILTER BUTTON
          SafeArea(
              child: Align(
                  alignment: Alignment.bottomCenter,
                  child: FilterButtonWidget(
                    onTap: () =>
                        _companiesViewModel.showCompaniesFilterSheet(context),
                    // onClearTap: () => {}
                  ))),

          /// INDICATOR
          _companiesViewModel.loadingStatus == LoadingStatus.searching
              ? const LoadingIndicatorWidget()
              : Container()
        ])));
  }
}
