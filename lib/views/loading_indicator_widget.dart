import 'package:flutter/material.dart';
import 'package:izowork/components/components.dart';

class LoadingIndicatorWidget extends StatelessWidget {
  final bool? onlyIndicator;
  final Color? color;

  const LoadingIndicatorWidget({
    Key? key,
    this.onlyIndicator,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _onlyIndicator = onlyIndicator == null
        ? false
        : onlyIndicator == true
            ? true
            : false;

    final _indicator = Transform.scale(
      scale: 0.65,
      child: CircularProgressIndicator(
        strokeWidth: 6.0,
        valueColor: AlwaysStoppedAnimation<Color>(
          color ?? (_onlyIndicator ? HexColors.primaryDark : HexColors.white),
        ),
      ),
    );

    return Center(
      child: _onlyIndicator
          ? _indicator
          : Container(
              width: 54.0,
              height: 54.0,
              decoration: BoxDecoration(
                color: HexColors.primaryDark,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Center(child: _indicator),
            ),
    );
  }
}
