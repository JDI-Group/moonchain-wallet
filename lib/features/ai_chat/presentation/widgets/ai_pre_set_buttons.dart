import 'package:flutter/material.dart';
import 'package:moonchain_wallet/common/assets.gen.dart';
import 'package:mxc_logic/mxc_logic.dart';

import 'ai_pre_set_button.dart';

class AIPreSetButtons extends StatelessWidget {
  const AIPreSetButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true, // so it doesn't take the whole screen
      crossAxisCount: 2, // 2 items per row
      mainAxisSpacing: 10, // vertical spacing
      crossAxisSpacing: 10, // horizontal spacing
      childAspectRatio: 138 / 44, // width/height ratio
      padding: const EdgeInsets.all(0),
      children: generatePreSetConversations(),
    );
  }
}

final presetButtonsProps = [
  {
    "title": "pending_swaps",
    "icon": Assets.svg.aiPending,
  },
  {
    "title": "iho_mining",
    "icon": AssetsPath.dappsThumbnailV3('iho_mining'),
  },
  {
    "title": "view_portfolio",
    "icon": Assets.svg.aiPorfolio,
  },
  {
    "title": "market_overview",
    "icon": Assets.svg.aiMarketOverview,
  },
];

List<Widget> generatePreSetConversations() => presetButtonsProps
    .map(
      (e) => PreSetConversations(
          onTap: () {}, title: e['title']!, icon: e['icon']!),
    )
    .toList();
