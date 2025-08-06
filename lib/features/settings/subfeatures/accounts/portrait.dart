import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jdenticon_dart/jdenticon_dart.dart';

class Portrait extends StatelessWidget {
  const Portrait({
    super.key,
    required this.name,
  });

  final String name;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.black, width: 2)),
      child: CircleAvatar(
        radius: 14,
        child: SvgPicture.string(
          Jdenticon.toSvg(name),
          fit: BoxFit.contain,
          height: 28,
          width: 28,
        ),
      ),
    );
  }
}
