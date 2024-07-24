import 'package:flutter/material.dart';
import 'package:izowork/features/profile_edit/view_model/profile_edit_view_model.dart';
import 'package:izowork/models/models.dart';
import 'package:izowork/features/profile_edit/view/profile_edit_screen_body.dart';
import 'package:provider/provider.dart';

class ProfileEditScreenWidget extends StatelessWidget {
  final User user;
  final Function(User) onPop;

  const ProfileEditScreenWidget(
      {Key? key, required this.user, required this.onPop})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProfileEditViewModel(user),
      child: ProfileEditScreenBodyWidget(onPop: onPop),
    );
  }
}
