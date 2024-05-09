import 'package:flutter/material.dart';
import 'package:izowork/components/components.dart';

class SearchProductListItemWidget extends StatelessWidget {
  final String name;
  final VoidCallback onTap;

  const SearchProductListItemWidget(
      {Key? key, required this.name, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(bottom: 10.0),
        child: Material(
            color: Colors.transparent,
            child: InkWell(
                highlightColor: HexColors.grey20,
                splashColor: Colors.transparent,
                borderRadius: BorderRadius.circular(16.0),
                child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.0),
                        border:
                            Border.all(width: 1.0, color: HexColors.grey20)),
                    child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(name,
                            style: const TextStyle(
                                fontSize: 16.0, fontFamily: 'PT Root UI')))),
                onTap: () => onTap())));
  }
}
