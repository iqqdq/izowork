import 'package:flutter/material.dart';
import 'package:izowork/components/components.dart';
import 'package:izowork/notifiers/notifiers.dart';
import 'package:izowork/screens/recovery/recovery_screen.dart';
import 'package:izowork/screens/tab_controller/tab_controller_screen.dart';
import 'package:izowork/views/views.dart';
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
                  Text(
                    Titles.authorization,
                    style: TextStyle(
                      color: HexColors.black,
                      fontSize: 32.0,
                      fontFamily: 'PT Root UI',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
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
                      onEditingComplete: () => {
                            setState(() {}),
                            Future.delayed(Duration.zero,
                                () => _passwordFocusNode.requestFocus())
                          }),
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
                    onTap: () => _authorize(),
                  ),
                  const SizedBox(height: 24.0),
                  TransparentButtonWidget(
                    title: Titles.forgotPassword,
                    margin: EdgeInsets.zero,
                    onTap: () => _showRecoveryScreen(),
                  )
                ]),
          ]),

          /// INDICATOR
          _authorizationViewModel.loadingStatus == LoadingStatus.searching
              ? const LoadingIndicatorWidget()
              : Container()
        ]),
      ),
    );
  }

  // MARK: -
  // MARK: - FUNCTIONS

  void _authorize() async {
    await _authorizationViewModel.authorize(
      _loginTextEditingController.text,
      _passwordTextEditingController.text,
    );

    await _authorizationViewModel.getUserProfile();

    if (_authorizationViewModel.loadingStatus == LoadingStatus.completed) {
      _showTabControllerScreen();
    }
  }

  // MARK: -
  // MARK: - PUSH

  void _showRecoveryScreen() => Navigator.push(context,
      MaterialPageRoute(builder: (context) => const RecoveryScreenWidget()));

  void _showTabControllerScreen() {
    if (_authorizationViewModel.loadingStatus == LoadingStatus.completed) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => const TabControllerScreenWidget()),
        (route) => false,
      );
    }
  }
}
