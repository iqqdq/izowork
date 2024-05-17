import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:izowork/components/components.dart';
import 'package:izowork/models/models.dart';
import 'package:izowork/views/file_list_widget.dart';

class DocumentListItemWidget extends StatelessWidget {
  final String namespace;
  final List<Document> documents;
  final bool isExpanded;
  final VoidCallback onExpand;
  final Function(int) onTap;

  const DocumentListItemWidget(
      {Key? key,
      required this.namespace,
      required this.documents,
      required this.isExpanded,
      required this.onExpand,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      namespace.isEmpty
          ? Container()
          : Material(
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
                            Text(namespace,
                                maxLines: 2,
                                style: TextStyle(
                                    color: HexColors.black,
                                    fontSize: 18.0,
                                    fontFamily: 'PT Root UI')),
                          ])),
                      onTap: () => onExpand())),
            ),
      AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: isExpanded ? (56.0 + 10.0) * documents.length : 0.0,
          child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: const EdgeInsets.only(left: 16.0),
              itemCount: documents.length,
              itemBuilder: (context, index) {
                return FileListItemWidget(
                    key: ValueKey(documents[index].id),
                    fileName: documents[index].name,
                    // isDownloading: isDownloading,
                    onTap: () => onTap(index));
              }))
    ]);
  }
}
