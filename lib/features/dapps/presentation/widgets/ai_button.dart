import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moonchain_wallet/common/assets.gen.dart';
import 'package:mxc_ui/mxc_ui.dart';

class AiButton extends StatelessWidget {
  const AiButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
        backgroundColor: ColorsTheme.of(context).backgroundGrey,
        onPressed: () {},
        shape: const CircleBorder(),
        child: SvgPicture.asset(
          Assets.svg.aiBlack,
          height: 30,
          width: 30,
        ));
  }
}
