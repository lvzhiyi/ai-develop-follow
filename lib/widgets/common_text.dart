import 'package:flutter/material.dart';

class CommonText extends StatelessWidget {
  const CommonText(this.text, {super.key, this.style, this.textAlign});
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) => Text(text, style: style, textAlign: textAlign);
}
