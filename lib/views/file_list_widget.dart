import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:izowork/components/components.dart';

class FileListItemWidget extends StatelessWidget {
  final String fileName;
  final bool? isFolder;
  final bool? isDownloading;
  final bool? isPinned;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final VoidCallback? onRemoveTap;

  const FileListItemWidget({
    Key? key,
    required this.fileName,
    this.isFolder,
    this.isDownloading,
    this.isPinned,
    this.onTap,
    this.onLongPress,
    this.onRemoveTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool _isFolder = isFolder == null
        ? false
        : isFolder == false
            ? false
            : true;

    bool _isDownloading = isDownloading == null
        ? false
        : isDownloading == false
            ? false
            : true;

    bool _isPinned = isPinned == null
        ? false
        : isPinned == false
            ? false
            : true;

    return Container(
      margin: const EdgeInsets.only(bottom: 10.0),
      height: 56.0,
      decoration: BoxDecoration(
          color: _isPinned ? HexColors.additionalVioletLight : HexColors.white,
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(
            width: 0.5,
            color: HexColors.grey30,
          )),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          highlightColor: onTap == null ? Colors.transparent : HexColors.grey20,
          borderRadius: BorderRadius.circular(16.0),
          onLongPress: onLongPress,
          onTap: onTap == null ? null : () => onTap!(),
          child: Padding(
            padding: _isDownloading
                ? const EdgeInsets.only(
                    left: 7.0,
                    right: 16.0,
                  )
                : const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(children: [
              _isDownloading
                  ? Transform.scale(
                      scale: 0.44,
                      child: CircularProgressIndicator(
                          strokeWidth: 4.0,
                          valueColor: AlwaysStoppedAnimation<Color>(
                              HexColors.primaryMain)))
                  : SvgPicture.asset(
                      _isFolder ? 'assets/ic_folder.svg' : 'assets/ic_file.svg',
                      width: 24.0,
                      height: 24.0,
                    ),
              SizedBox(width: _isDownloading ? 2.0 : 6.0),
              Expanded(
                  child: Text(fileName,
                      maxLines: 1,
                      style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w400,
                          overflow: TextOverflow.ellipsis,
                          color: HexColors.black,
                          fontFamily: 'PT Root UI'))),
              const SizedBox(width: 12.0),
              onRemoveTap == null
                  ? Container()
                  : SizedBox(
                      height: 38.0,
                      child: InkWell(
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        borderRadius: BorderRadius.circular(10.0),
                        child: SvgPicture.asset('assets/ic_clear.svg'),
                        onTap: () => onRemoveTap!(),
                      ),
                    )
            ]),
          ),
        ),
      ),
    );
  }
}
