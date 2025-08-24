import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moonchain_wallet/features/ai_chat/presentation/widgets/messages/processing_bubble.dart';
import 'package:mxc_ui/mxc_ui.dart';

import '../../chat_presenter.dart';
import '../../chat_state.dart';
import './message_bubble.dart';

class MessagesList extends HookConsumerWidget {
  final List<Map<String, dynamic>> messageList;
  const MessagesList(this.messageList, {super.key});

  @override
  ProviderBase<ChatPresenter> get presenter => chatPagePageContainer.actions;

  @override
  ProviderBase<ChatState> get state => chatPagePageContainer.state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatPresenter = ref.watch(presenter);
    final chatState = ref.watch(state);

    return Align(
      alignment: Alignment.topCenter,
      child: ListView.separated(
        controller: chatPresenter.messageListScrollController,
        shrinkWrap: true,
        reverse: true,
        itemCount: messageList.length + 1,
        itemBuilder: (context, index) {
          if (index == messageList.length) {
            return const ProcessingBubble();
          }
          return MessageBubble(
            message: messageList[index]['message']! as String,
            isSender: messageList[index]['isSender']! as bool,
          );
        },
        separatorBuilder: (BuildContext context, int index) => const SizedBox(
          height: Sizes.spaceXLarge,
        ),
      ),
    );
  }
}
