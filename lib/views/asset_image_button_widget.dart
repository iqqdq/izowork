import 'package:flutter/material.dart';

class AssetImageButton extends StatelessWidget {
  final String imagePath;
  final VoidCallback onTap;

  const AssetImageButton(
      {Key? key, required this.imagePath, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        child: Image.asset(imagePath, height: 24.0, fit: BoxFit.fill),
        onTap: () => onTap());
  }
}
