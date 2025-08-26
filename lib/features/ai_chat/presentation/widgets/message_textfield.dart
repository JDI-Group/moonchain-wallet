import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moonchain_wallet/common/assets.gen.dart';
import 'package:mxc_ui/mxc_ui.dart';

import '../chat_presenter.dart';
import '../chat_state.dart';

class MessageTextfield extends HookConsumerWidget {
  const MessageTextfield({super.key});

  @override
  ProviderBase<ChatPresenter> get presenter => chatPagePageContainer.actions;

  @override
  ProviderBase<ChatState> get state => chatPagePageContainer.state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatPresenter = ref.watch(presenter);
    final chatState = ref.watch(state);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Sizes.spaceNormal,
        vertical: Sizes.space2XSmall,
      ),
      decoration: BoxDecoration(
        color: ColorsTheme.of(context).backgroundGrey,
        borderRadius: const BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: MxcTextField.multiline(
              key: const Key('messageTextField'),
              controller: chatPresenter.messageTextController,
              focusNode: chatPresenter.messageFocusNode,
              maxLines: 6,
              borderFocusColor: Colors.transparent,
              borderUnFocusColor: Colors.transparent,
              minLines: 1,
            ),
          ),
          const SizedBox(
            width: Sizes.space3XSmall,
          ),
          GestureDetector(
            onTap: () {},
            child: SvgPicture.asset(
              Assets.svg.addImage,
              height: 24,
              width: 24,
              colorFilter: ColorFilter.mode(
                ColorsTheme.of(context).white,
                BlendMode.srcIn,
              ),
            ),
          ),
          const SizedBox(
            width: Sizes.spaceNormal,
          ),
          GestureDetector(
            onTap: () => chatPresenter.sendMessage(),
            child: Container(
              padding: const EdgeInsets.all(Sizes.space2XSmall),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: ColorsTheme.of(context).primary,
              ),
              child: SvgPicture.asset(
                Assets.svg.send,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
