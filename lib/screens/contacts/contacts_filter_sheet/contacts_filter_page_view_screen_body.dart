import 'package:flutter/material.dart';
import 'package:izowork/models/contacts_filter_view_model.dart';
import 'package:izowork/screens/contacts/contacts_filter_sheet/contacts_filter_screen.dart';
import 'package:izowork/views/dismiss_indicator_widget.dart';
import 'package:provider/provider.dart';

class ContactsFilter {
  final List<int> tags;
  final List<int> tags2;
  final List<String> params;

  ContactsFilter(this.tags, this.tags2, this.params);
}

class ContactsFilterPageViewScreenBodyWidget extends StatefulWidget {
  final Function(ContactsFilter?) onPop;

  const ContactsFilterPageViewScreenBodyWidget({Key? key, required this.onPop})
      : super(key: key);

  @override
  _ContactsFilterPageViewScreenBodyState createState() =>
      _ContactsFilterPageViewScreenBodyState();
}

class _ContactsFilterPageViewScreenBodyState
    extends State<ContactsFilterPageViewScreenBodyWidget> {
  final PageController _pageController = PageController();
  late ContactsFilterViewModel _contactsFilterViewModel;

  @override
  Widget build(BuildContext context) {
    _contactsFilterViewModel =
        Provider.of<ContactsFilterViewModel>(context, listen: true);

    return Material(
        type: MaterialType.transparency,
        child: ListView(
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            children: [
              /// DISMISS INDICATOR
              const SizedBox(height: 6.0),
              const DismissIndicatorWidget(),
              AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: MediaQuery.of(context).padding.bottom == 0.0
                      ? 260.0
                      : 280.0,
                  child: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      ContactsFilterScreenWidget(
                          options: _contactsFilterViewModel.options,
                          tags: _contactsFilterViewModel.tags,
                          options2: _contactsFilterViewModel.options2,
                          tags2: _contactsFilterViewModel.tags2,
                          onTagTap: (index) =>
                              _contactsFilterViewModel.sortByAlphabet(index),
                          onTag2Tap: (index) =>
                              _contactsFilterViewModel.sortByType(index),
                          onApplyTap: () => {
                                _contactsFilterViewModel.apply((params) => {
                                      widget.onPop(ContactsFilter(
                                          _contactsFilterViewModel.tags,
                                          _contactsFilterViewModel.tags2,
                                          params)),
                                      Navigator.pop(context)
                                    })
                              },
                          onResetTap: () => _contactsFilterViewModel.reset(() =>
                              {widget.onPop(null), Navigator.pop(context)}))
                    ],
                  ))
            ]));
  }
}
