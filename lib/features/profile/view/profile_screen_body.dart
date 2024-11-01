import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:izowork/features/profile/view_model/profile_view_model.dart';
import 'package:provider/provider.dart';

import 'package:izowork/components/components.dart';
import 'package:izowork/models/models.dart';

import 'package:izowork/api/api.dart';
import 'package:izowork/features/profile_edit/view/profile_edit_screen.dart';
import 'package:izowork/views/views.dart';

class ProfileScreenBodyWidget extends StatefulWidget {
  final bool isMine;
  final Function(User) onPop;

  const ProfileScreenBodyWidget({
    Key? key,
    required this.isMine,
    required this.onPop,
  }) : super(key: key);

  @override
  _ProfileScreenBodyState createState() => _ProfileScreenBodyState();
}

class _ProfileScreenBodyState extends State<ProfileScreenBodyWidget> {
  late ProfileViewModel _profileViewModel;

  @override
  void dispose() {
    if (_profileViewModel.user != null) {
      widget.onPop(_profileViewModel.user!);
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _profileViewModel = Provider.of<ProfileViewModel>(
      context,
      listen: true,
    );

    String? _url = _profileViewModel.user == null
        ? _profileViewModel.currentUser.avatar == null
            ? null
            : _profileViewModel.currentUser.avatar!.isEmpty
                ? null
                : _profileViewModel.currentUser.avatar
        : _profileViewModel.user!.avatar == null
            ? null
            : _profileViewModel.user!.avatar!.isEmpty
                ? null
                : _profileViewModel.user!.avatar;

    return Scaffold(
      backgroundColor: HexColors.white,
      appBar: AppBar(
          titleSpacing: 0.0,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          title: Column(children: [
            Stack(children: [
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: BackButtonWidget(onTap: () => Navigator.pop(context)),
              ),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(Titles.profile,
                    style: TextStyle(
                      color: HexColors.black,
                      fontSize: 18.0,
                      fontFamily: 'PT Root UI',
                      fontWeight: FontWeight.bold,
                    )),
              ])
            ])
          ])),
      body: Stack(children: [
        ListView(
            padding: EdgeInsets.only(
                left: 16.0,
                right: 16.0,
                top: 20.0,
                bottom: MediaQuery.of(context).padding.bottom + 60.0),
            children: [
              /// AVATAR
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                AvatarWidget(
                  url: avatarUrl,
                  endpoint: _url,
                  size: 80.0,
                ),
              ]),
              const SizedBox(height: 14.0),

              /// NAME
              SelectionArea(
                child: Text(
                  _profileViewModel.user?.name ??
                      _profileViewModel.currentUser.name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: HexColors.black,
                      fontSize: 18.0,
                      fontFamily: 'PT Root UI',
                      fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 24.0),

              /// POST
              const TitleWidget(
                  text: Titles.post,
                  padding: EdgeInsets.only(bottom: 4.0),
                  isSmall: true),
              SelectionArea(
                child: Text(
                    _profileViewModel.user?.post ??
                        _profileViewModel.currentUser.post,
                    style: TextStyle(
                      color: HexColors.black,
                      fontSize: 14.0,
                      fontFamily: 'PT Root UI',
                    )),
              ),
              const SizedBox(height: 16.0),
              const SeparatorWidget(),
              const SizedBox(height: 16.0),

              /// RATING
              const TitleWidget(
                  text: Titles.rating,
                  padding: EdgeInsets.only(bottom: 4.0),
                  isSmall: true),
              SelectionArea(
                child: Text((_profileViewModel.rating ?? 0).toString() + ' %',
                    style: TextStyle(
                      color: HexColors.black,
                      fontSize: 14.0,
                      fontFamily: 'PT Root UI',
                    )),
              ),
              const SizedBox(height: 16.0),
              const SeparatorWidget(),
              const SizedBox(height: 16.0),

              /// EMAIL
              const TitleWidget(
                  text: Titles.email,
                  padding: EdgeInsets.only(bottom: 4.0),
                  isSmall: true),
              SelectionArea(
                child: Text(
                    _profileViewModel.user?.email ??
                        _profileViewModel.currentUser.email,
                    style: TextStyle(
                      color: HexColors.black,
                      fontSize: 14.0,
                      fontFamily: 'PT Root UI',
                    )),
              ),
              const SizedBox(height: 16.0),
              const SeparatorWidget(),
              const SizedBox(height: 16.0),

              /// PHONE
              const TitleWidget(
                  text: Titles.phone,
                  padding: EdgeInsets.only(bottom: 4.0),
                  isSmall: true),
              SelectionArea(
                child: Text(
                    _profileViewModel.user?.phone ??
                        _profileViewModel.currentUser.phone,
                    style: TextStyle(
                        color: HexColors.black,
                        fontSize: 14.0,
                        fontFamily: 'PT Root UI')),
              ),
              const SizedBox(height: 16.0),
              _profileViewModel.user == null
                  ? Container()
                  : _profileViewModel.user!.social.isEmpty
                      ? Container()
                      : const SeparatorWidget(),
              const SizedBox(height: 16.0),

              /// SOCIAL
              _profileViewModel.user == null
                  ? Container()
                  : _profileViewModel.user!.social.isEmpty
                      ? Container()
                      : const TitleWidget(
                          text: Titles.socialLinks,
                          padding: EdgeInsets.only(bottom: 4.0),
                          isSmall: true),
              _profileViewModel.user == null
                  ? Container()
                  : _profileViewModel.user!.social.isEmpty
                      ? Container()
                      : ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          itemCount: _profileViewModel.user?.social.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              key: ValueKey(
                                  _profileViewModel.user?.social[index]),
                              padding: const EdgeInsets.only(bottom: 4.0),
                              child: InkWell(
                                highlightColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                onTap: () => _profileViewModel.openUrl(
                                    _profileViewModel.user?.social[index] ??
                                        _profileViewModel
                                            .currentUser.social[index]),
                                child: Text(
                                  _profileViewModel.user?.social[index] ??
                                      _profileViewModel
                                          .currentUser.social[index],
                                  style: TextStyle(
                                    color: HexColors.primaryDark,
                                    fontSize: 14.0,
                                    fontFamily: 'PT Root UI',
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            );
                          })
            ]),

        const SeparatorWidget(),

        widget.isMine
            ? Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).padding.bottom == 0.0
                            ? 12.0
                            : MediaQuery.of(context).padding.bottom),
                    child: ButtonWidget(
                        title: Titles.edit,
                        onTap: () => _showProfileEditScreen())))
            : Container(),

        /// INDICATOR
        _profileViewModel.loadingStatus == LoadingStatus.searching
            ? const LoadingIndicatorWidget()
            : Container()
      ]),
    );
  }

  // MARK: -
  // MARK: - PUSH

  void _showProfileEditScreen() {
    if (_profileViewModel.user == null) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfileEditScreenWidget(
            user: _profileViewModel.user!,
            onPop: (user) => _profileViewModel.setUser(user)),
      ),
    );
  }
}
