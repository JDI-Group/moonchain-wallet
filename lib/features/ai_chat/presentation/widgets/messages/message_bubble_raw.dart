import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moonchain_wallet/features/ai_chat/presentation/chat_presenter.dart';
import 'package:moonchain_wallet/features/ai_chat/presentation/chat_state.dart';
import 'package:moonchain_wallet/features/ai_chat/presentation/widgets/messages/typing_markdown.dart';
import 'package:mxc_ui/mxc_ui.dart';

abstract class MessageBubbleRaw extends HookConsumerWidget {
  final String message;
  final bool isSender;
  final bool isRepeatingAnimation;
  final bool shouldHaveTypeAnimation;
  final bool replay;
  final Duration? charDelay;
  const MessageBubbleRaw({
    super.key,
    required this.message,
    required this.isSender,
    required this.isRepeatingAnimation,
    required this.shouldHaveTypeAnimation,
    required this.replay,
    this.charDelay,
  });

  @override
  ProviderBase<ChatPresenter> get presenter => chatPagePageContainer.actions;

  @override
  ProviderBase<ChatState> get state => chatPagePageContainer.state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatPresenter = ref.watch(presenter);
    final chatState = ref.watch(state);

    return Row(
      mainAxisAlignment: alignmentOnType,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        border(
          child: Container(
            padding: const EdgeInsets.all(Sizes.spaceNormal),
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.8,
            ),
            decoration: BoxDecoration(
              color: colorOnType(context),
              borderRadius: const BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            child: TypingMarkdown(
              data: changeMessage(context, message),
              textColor: textColorOnType(context),
              shouldAnimate: !isSender && shouldHaveTypeAnimation,
              chatPresenter: chatPresenter,
              replay: replay,
              charDelay: charDelay,
            ),
          ),
        ),
      ],
    );
  }

  String changeMessage(BuildContext context, String message) => message;

  Widget border({required Widget child});

  MainAxisAlignment get alignmentOnType;

  Color colorOnType(BuildContext context);

  Color textColorOnType(BuildContext context);
}

class AnimatedTextWidget extends StatefulWidget {
  final String Function(BuildContext context, String message) changeMessage;
  final String message;
  final Color textColor;
  final ChatPresenter chatPresenter;
  final bool isRepeatingAnimation;

  const AnimatedTextWidget({
    super.key,
    required this.message,
    required this.changeMessage,
    required this.textColor,
    required this.chatPresenter,
    required this.isRepeatingAnimation,
  });

  @override
  _AnimatedTextWidgetState createState() => _AnimatedTextWidgetState();
}

class _AnimatedTextWidgetState extends State<AnimatedTextWidget>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true; // 👈 tells Flutter to keep state alive

  @override
  Widget build(BuildContext context) {
    super.build(context); // 👈 important when using KeepAlive
    return AnimatedTextKit(
      controller: widget.chatPresenter.animatedTextController,
      displayFullTextOnTap: true,
      isRepeatingAnimation: widget.isRepeatingAnimation,
      animatedTexts: [
        TyperAnimatedText(
          widget.changeMessage(context, widget.message),
          speed: const Duration(milliseconds: 60),
          textStyle: FontTheme.of(context).body1().copyWith(
                color: widget.textColor,
              ),
        )
      ],
      onFinished: () => widget.chatPresenter.scrollToBottom(),
    );
  }
}
