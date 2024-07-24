import 'package:flutter/widgets.dart';
import 'package:izowork/components/components.dart';

class DismissIndicatorWidget extends StatelessWidget {
  const DismissIndicatorWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 12.0),
        width: 40.0,
        height: 4.0,
        decoration: BoxDecoration(
          color: HexColors.grey30,
          borderRadius: BorderRadius.circular(4.0),
        ),
      ),
    );
  }
}
