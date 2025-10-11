import 'package:flutter/material.dart';
import 'package:mxc_logic/mxc_logic.dart';

import 'native_dapp_card.dart';

class NativeDappList extends StatelessWidget {
  final List<Dapp> dapps;
  final bool isScrollingLocked;
  const NativeDappList(
      {super.key, required this.dapps, this.isScrollingLocked = false});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: dapps.length,
      scrollDirection: Axis.vertical,
      physics: isScrollingLocked ? const NeverScrollableScrollPhysics() : null,
      shrinkWrap: true,
      padding: const EdgeInsets.only(top: 10),
      
      itemBuilder: (context, index) => NativeDAppCard(
        index: index,
        dapp: dapps[index],
      ),
      separatorBuilder: (context, index) => const SizedBox(height: 20),
    );
  }
}
