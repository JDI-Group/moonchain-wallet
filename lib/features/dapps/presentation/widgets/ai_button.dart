import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moonchain_wallet/common/assets.gen.dart';
import 'package:mxc_ui/mxc_ui.dart';

class AiButton extends StatelessWidget {
  const AiButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: const Offset(0, 7.5), //
      child: FloatingActionButton.large(
          foregroundColor: Colors.transparent,
          backgroundColor: Colors.transparent,
          onPressed: () {},
          splashColor: Colors.transparent,
          elevation: 0,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: ColorsTheme.of(context).primary,
            ),
            child: SvgPicture.asset(
              Assets.svg.aiBlack,
              height: 32,
              width: 32,
            ),
          )),
    );
  }
}
