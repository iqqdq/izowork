import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:izowork/components/components.dart';

class AvatarWidget extends StatelessWidget {
  final String url;
  final String? endpoint;
  final double size;
  final bool? isGroupAvatar;
  final File? file;

  const AvatarWidget({
    super.key,
    required this.url,
    required this.endpoint,
    required this.size,
    this.isGroupAvatar,
    this.file,
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

      /// FILE IMAGE
      file == null
          ? Container()
          : ClipRRect(
              borderRadius: BorderRadius.circular(size / 2.0),
              child: Image.file(
                file!,
                width: size,
                height: size,
                fit: BoxFit.cover,
              ),
            ),

      /// URL IMAGE
      endpoint == null
          ? Container()
          : ClipRRect(
              borderRadius: BorderRadius.circular(size / 2.0),
              child: file == null
                  ? CachedNetworkImage(
                      cacheKey: endpoint,
                      imageUrl: url + endpoint!,
                      width: size,
                      height: size,
                      memCacheWidth: size.toInt() *
                          MediaQuery.of(context).devicePixelRatio.round(),
                      fit: BoxFit.cover,
                    )
                  : Image.file(file!),
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
