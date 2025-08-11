import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jdenticon_dart/jdenticon_dart.dart';
import 'package:mxc_ui/mxc_ui.dart';

class Portrait extends StatelessWidget {
  const Portrait({
    super.key,
    required this.name,
    this.isOnWhite,
  });

  final String name;
  final bool? isOnWhite;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
              color: isOnWhite == null
                  ? Colors.transparent
                  : isOnWhite!
                      ? Colors.black
                      : ColorsTheme.of(context).white100,
              width: 1.5)),
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
