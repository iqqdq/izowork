import 'package:flutter/material.dart';
import 'package:izowork/components/hex_colors.dart';

class LoadingIndicatorWidget extends StatelessWidget {
  final bool? onlyIndicator;

  const LoadingIndicatorWidget({Key? key, this.onlyIndicator})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    final _indicator = Transform.scale(
        scale: 0.75,
        child: CircularProgressIndicator(
            strokeWidth: 6.0,
            valueColor: AlwaysStoppedAnimation<Color>(HexColors.primaryMain)));
    final _onlyIndicator = onlyIndicator == null
        ? false
        : onlyIndicator == true
            ? true
            : false;

    return _onlyIndicator
        ? _indicator
        : SizedBox(
            width: _size.width,
            height: _size.height,
            child: Center(child: _indicator));
  }
}
