import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:izowork/components/components.dart';

class AvatarWidget extends StatelessWidget {
  final String url;
  final String? endpoint;
  final double size;
  final bool? isGroupAvatar;

  const AvatarWidget({
    super.key,
    required this.url,
    required this.endpoint,
    required this.size,
    this.isGroupAvatar,
  });

  @override
  Widget build(BuildContext context) {
    bool isGroup = isGroupAvatar == null
        ? false
        : isGroupAvatar! == false
            ? false
            : true;

    var placeholder = SvgPicture.asset(
      isGroup ? 'assets/ic_group_avatar.svg' : 'assets/ic_avatar.svg',
      colorFilter: ColorFilter.mode(
        isGroup ? HexColors.white : HexColors.grey30,
        BlendMode.srcIn,
      ),
      width: size,
      height: size,
      fit: BoxFit.cover,
    );

    var avatar = Stack(children: [
      placeholder,
      endpoint == null
          ? Container()
          : ClipRRect(
              borderRadius: BorderRadius.circular(40.0),
              child: CachedNetworkImage(
                cacheKey: endpoint,
                imageUrl: url + endpoint!,
                width: size,
                height: size,
                memCacheWidth: size.toInt() *
                    MediaQuery.of(context).devicePixelRatio.round(),
                fit: BoxFit.cover,
              ),
            ),
    ]);

    return isGroup
        ? Container(
            padding: const EdgeInsets.all(8.0),
            width: size,
            height: size,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(size / 2.0),
              color: HexColors.grey30,
            ),
            child: avatar,
          )
        : avatar;
  }
}
