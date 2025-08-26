import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moonchain_wallet/features/ai_chat/presentation/chat_presenter.dart';
import 'package:moonchain_wallet/features/ai_chat/presentation/chat_state.dart';
import 'package:mxc_ui/mxc_ui.dart';

abstract class MessageBubbleRaw extends HookConsumerWidget {
  final String message;
  final bool isSender;
  final bool isRepeatingAnimation;
  final bool shouldHaveTypeAnimation;
  const MessageBubbleRaw({
    super.key,
    required this.message,
    required this.isSender,
    required this.isRepeatingAnimation,
    required this.shouldHaveTypeAnimation,
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
            child: !isSender && shouldHaveTypeAnimation
                ? AnimatedTextKit(
                    controller: chatPresenter.animatedTextController,
                    displayFullTextOnTap: true,
                    isRepeatingAnimation: isRepeatingAnimation,
                    animatedTexts: [
                      TyperAnimatedText(
                        changeMessage(context, message),
                        speed: const Duration(milliseconds: 60),
                        textStyle: FontTheme.of(context).body1().copyWith(
                              color: textColorOnType(context),
                            ),
                      )
                    ],
                    // onNextBeforePause: (i, _) => chatPresenter.scrollToBottom(),
                    // onNext: (i, _) => chatPresenter.scrollToBottom(),
                    onFinished: () => chatPresenter.scrollToBottom(),
                  )
                : Text(
                    changeMessage(context, message),
                    style: FontTheme.of(context).body1().copyWith(
                          color: textColorOnType(context),
                        ),
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
