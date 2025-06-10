import 'package:flutter/material.dart';

import '../../../utils/size_config.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  final GestureTapCallback press;

  const SectionTitle({
    super.key,
    required this.title,
    required this.press,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: getProportionateScreenWidth(18),
            fontWeight: FontWeight.bold,
          ),
        ),
        GestureDetector(
          onTap: press,
          child: Text(
            "Ver más",
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: getProportionateScreenWidth(14),
            ),
          ),
        ),
      ],
    );
  }
}