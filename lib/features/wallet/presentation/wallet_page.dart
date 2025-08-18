import 'package:flutter_svg/svg.dart';
import 'package:moonchain_wallet/common/assets.gen.dart' as assets;
import 'package:moonchain_wallet/core/core.dart';
import 'package:moonchain_wallet/features/common/common.dart';
import 'package:moonchain_wallet/features/settings/settings.dart';
import 'package:moonchain_wallet/features/wallet/presentation/widgets/tweets_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moonchain_wallet/features/wallet/wallet.dart';
import 'package:moonchain_wallet/common/common.dart';
import 'package:mxc_logic/mxc_logic.dart';
import 'package:mxc_ui/mxc_ui.dart';

import 'wallet_page_presenter.dart';

class WalletPage extends HookConsumerWidget {
  const WalletPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final presenter = ref.read(walletContainer.actions);
    final state = ref.watch(walletContainer.state);
    final List<TransactionModel>? txList = state.txList == null
        ? null
        : state.txList!.length > 6
            ? state.txList!.sublist(0, 6)
            : state.txList!;

    return MxcPage(
        useAppBar: true,
        presenter: presenter,
        resizeToAvoidBottomInset: true,
        useBlackBackground: true,
        layout: LayoutType.column,
        useContentPadding: false,
        appBar: AppNavBar(
          action: IconButton(
            key: const ValueKey('settingsButton'),
            icon: SvgPicture.asset(
              assets.Assets.svg.settingsSvg,
              height: 28,
              width: 28,
              fit: BoxFit.fill,
              colorFilter: ColorFilter.mode(
                  ColorsTheme.of(context).white100, BlendMode.srcIn),
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
        ),
        children: [
          Expanded(
              child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 24, right: 24, left: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      FlutterI18n.translate(context, 'wallet'),
                      style: FontTheme.of(context).h4().copyWith(
                            fontSize: 35,
                            fontWeight: FontWeight.w800,
                            color: ColorsTheme.of(context).textPrimary,
                          ),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    const BalancePanel(false),
                    const SizedBox(
                      height: 32,
                    ),
                    Text(FlutterI18n.translate(context, 'transaction_history'),
                        style: FontTheme.of(context).h7().copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: ColorsTheme.of(context).textPrimary)),
                    const SizedBox(
                      height: 12,
                    ),
                    RecentTransactions(
                      walletAddress: state.account?.address,
                      transactions: txList,
                      tokens: state.tokensList,
                      networkType: state.network?.networkType,
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    const TweetsList()
                  ],
                ),
              ),
            ],
          ))
        ]);
  }
}
