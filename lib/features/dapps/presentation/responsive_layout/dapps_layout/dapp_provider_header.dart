import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moonchain_wallet/core/core.dart';
import 'package:moonchain_wallet/features/dapps/presentation/responsive_layout/dapps_layout/see_all_page.dart';
import 'package:mxc_logic/mxc_logic.dart';
import 'package:mxc_ui/mxc_ui.dart';

import '../../dapps_presenter.dart';

class DAppProviderHeader extends HookConsumerWidget {
  final String providerTitle;
  final List<Dapp> dapps;
  final Widget listWidget;
  const DAppProviderHeader({
    super.key,
    required this.dapps,
    required this.providerTitle,
    required this.listWidget,
  });

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final state = ref.watch(appsPagePageContainer.state);
    final actions = ref.read(appsPagePageContainer.actions);

    return Row(
      children: [
        Text(
          providerTitle,
          style: FontTheme.of(context).body1().copyWith(
                fontWeight: FontWeight.bold,
                color: ColorsTheme.of(context).textPrimary,
              ),
        ),
        const Spacer(),
        InkWell(
          onTap: () {
            Navigator.of(context).push(
              route(
                SeeAllPage(
                  pageTitle: providerTitle,
                  listWidget: listWidget,
                ),
              ),
            );
          },
          child: Text(
            FlutterI18n.translate(context, 'see_all'),
            style: FontTheme.of(context)
                .subtitle2()
                .copyWith(color: ColorsTheme.of(context).primary),
          ),
        ),
      ],
    );
  }
}
