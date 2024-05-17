import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';

import 'package:izowork/components/components.dart';
import 'package:izowork/screens/object/object_page/object_page_screen.dart';
import 'package:izowork/screens/object/object_actions/object_actions_screen.dart';
import 'package:izowork/screens/phase/phase_screen.dart';
import 'package:izowork/repositories/repositories.dart';
import 'package:izowork/views/views.dart';

class ObjectPageViewScreenWidget extends StatefulWidget {
  final String id;
  final String? phaseId;

  const ObjectPageViewScreenWidget({
    Key? key,
    required this.id,
    this.phaseId,
  }) : super(key: key);

  @override
  _ObjectPageViewScreenState createState() => _ObjectPageViewScreenState();
}

class _ObjectPageViewScreenState extends State<ObjectPageViewScreenWidget> {
  final PageController _pageController = PageController(initialPage: 0);
  List<Widget>? _pages;
  int _index = 0;

  @override
  void initState() {
    _pages = [
      ObjectPageScreenWidget(
        id: widget.id,
        onCoordCopy: () => Toast().showTopToast(context, Titles.didCopied),
      ),
      ObjectActionsScreenWidget(id: widget.id)
    ];

    super.initState();

    // PUSH FROM NOTIFICATION's SCREEN
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (widget.phaseId == null) return;

      User? user = await GetIt.I<LocalStorageRepositoryInterface>().getUser();
      if (user == null) return;

      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PhaseScreenWidget(
                    id: widget.phaseId!,
                    user: user,
                  )),
        );
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: HexColors.white,
        appBar: AppBar(
          toolbarHeight: 64.0,
          titleSpacing: 0.0,
          elevation: 0.0,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          backgroundColor: HexColors.white,
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
                  width: MediaQuery.of(context).size.width - 40.0,
                  titles: const [Titles.object, Titles.actions],
                  backgroundColor: HexColors.grey10,
                  activeColor: HexColors.black,
                  disableColor: HexColors.grey40,
                  thumbColor: HexColors.white,
                  borderColor: HexColors.grey20,
                  onTap: (index) => {
                        FocusScope.of(context).unfocus(),
                        setState(() => _index = index),
                        _pageController.animateToPage(_index,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.fastOutSlowIn)
                      }),
            )
          ]),
        ),
        body: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: _pages!,
          onPageChanged: (page) => setState(() => _index = page),
        ));
  }
}
