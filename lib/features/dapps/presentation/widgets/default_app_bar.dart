import 'package:flutter_svg/svg.dart';
import 'package:moonchain_wallet/common/assets.gen.dart';
import 'package:moonchain_wallet/core/core.dart';
import 'package:moonchain_wallet/features/common/common.dart';
import 'package:moonchain_wallet/features/settings/presentation/settings_page.dart';
import 'package:moonchain_wallet/features/wallet/presentation/wallet_page.dart';
import 'package:flutter/material.dart';
import 'package:mxc_ui/mxc_ui.dart';

class DefaultAppBar extends StatelessWidget {
  final Color? backgroundColor;
  const DefaultAppBar({super.key, this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return AppNavBar(
      backgroundColor: backgroundColor,
      action: IconButton(
        key: const ValueKey('settingsButton'),
        icon: SvgPicture.asset(
          Assets.svg.settingsSvg,
          height: 28,
          width: 28,
        ),
        iconSize: Sizes.space2XLarge,
        onPressed: () {
          Navigator.of(context).push(
            route(
              const SettingsPage(),
            ),
          );
        },
        color: ColorsTheme.of(context).iconPrimary,
      ),
      leadingType: LeadingType.walletAddress,
    );
  }
}
