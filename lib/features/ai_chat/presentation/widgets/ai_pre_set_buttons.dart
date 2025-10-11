import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moonchain_wallet/common/assets.gen.dart';
import 'package:moonchain_wallet/features/ai_chat/presentation/chat_presenter.dart';
import 'package:moonchain_wallet/features/ai_chat/presentation/chat_state.dart';
import 'package:mxc_logic/mxc_logic.dart';

import 'ai_pre_set_button.dart';

class AIPreSetButtons extends HookConsumerWidget {
  const AIPreSetButtons({super.key});

  @override
  ProviderBase<ChatPresenter> get presenter => chatPagePageContainer.actions;

  @override
  ProviderBase<ChatState> get state => chatPagePageContainer.state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatPresenter = ref.watch(presenter);
    final chatState = ref.watch(state);

    return GridView.count(
      shrinkWrap: true, // so it doesn't take the whole screen
      crossAxisCount: 2, // 2 items per row
      mainAxisSpacing: 10, // vertical spacing
      crossAxisSpacing: 10, // horizontal spacing
      childAspectRatio: 138 / 44, // width/height ratio
      padding: const EdgeInsets.all(0),
      children: generatePreSetConversations(chatPresenter),
    );
  }
}

final presetButtonsProps = [
  {
    "title": "pending_swaps",
    "icon": Assets.svg.aiPending,
  },
  {
    "title": "iho",
    "icon": AssetsPath.dappsThumbnailV3('iho_not_filled'),
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

List<Widget> generatePreSetConversations(ChatPresenter chatPresenter) =>
    presetButtonsProps
        .map(
          (e) => PreSetConversations(
              onTap: () => chatPresenter.handlePresetButtons(e['title']!),
              title: e['title']!,
              icon: e['icon']!),
        )
        .toList();
