import 'package:flutter/material.dart';
import 'package:izowork/models/profile_view_model.dart';
import 'package:izowork/screens/profile/profile_screen_body.dart';
import 'package:provider/provider.dart';

class ProfileScreenWidget extends StatelessWidget {
  final bool isMine;

  const ProfileScreenWidget({Key? key, required this.isMine}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => ProfileViewModel(isMine),
        child: ProfileScreenBodyWidget(isMine: isMine));
  }
}
