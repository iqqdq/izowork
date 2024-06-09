import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:izowork/screens/company/company_actions/company_actions_screen.dart';
import 'package:izowork/screens/company/company_page/company_page_screen.dart';
import 'package:izowork/components/components.dart';
import 'package:izowork/models/models.dart';
import 'package:izowork/views/views.dart';

class CompanyPageViewScreenWidget extends StatefulWidget {
  final String id;
  final Function(Company?) onPop;

  const CompanyPageViewScreenWidget({
    Key? key,
    required this.id,
    required this.onPop,
  }) : super(key: key);

  @override
  _CompanyPageViewScreenState createState() => _CompanyPageViewScreenState();
}

class _CompanyPageViewScreenState extends State<CompanyPageViewScreenWidget> {
  final PageController _pageController = PageController(initialPage: 0);
  List<Widget>? _pages;
  int _index = 0;

  Company? _company;

  @override
  void initState() {
    _pages = [
      CompanyPageScreenWidget(
        id: widget.id,
        onPop: (company) => _company = company,
      ),
      CompanyActionsScreenWidget(id: widget.id)
    ];

    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    widget.onPop(_company);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 64.0,
        titleSpacing: 0.0,
        backgroundColor: HexColors.white90,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        automaticallyImplyLeading: false,
        title:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: BackButtonWidget(onTap: () => Navigator.pop(context)),
          ),

          /// SEGMENTED CONTROL
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: SegmentedControlWidget(
                titles: const [
                  Titles.company,
                  Titles.actions,
                ],
                initialIndex: _index,
                width: MediaQuery.of(context).size.width - 40.0,
                backgroundColor: HexColors.grey10,
                activeColor: HexColors.black,
                disableColor: HexColors.grey40,
                thumbColor: HexColors.white,
                borderColor: HexColors.grey20,
                onTap: (index) => {
                      FocusScope.of(context).unfocus(),
                      setState(() => _index = index),
                      _pageController.animateToPage(
                        _index,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.fastOutSlowIn,
                      )
                    }),
          )
        ]),
      ),
      body: Container(
        color: HexColors.white90,
        child: PageView(
            controller: _pageController,
            children: _pages ?? [],
            onPageChanged: (page) => {
                  setState(() => _index = page),
                  FocusScope.of(context).unfocus()
                }),
      ),
    );
  }
}
