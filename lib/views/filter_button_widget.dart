import 'package:flutter/material.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/titles.dart';

class FilterButtonWidget extends StatelessWidget {
  final VoidCallback onTap;

  const FilterButtonWidget({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(bottom: 15.0),
        width: 98.0,
        height: 38.0,
        decoration: BoxDecoration(
            color: HexColors.white,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                  offset: const Offset(0.0, 10.0),
                  blurRadius: 20.0,
                  color: HexColors.black.withOpacity(0.05))
            ]),
        child: Material(
            color: Colors.transparent,
            child: InkWell(
                borderRadius: BorderRadius.circular(10.0),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Image.asset('assets/ic_filter.png'),
                  const SizedBox(width: 10.0),
                  Text(Titles.filter,
                      style: TextStyle(
                          color: HexColors.black,
                          fontSize: 14.0,
                          fontFamily: 'PT Root UI',
                          fontWeight: FontWeight.w500)),
                ]),
                onTap: () => onTap())));
  }
}
