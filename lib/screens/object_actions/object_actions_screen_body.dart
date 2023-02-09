import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/titles.dart';
import 'package:izowork/models/object_actions_view_model.dart';
import 'package:izowork/components/loading_status.dart';
import 'package:izowork/screens/object_actions/views/object_action_list_item_widget.dart';
import 'package:izowork/views/back_button_widget.dart';
import 'package:izowork/views/floating_button_widget.dart';
import 'package:izowork/views/loading_indicator_widget.dart';
import 'package:izowork/views/separator_widget.dart';
import 'package:provider/provider.dart';

class ObjectActionsScreenBodyWidget extends StatefulWidget {
  const ObjectActionsScreenBodyWidget({Key? key}) : super(key: key);

  @override
  _ObjectActionsScreenBodyState createState() =>
      _ObjectActionsScreenBodyState();
}

class _ObjectActionsScreenBodyState
    extends State<ObjectActionsScreenBodyWidget> {
  late ObjectActionsViewModel _objectActionsViewModel;

  @override
  Widget build(BuildContext context) {
    _objectActionsViewModel =
        Provider.of<ObjectActionsViewModel>(context, listen: true);

    return Scaffold(
        backgroundColor: HexColors.white,
        appBar: AppBar(
            centerTitle: true,
            elevation: 0.0,
            systemOverlayStyle: SystemUiOverlayStyle.dark,
            backgroundColor: Colors.transparent,
            leading: Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: BackButtonWidget(onTap: () => Navigator.pop(context))),
            title: Text(Titles.actions,
                style: TextStyle(
                    overflow: TextOverflow.ellipsis,
                    fontFamily: 'PT Root UI',
                    fontSize: 18.0,
                    fontWeight: FontWeight.w700,
                    color: HexColors.black))),
        floatingActionButton: FloatingButtonWidget(
            onTap: () =>
                _objectActionsViewModel.showActionCreateScreen(context)),
        body: SizedBox.expand(
            child: Stack(children: [
          /// ACTION LIST
          ListView.builder(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).padding.bottom == 0.0
                      ? 12.0
                      : MediaQuery.of(context).padding.bottom),
              itemCount: _objectActionsViewModel.list.length,
              itemBuilder: (context, index) {
                return ObjectActionListItemWidget(
                  text: _objectActionsViewModel.list[index],
                  dateTime: DateTime.now().add(Duration(days: index)),
                  onUserTap: () =>
                      _objectActionsViewModel.showProfileScreen(context),
                );
              }),

          /// INDICATOR
          _objectActionsViewModel.loadingStatus == LoadingStatus.searching
              ? const LoadingIndicatorWidget()
              : Container()
        ])));
  }
}
