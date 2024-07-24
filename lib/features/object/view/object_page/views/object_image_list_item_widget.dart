import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';
import 'package:izowork/api/api.dart';
import 'package:izowork/models/models.dart';

class ObjectImageListItemWidget extends StatelessWidget {
  final Document document;

  const ObjectImageListItemWidget({
    super.key,
    required this.document,
  });

  @override
  Widget build(BuildContext context) {
    final filename = document.filename;

    return filename == null
        ? Container()
        : SizedBox(
            width: 140.0,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: InstaImageViewer(
                imageUrl: objectMediaUrl + filename,
                child: CachedNetworkImage(
                  imageUrl: objectMediaUrl + filename,
                  fit: BoxFit.cover,
                ),
              ),
            ));
  }
}
