import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moonchain_wallet/common/assets.gen.dart';
import 'package:moonchain_wallet/core/core.dart';
import 'package:mxc_ui/mxc_ui.dart';

import '../../../../ai_chat/presentation/chat_page.dart';

class AiTextfield extends StatelessWidget {
  const AiTextfield({super.key});

  @override
  Widget build(BuildContext context) {
    String translate(String key) => FlutterI18n.translate(context, key);

    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          route(
            const ChatPage(),
          ),
        );
      },
      child: Container(
        key: const Key('AITextField'),
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        height: 56,
        decoration: BoxDecoration(
            color: ColorsTheme.of(context).white.withValues(alpha: 0.12),
            border: Border.all(
              color: Colors.black,
              width: 2,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(20))),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              translate('ask_moonchain_ai_anything'),
              style: FontTheme.of(context).subtitle1().copyWith(
                    color:
                        ColorsTheme.of(context, listen: false).backgroundGrey,
                  ),
            ),
            const Spacer(),
            SvgPicture.asset(
              Assets.svg.aiBlack,
              height: 28,
              width: 28,
              colorFilter: const ColorFilter.mode(
                Colors.black,
                BlendMode.srcIn,
              ),
            )
          ],
        ),
      ),
    );
  }
}
