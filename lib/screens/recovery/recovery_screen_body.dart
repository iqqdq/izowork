import 'package:flutter/material.dart';
import 'package:izowork/components/components.dart';
import 'package:izowork/notifiers/notifiers.dart';
import 'package:izowork/views/views.dart';
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

    WidgetsBinding.instance
        .addPostFrameCallback((_) => _loginFocusNode.requestFocus());
  }

  @override
  void dispose() {
    _loginTextEditingController.dispose();
    _loginFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _recoveryViewModel = Provider.of<RecoveryViewModel>(
      context,
      listen: true,
    );

    return Scaffold(
        backgroundColor: HexColors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: BackButtonWidget(onTap: () => Navigator.pop(context))),
        ),
        body: Stack(children: [
          ListView(
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.only(
                  top: 80.0,
                  left: 16.0,
                  right: 16.0,
                  bottom: MediaQuery.of(context).viewInsets.bottom),
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
                    onTap: () => _recoveryViewModel
                        .sendUserEmail(_loginTextEditingController.text)
                        .then((value) => Navigator.pop(context))),
                const SizedBox(height: 60.0)
              ]),
          Center(
            child:

                /// INDICATOR
                _recoveryViewModel.loadingStatus == LoadingStatus.searching
                    ? const LoadingIndicatorWidget()
                    : Container(),
          )
        ]));
  }
}
