import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:izowork/components/hex_colors.dart';

class FileListItemWidget extends StatelessWidget {
  final String fileName;
  final VoidCallback? onRemoveTap;

  const FileListItemWidget(
      {Key? key, required this.fileName, required this.onRemoveTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(bottom: 10.0),
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        height: 56.0,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            border: Border.all(width: 0.5, color: HexColors.grey30)),
        child: Row(children: [
          Image.asset('assets/ic_file.png', width: 24.0, height: 24.0),
          const SizedBox(width: 6.0),
          Expanded(
              child: Text(fileName,
                  style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w400,
                      color: HexColors.black,
                      fontFamily: 'PT Root UI'))),
          onRemoveTap == null
              ? Container()
              : SizedBox(
                  height: 38.0,
                  child: onRemoveTap == null
                      ? Container()
                      : InkWell(
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          borderRadius: BorderRadius.circular(10.0),
                          child: SvgPicture.asset('assets/ic_clear.svg'),
                          onTap: () => onRemoveTap!()))
        ]));
  }
}
