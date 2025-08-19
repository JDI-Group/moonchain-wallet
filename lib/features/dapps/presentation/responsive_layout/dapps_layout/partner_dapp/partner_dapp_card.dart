import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mxc_logic/mxc_logic.dart';
import '../../../dapps_presenter.dart';
import 'build_partner_dapp_card.dart';

class PartnerDAppCard extends HookConsumerWidget {
  final Dapp dapp;
  final int index;
  final bool horizontallyExpanded;
  const PartnerDAppCard({
    super.key,
    required this.index,
    required this.dapp,
    required this.horizontallyExpanded,
  });

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final actions = ref.read(appsPagePageContainer.actions);
    final state = ref.read(appsPagePageContainer.state);

    

    onTap() async {
            await actions.requestPermissions(dapp);
            actions.openDapp(
              dapp.app!.url!,
            );
          }


    Widget getCardItem({void Function()? shatter}) {
      return buildPartnerDAppCard(
            context,
            dapp,
            onTap,
            horizontallyExpanded,
            actions: actions,
          );
    }

    return getCardItem();
  }
}
