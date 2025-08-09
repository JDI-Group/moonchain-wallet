import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mxc_logic/mxc_logic.dart';
import 'package:mxc_ui/mxc_ui.dart';

import '../../dapps_presenter.dart';

class DAppProviderHeader extends HookConsumerWidget {
  final String providerTitle;
  final List<Dapp> dapps;
  const DAppProviderHeader({
    super.key,
    required this.dapps,
    required this.providerTitle,
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
          style: FontTheme.of(context).subtitle2().copyWith(
              fontWeight: FontWeight.bold,
              color: ColorsTheme.of(context).textPrimary),
        ),
        const Spacer(),
        InkWell(
          onTap: () => actions.selectSeeAllDApps(dapps),
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
