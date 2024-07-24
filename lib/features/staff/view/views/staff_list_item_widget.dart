import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:izowork/components/components.dart';

import 'package:izowork/models/models.dart';
import 'package:izowork/api/api.dart';
import 'package:izowork/views/button_widget.dart';

class StaffListItemWidget extends StatelessWidget {
  final User user;
  final VoidCallback onUserTap;
  final Function(String)? onLinkTap;
  final VoidCallback? onChatTap;

  const StaffListItemWidget(
      {Key? key,
      required this.user,
      required this.onUserTap,
      this.onLinkTap,
      this.onChatTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(bottom: 10.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            border: Border.all(width: 0.5, color: HexColors.grey30)),
        child: Material(
            color: Colors.transparent,
            child: ListView(
                padding: const EdgeInsets.all(16.0),
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                children: [
                  /// STAFF
                  InkWell(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      borderRadius: BorderRadius.circular(16.0),
                      child: Row(children: [
                        /// STAFF AVATAR
                        Stack(children: [
                          SvgPicture.asset(
                            'assets/ic_avatar.svg',
                            width: 40.0,
                            height: 40.0,
                            colorFilter: ColorFilter.mode(
                              HexColors.grey40,
                              BlendMode.srcIn,
                            ),
                            fit: BoxFit.cover,
                          ),
                          user.avatar == null
                              ? Container()
                              : user.avatar!.isEmpty
                                  ? Container()
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(20.0),
                                      child: CachedNetworkImage(
                                          cacheKey: user.avatar,
                                          imageUrl: avatarUrl + user.avatar!,
                                          width: 40.0,
                                          height: 40.0,
                                          memCacheWidth: 40 *
                                              MediaQuery.of(context)
                                                  .devicePixelRatio
                                                  .round(),
                                          fit: BoxFit.cover)),
                        ]),
                        const SizedBox(width: 10.0),

                        Expanded(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                              /// STAFF NAME
                              Text(user.name,
                                  style: TextStyle(
                                      color: HexColors.black,
                                      fontSize: 14.0,
                                      fontFamily: 'PT Root UI',
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(height: 2.0),

                              /// STAFF SPECIALIZATION
                              Text(user.post,
                                  style: TextStyle(
                                      color: HexColors.grey50,
                                      fontSize: 12.0,
                                      fontFamily: 'PT Root UI')),
                            ]))
                      ]),
                      onTap: () => onUserTap()),
                  SizedBox(height: user.social.isEmpty ? 0.0 : 16.0),

                  /// LINK LIST VIEW
                  onLinkTap == null
                      ? Container()
                      : ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          itemCount: user.social.length,
                          itemBuilder: (context, index) {
                            final social = user.social[index];

                            return InkWell(
                              key: ValueKey(social),
                              highlightColor: Colors.transparent,
                              splashColor: Colors.transparent,
                              borderRadius: BorderRadius.circular(16.0),
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 4.0),
                                child: Text(
                                  social,
                                  style: TextStyle(
                                      color: HexColors.primaryDark,
                                      fontSize: 14.0,
                                      fontFamily: 'PT Root UI',
                                      fontWeight: FontWeight.w600,
                                      decoration: TextDecoration.underline),
                                ),
                              ),
                              onTap: () => onLinkTap!(social),
                            );
                          }),
                  SizedBox(height: onChatTap == null ? 0.0 : 16.0),

                  onChatTap == null
                      ? Container()
                      : ButtonWidget(
                          title: Titles.goToChat,
                          margin: EdgeInsets.zero,
                          onTap: () => onChatTap!())
                ])));
  }
}
