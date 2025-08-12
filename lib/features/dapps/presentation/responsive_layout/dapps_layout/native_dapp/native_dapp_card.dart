import 'package:moonchain_wallet/common/components/context_menu_extended.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mxc_logic/mxc_logic.dart';
import '../../../dapps_presenter.dart';
import 'build_native_dapp_card.dart';
import '../context_menu_actions.dart';

class NativeDAppCard extends HookConsumerWidget {
  final Dapp dapp;
  final int index;
  const NativeDAppCard({
    super.key,
    required this.index,
    required this.dapp,
  });

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final actions = ref.read(appsPagePageContainer.actions);
    final state = ref.read(appsPagePageContainer.state);

    void Function()? onTap;

    final dappUrl = dapp.app!.url!;
    onTap = state.isEditMode
        ? null
        : () async {
            await actions.requestPermissions(dapp);
            actions.openDapp(
              dappUrl,
            );
          };

    Widget getCardItem({void Function()? shatter}) {
      return CupertinoContextMenuExtended.builder(
        builder: (context, animation) {
          return buildNativeNativeDAppCard(
            context,
            dapp,
            onTap,
            shatter: shatter,
            actions: actions,
            animated: animation.value != 0.0,
          );
        },
        actions: getContextMenuActions(
          actions,
          context,
          dapp,
          shatter,
        ),
      );
    }

    return getCardItem();
  }
}
