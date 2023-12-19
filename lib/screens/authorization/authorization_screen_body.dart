import 'package:flutter/material.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/models/authorization_view_model.dart';
import 'package:izowork/views/button_widget.dart';
import 'package:izowork/views/input_widget.dart';
import 'package:izowork/components/loading_status.dart';
import 'package:izowork/components/titles.dart';
import 'package:izowork/views/loading_indicator_widget.dart';
import 'package:izowork/views/transparent_button_widget_widget.dart';
import 'package:provider/provider.dart';

class AuthorizationScreenBodyWidget extends StatefulWidget {
  const AuthorizationScreenBodyWidget({Key? key}) : super(key: key);

  @override
  _AuthorizationScreenBodyState createState() =>
      _AuthorizationScreenBodyState();
}

class _AuthorizationScreenBodyState
    extends State<AuthorizationScreenBodyWidget> {
  final TextEditingController _loginTextEditingController =
      TextEditingController();
  final FocusNode _loginFocusNode = FocusNode();
  final TextEditingController _passwordTextEditingController =
      TextEditingController();
  final FocusNode _passwordFocusNode = FocusNode();

  late AuthorizationViewModel _authorizationViewModel;

  @override
  void dispose() {
    _loginTextEditingController.dispose();
    _loginFocusNode.dispose();
    _passwordTextEditingController.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _authorizationViewModel = Provider.of<AuthorizationViewModel>(
      context,
      listen: true,
    );

    return Scaffold(
        backgroundColor: HexColors.white,
        body: SizedBox.expand(
            child: Stack(children: [
          Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            ListView(
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                shrinkWrap: true,
                children: [
                  Text(Titles.authorization,
                      style: TextStyle(
                          color: HexColors.black,
                          fontSize: 32.0,
                          fontFamily: 'PT Root UI',
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 24.0),

                  /// LOGIN INPUT
                  InputWidget(
                    height: 56.0,
                    textEditingController: _loginTextEditingController,
                    focusNode: _loginFocusNode,
                    textInputType: TextInputType.emailAddress,
                    textCapitalization: TextCapitalization.none,
                    margin: EdgeInsets.zero,
                    placeholder: Titles.login,
                    onTap: () => setState(() {}),
                    onChange: (text) => setState(() {}),
                    onClearTap: () => setState(() {}),
                    onEditingComplete: (() =>
                        setState(() => _passwordFocusNode.requestFocus())),
                  ),
                  const SizedBox(height: 16.0),

                  /// PASSWORD INPUT
                  InputWidget(
                    height: 56.0,
                    textEditingController: _passwordTextEditingController,
                    focusNode: _passwordFocusNode,
                    obscureText: true,
                    textCapitalization: TextCapitalization.none,
                    margin: EdgeInsets.zero,
                    placeholder: Titles.password,
                    onTap: () => setState(() {}),
                    onChange: (text) => setState(() {}),
                    onClearTap: () => setState(() {}),
                  ),
                  const SizedBox(height: 24.0),
                  ButtonWidget(
                      isDisabled: _loginTextEditingController.text.isEmpty ||
                          _passwordTextEditingController.text.isEmpty,
                      title: Titles.enter,
                      margin: EdgeInsets.zero,
                      onTap: () => _authorizationViewModel.authorize(
                            context,
                            _loginTextEditingController.text,
                            _passwordTextEditingController.text,
                          )),
                  const SizedBox(height: 24.0),
                  TransparentButtonWidget(
                    title: Titles.forgotPassword,
                    margin: EdgeInsets.zero,
                    onTap: () =>
                        _authorizationViewModel.showRecoveryScreen(context),
                  )
                ])
          ]),

          /// INDICATOR
          _authorizationViewModel.loadingStatus == LoadingStatus.searching
              ? const LoadingIndicatorWidget()
              : Container()
        ])));
  }
}
