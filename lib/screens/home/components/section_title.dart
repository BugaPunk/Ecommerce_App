import 'package:flutter/material.dart';

import '../../../utils/size_config.dart';

//Titulo antes carrusel
class SectionTitle extends StatelessWidget {
  const SectionTitle({
    super.key, 
    required this.text, 
    required this.press,
  });
  
  final String text;
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode 
        ? Theme.of(context).colorScheme.onSurface 
        : Colors.black;
    final linkColor = isDarkMode 
        ? Theme.of(context).colorScheme.primary 
        : Colors.blue;
    
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: getProportionateScreenWidth(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: TextStyle(
              fontSize: getProportionateScreenWidth(18),
              color: textColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          GestureDetector(
            onTap: press,
            child: Text(
              "Ver más",
              style: TextStyle(
                color: linkColor,
                fontSize: getProportionateScreenWidth(14),
              ),
            ),
          )
        ],
      ),
    );
  }
}