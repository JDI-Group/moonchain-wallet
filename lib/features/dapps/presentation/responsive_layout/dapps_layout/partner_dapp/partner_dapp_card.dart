import 'dart:math';

import 'package:moonchain_wallet/common/components/context_menu_extended.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mxc_logic/mxc_logic.dart';
import '../../../dapps_presenter.dart';
import 'build_partner_dapp_card.dart';
import '../context_menu_actions.dart';
import '../shatter_widget.dart';

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

    void Function()? onTap;

    onTap = state.isEditMode
        ? null
        : () async {
            await actions.requestPermissions(dapp);
            actions.openDapp(
              dapp.app!.url!,
            );
          };

    final animationController = useAnimationController(
      duration: const Duration(milliseconds: 75),
      lowerBound: -pi / 50,
      upperBound: pi / 50,
    );

    animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        animationController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        animationController.forward();
      }
    });

    Widget getCardItem({void Function()? shatter}) {
      return CupertinoContextMenuExtended.builder(
        builder: (context, animation) {
          return buildPartnerDAppCard(
            context,
            dapp,
            onTap,
            horizontallyExpanded,
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
