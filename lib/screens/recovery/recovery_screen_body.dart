import 'package:flutter/material.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/models/recovery_view_model.dart';
import 'package:izowork/views/back_button_widget.dart';
import 'package:izowork/views/button_widget.dart';
import 'package:izowork/views/input_widget.dart';
import 'package:izowork/components/loading_status.dart';
import 'package:izowork/components/titles.dart';
import 'package:izowork/views/loading_indicator_widget.dart';
import 'package:provider/provider.dart';

class RecoveryScreenBodyWidget extends StatefulWidget {
  const RecoveryScreenBodyWidget({Key? key}) : super(key: key);

  @override
  _RecoveryScreenBodyState createState() => _RecoveryScreenBodyState();
}

class _RecoveryScreenBodyState extends State<RecoveryScreenBodyWidget> {
  final TextEditingController _loginTextEditingController =
      TextEditingController();
  final FocusNode _loginFocusNode = FocusNode();
  late RecoveryViewModel _recoveryViewModel;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _loginTextEditingController.dispose();
    _loginFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _recoveryViewModel = Provider.of<RecoveryViewModel>(context, listen: true);

    return Scaffold(
        backgroundColor: HexColors.white,
        body: SizedBox.expand(
            child: Stack(children: [
          SafeArea(
              child: Padding(
                  padding: const EdgeInsets.only(left: 16.0, top: 12.0),
                  child: BackButtonWidget(
                      title: Titles.back,
                      onTap: () => Navigator.pop(context)))),
          Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            ListView(
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                shrinkWrap: true,
                children: [
                  Text(Titles.passwordRecovery,
                      style: TextStyle(
                          color: HexColors.black,
                          fontSize: 32.0,
                          fontFamily: 'PT Root UI',
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 24.0),
                  Text(Titles.emailToRecovery,
                      style: TextStyle(
                          color: HexColors.grey80,
                          fontSize: 16.0,
                          fontFamily: 'PT Root UI')),
                  const SizedBox(height: 24.0),

                  /// LOGIN INPUT
                  InputWidget(
                      height: 56.0,
                      textEditingController: _loginTextEditingController,
                      focusNode: _loginFocusNode,
                      margin: EdgeInsets.zero,
                      placeholder: Titles.login,
                      onChange: (text) => setState(() {}),
                      onClearTap: () => setState(() {})),
                  const SizedBox(height: 16.0),

                  ButtonWidget(
                      isDisabled: _loginTextEditingController.text.isEmpty ||
                          !_loginTextEditingController.text.contains('@') ||
                          !_loginTextEditingController.text.contains('.'),
                      title: Titles.send,
                      margin: EdgeInsets.zero,
                      onTap: () => _recoveryViewModel.sendUserEmail(
                          context, _loginTextEditingController.text)),
                ]),

            /// INDICATOR
            _recoveryViewModel.loadingStatus == LoadingStatus.searching
                ? const LoadingIndicatorWidget()
                : Container()
          ])
        ])));
  }
}
