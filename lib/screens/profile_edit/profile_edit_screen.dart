import 'package:flutter/material.dart';
import 'package:izowork/models/profile_edit_view_model.dart';
import 'package:izowork/screens/profile_edit/profile_edit_screen_body.dart';
import 'package:provider/provider.dart';

class ProfileEditScreenWidget extends StatelessWidget {
  const ProfileEditScreenWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => ProfileEditViewModel(),
        child: const ProfileEditScreenBodyWidget());
  }
}
