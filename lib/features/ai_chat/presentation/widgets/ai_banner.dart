import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moonchain_wallet/common/assets.gen.dart';
import 'package:mxc_ui/mxc_ui.dart';

import 'gredient.dart';

class AIBanner extends StatelessWidget {
  const AIBanner({super.key});

  @override
  Widget build(BuildContext context) {
    String translate(String key) => FlutterI18n.translate(context, key);

    return Container(
      height: MediaQuery.of(context).size.height * 0.35,
      width: MediaQuery.of(context).size.height * 0.349,
      // margin: EdgeInsets.only(top: ),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(32)),
        gradient: getLinearGradient(),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: ColorsTheme.of(context).black,
            ),
            child: SvgPicture.asset(
              Assets.svg.aiBlack,
              height: 32,
              width: 32,
              colorFilter: ColorFilter.mode(
                  ColorsTheme.of(context).primary, BlendMode.srcIn),
            ),
          ),
          Text(translate("${translate('moonchain')} ${translate('ai')}"),
              style: FontTheme.of(context).h4().copyWith(
                    fontSize: 36,
                    fontWeight: FontWeight.w800,
                    color: ColorsTheme.of(context).black,
                  )),
          const SizedBox(
            height: 30,
          ),
          Text(translate("${translate('moonchain')} ${translate('ai')}"),
              style: FontTheme.of(context).body2().copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: ColorsTheme.of(context).black,
                  )),
        ],
      ),
    );
  }
}
