import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:moonchain_wallet/common/common.dart';
import 'package:moonchain_wallet/features/ai_chat/presentation/widgets/message_textfield.dart';
import 'package:moonchain_wallet/features/ai_chat/presentation/widgets/messages/messages_list.dart';
import 'package:moonchain_wallet/features/common/app_nav_bar/app_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mxc_ui/mxc_ui.dart';

import 'chat_presenter.dart';
import 'chat_state.dart';

class ChatPage extends HookConsumerWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  ProviderBase<ChatPresenter> get presenter => chatPagePageContainer.actions;

  @override
  ProviderBase<ChatState> get state => chatPagePageContainer.state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messageList = [
      {"message": "Hello", "isSender": true},
      {"message": "Hello", "isSender": false}
    ];

    final chatPresenter = ref.watch(presenter);
    final chatState = ref.watch(state);
    String translate(String key) => FlutterI18n.translate(context, key);
    return MxcPage(
      layout: LayoutType.column,
      useContentPadding: false,
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: true,
      backgroundColor: ColorsTheme.of(context).black,
      presenter: ref.watch(presenter),
      appBar: AppNavBar(title: "${translate('moonchain')} ${translate('ai')}"),
      children: [
        Expanded(
          child: Align(
            alignment: AlignmentDirectional.topCenter,
            child: Container(
              padding: const EdgeInsets.only(
                  top: 16, bottom: 0, left: 24, right: 24),
              child: Column(
                children: [
                  Expanded(
                    child: GestureDetector(
                        onTap: () => chatPresenter.messageFocusNode.unfocus(),
                        child: MessagesList(messageList)
                        //  SingleChildScrollView(
                        //   child: Column(
                        //     children: [
                        //       // AIBanner(),
                        //       // SizedBox(
                        //       //   height: 30,
                        //       // ),
                        //       // AIPreSetButtons()
                        //     ],
                        //   ),
                        // ),
                        ),
                  ),
                  MessageTextfield()
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
