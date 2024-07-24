import 'package:flutter/material.dart';
import 'package:izowork/components/components.dart';

class NoResultTitle extends StatelessWidget {
  const NoResultTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        Titles.noResult,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 16.0,
          color: HexColors.grey50,
        ),
      ),
    );
  }
}
