import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moonchain_wallet/core/core.dart';
import 'package:moonchain_wallet/features/common/app_nav_bar/app_nav_bar_presenter.dart';
import 'package:moonchain_wallet/features/settings/settings.dart';
import 'package:moonchain_wallet/features/settings/subfeatures/accounts/show_accounts_dialog.dart';
import 'package:moonchain_wallet/features/settings/subfeatures/accounts/subfeatures/import_account/import_account_page.dart';
import 'package:mxc_logic/mxc_logic.dart';
import 'package:mxc_ui/mxc_ui.dart';

class AccountsDropdown extends HookConsumerWidget {
  final bool isOnWhite;
  const AccountsDropdown(this.isOnWhite, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final presenter = ref.read(appNavBarContainer.actions);
    final state = ref.watch(appNavBarContainer.state);

    return GestureDetector(
      onTap: () => showAccountsDialog(
        context: context,
        currentAccount: state.account!,
        accounts: state.accounts,
        isLoading: state.isLoading,
        onImport: () => Navigator.of(context).push(
          route.featureDialog(
            const ImportAccountPage(),
          ),
        ),
        onAdd: () => presenter.addNewAccount(),
        onSelect: (item) => presenter.changeAccount(item),
        onRemove: (item) => presenter.removeAccount(item),
      ),
      onDoubleTap: () => presenter.copy(),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Portrait(
            isOnWhite: isOnWhite,
            name: state.account?.address ?? '',
          ),
          const SizedBox(width: Sizes.spaceXSmall),
          Text(
            state.account?.mns ??
                MXCFormatter.formatWalletAddress(state.account?.address ?? ''),
            style: FontTheme.of(context).subtitle1().copyWith(
                  fontWeight: FontWeight.w500,
                  color: isOnWhite
                      ? Colors.black
                      : ColorsTheme.of(context).white100,
                ),
          ),
          Icon(
            Icons.arrow_drop_down_rounded,
            color: isOnWhite ? Colors.black : ColorsTheme.of(context).white100,
            size: 32,
          ),
        ],
      ),
    );
  }
}
