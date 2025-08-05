import 'package:moonchain_wallet/common/common.dart';
import 'package:moonchain_wallet/features/common/app_nav_bar/widget/accounts_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mxc_ui/mxc_ui.dart';

import 'app_nav_bar_presenter.dart';

enum LeadingType { walletAddress, backButton }

class AppNavBar extends HookConsumerWidget {
  const AppNavBar({
    Key? key,
    this.leading,
    this.action,
    this.title,
    this.leadingType = LeadingType.backButton,
  }) : super(key: key);

  final Widget? leading;
  final Widget? action;
  final Widget? title;
  final LeadingType leadingType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final presenter = ref.read(appNavBarContainer.actions);
    final state = ref.watch(appNavBarContainer.state);

    return PresenterHooks(
      presenter: presenter,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (leading == null && leadingType == LeadingType.backButton) ...[
              IconButton(
                key: const ValueKey('backButton'),
                icon: const Icon(Icons.arrow_back_rounded),
                iconSize: 32,
                onPressed: appBarPopHandlerBuilder(context),
                color: ColorsTheme.of(context).iconPrimary,
              ),
            ] else if (leading == null && leadingType == LeadingType.walletAddress) ...[
              const AccountsDropdown(),
            ] else ...[
              leading!,
            ],
            if (title == null && leadingType != LeadingType.walletAddress) ...[
              const AccountsDropdown(),
            ] else if (title == null && leadingType == LeadingType.walletAddress) ...[
              Container(),
            ] else ...[
              title!
            ],
            if (action == null) ...[
              const SizedBox(width: 32),
            ] else ...[
              action!,
            ]
          ],
        ),
      ),
    );
  }
}
