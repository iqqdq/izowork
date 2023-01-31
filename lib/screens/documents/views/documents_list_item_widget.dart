import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:izowork/components/hex_colors.dart';

class DocumentListItemWidget extends StatelessWidget {
  final bool isExpanded;
  final VoidCallback onTap;

  const DocumentListItemWidget(
      {Key? key, required this.isExpanded, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Material(
        color: Colors.transparent,
        child: Container(
            margin: const EdgeInsets.only(bottom: 10.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                border: Border.all(width: 0.5, color: HexColors.grey30)),
            child: InkWell(
                highlightColor: HexColors.grey20,
                splashColor: Colors.transparent,
                borderRadius: BorderRadius.circular(16.0),
                child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(children: [
                      SvgPicture.asset('assets/ic_folder.svg'),
                      const SizedBox(width: 8.0),

                      /// NAME
                      Text('Папка',
                          maxLines: 2,
                          style: TextStyle(
                              color: HexColors.black,
                              fontSize: 18.0,
                              fontFamily: 'PT Root UI')),
                    ])),
                onTap: () => onTap())),
      ),
      AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: isExpanded ? (56.0 + 10.0) * 2 : 0.0,
          child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: const EdgeInsets.only(left: 16.0),
              itemCount: 4,
              itemBuilder: (context, index) {
                return Material(
                    color: Colors.transparent,
                    child: Container(
                        height: 56.0,
                        margin: const EdgeInsets.only(bottom: 10.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.0),
                            border: Border.all(
                                width: 0.5, color: HexColors.grey30)),
                        child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(children: [
                                    SvgPicture.asset('assets/ic_file.svg'),
                                    const SizedBox(width: 8.0),

                                    /// NAME
                                    Text('file.png',
                                        maxLines: 1,
                                        style: TextStyle(
                                            color: HexColors.black,
                                            fontSize: 18.0,
                                            fontFamily: 'PT Root UI')),
                                    const SizedBox(width: 10.0)
                                  ]),
                                  Row(children: [
                                    InkWell(
                                      borderRadius: BorderRadius.circular(6.0),
                                      child: SvgPicture.asset(
                                          'assets/ic_file_download.svg',
                                          fit: BoxFit.scaleDown,
                                          width: 34.0,
                                          height: 34.0),
                                      onTap: () => {},
                                    ),
                                    const SizedBox(width: 4.0),
                                    InkWell(
                                      borderRadius: BorderRadius.circular(6.0),
                                      child: SvgPicture.asset(
                                          'assets/ic_file_add.svg',
                                          fit: BoxFit.scaleDown,
                                          width: 34.0,
                                          height: 34.0),
                                      onTap: () => {},
                                    )
                                  ])
                                ]))));
              }))
    ]);
  }
}
