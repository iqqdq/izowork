// import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:izowork/components/components.dart';
import 'package:izowork/entities/responses/responses.dart';
import 'package:izowork/views/views.dart';

class ObjectListItemWidget extends StatelessWidget {
  final Object object;
  final VoidCallback onTap;

  const ObjectListItemWidget({
    Key? key,
    required this.object,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(
            width: 0.5,
            color: HexColors.grey30,
          )),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          highlightColor: HexColors.grey20,
          splashColor: Colors.transparent,
          borderRadius: BorderRadius.circular(16.0),
          child: ListView(
              padding: const EdgeInsets.all(16.0),
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: [
                /// OBJECT NAME
                TitleWidget(
                  text: object.name,
                  padding: EdgeInsets.zero,
                ),
                const SizedBox(height: 10.0),

                /// ADDRESS
                SubtitleWidget(
                  text: object.address,
                  padding: EdgeInsets.zero,
                  nonSelectable: true,
                ),
                const SizedBox(height: 10.0),
                const SeparatorWidget(),
                const SizedBox(height: 10.0),

                /// MANAGER
                const TitleWidget(
                  text: Titles.manager,
                  padding: EdgeInsets.zero,
                  isSmall: true,
                  nonSelectable: true,
                ),
                const SizedBox(height: 2.0),

                SubtitleWidget(
                  text: object.manager?.name ?? '-',
                  padding: EdgeInsets.zero,
                  nonSelectable: true,
                ),

                const SizedBox(height: 10.0),
                const SeparatorWidget(),
                const SizedBox(height: 10.0),

                /// GENERAL CONTRACTOR
                const TitleWidget(
                  text: Titles.generalContractor,
                  padding: EdgeInsets.zero,
                  isSmall: true,
                  nonSelectable: true,
                ),
                const SizedBox(height: 2.0),

                SubtitleWidget(
                  text: object.contractor?.name ?? '-',
                  padding: EdgeInsets.zero,
                  nonSelectable: true,
                ),

                const SizedBox(height: 10.0),
                const SeparatorWidget(),
                const SizedBox(height: 10.0),

                Row(children: [
                  /// REALIZATIONS
                  Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const TitleWidget(
                            text: Titles.realizations,
                            padding: EdgeInsets.zero,
                            isSmall: true,
                            nonSelectable: true,
                          ),
                          const SizedBox(height: 2.0),
                          SubtitleWidget(
                            text: '${object.readiness} %',
                            padding: EdgeInsets.zero,
                            nonSelectable: true,
                          )
                        ]),
                  ),

                  /// EFFECTIVENESS
                  Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const TitleWidget(
                            text: Titles.effectiveness,
                            padding: EdgeInsets.zero,
                            isSmall: true,
                            nonSelectable: true,
                          ),
                          const SizedBox(height: 2.0),
                          SubtitleWidget(
                            text: '${object.efficiency} %',
                            padding: EdgeInsets.zero,
                            nonSelectable: true,
                          )
                        ]),
                  ),
                ])
              ]),
          onTap: () => onTap(),
        ),
      ),
    );
  }
}
