import 'package:flutter/material.dart';

class RoundedIconBtn extends StatelessWidget {
  const RoundedIconBtn({
    Key? key,
    required this.icon,
    required this.press,
    this.showShadow = false,
    this.size = 40,
    this.iconSize = 20,
  }) : super(key: key);

  final IconData icon;
  final GestureTapCallback press;
  final bool showShadow;
  final double size;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          if (showShadow)
            BoxShadow(
              offset: const Offset(0, 6),
              blurRadius: 10,
              color: const Color(0xFFB0B0B0).withOpacity(0.2),
            ),
        ],
      ),
      child: Material(
        color: Colors.white,
        shape: const CircleBorder(),
        child: InkWell(
          onTap: press,
          borderRadius: BorderRadius.circular(size / 2),
          child: Center(
            child: Icon(
              icon,
              size: iconSize,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}