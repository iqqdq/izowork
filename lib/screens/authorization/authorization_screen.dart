import 'package:flutter/material.dart';
import 'package:izowork/notifiers/notifiers.dart';
import 'package:izowork/screens/authorization/authorization_screen_body.dart';
import 'package:provider/provider.dart';

class AuthorizationScreenWidget extends StatelessWidget {
  const AuthorizationScreenWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => AuthorizationViewModel(),
        child: const AuthorizationScreenBodyWidget());
  }
}
