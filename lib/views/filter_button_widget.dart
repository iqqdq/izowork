import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:izowork/components/components.dart';

class FilterButtonWidget extends StatelessWidget {
  final bool isSelected;
  final VoidCallback onTap;

  const FilterButtonWidget({
    Key? key,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Container(
        margin: const EdgeInsets.only(bottom: 15.0),
        height: 38.0,
        decoration: BoxDecoration(
            color: HexColors.white,
            border: Border.all(
              width: 1.0,
              color: HexColors.grey20,
            ),
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [Shadows.shadow]),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            highlightColor: HexColors.grey20,
            splashColor: Colors.transparent,
            borderRadius: BorderRadius.circular(10.0),
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Row(children: [
                    SvgPicture.asset(
                      'assets/ic_filter.svg',
                      colorFilter: ColorFilter.mode(
                        isSelected
                            ? HexColors.additionalViolet
                            : HexColors.grey50,
                        BlendMode.srcIn,
                      ),
                      width: 16.0,
                      height: 16.0,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(width: 10.0),
                    Text(
                      Titles.filter,
                      style: TextStyle(
                        color: HexColors.black,
                        fontSize: 14.0,
                        fontFamily: 'PT Root UI',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ]),
                ])),
            onTap: () => onTap(),
          ),
        ),
      ),
    );
  }
}
