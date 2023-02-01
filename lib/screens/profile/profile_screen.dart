import 'package:flutter/material.dart';
import 'package:izowork/entities/response/user.dart';
import 'package:izowork/models/profile_view_model.dart';
import 'package:izowork/screens/profile/profile_screen_body.dart';
import 'package:provider/provider.dart';

class ProfileScreenWidget extends StatelessWidget {
  final User? user;
  final Function(User) onPop;

  const ProfileScreenWidget({Key? key, this.user, required this.onPop})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => ProfileViewModel(user),
        child: ProfileScreenBodyWidget(onPop: onPop));
  }
}
