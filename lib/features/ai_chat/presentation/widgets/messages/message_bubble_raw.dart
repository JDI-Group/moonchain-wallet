import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moonchain_wallet/features/ai_chat/presentation/chat_presenter.dart';
import 'package:moonchain_wallet/features/ai_chat/presentation/chat_state.dart';
import 'package:mxc_ui/mxc_ui.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

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
                  ? AnimatedTextWidget(
                      message: message,
                      changeMessage: changeMessage,
                      textColor: textColorOnType(context),
                      chatPresenter: chatPresenter,
                      isRepeatingAnimation: isRepeatingAnimation)
                  : MarkdownBody(
                      data: changeMessage(context, message),
                      selectable: false,
                      // styleSheetTheme: MarkdownStyleSheetBaseTheme.material.,
                      shrinkWrap: true,
                      // padding: EdgeInsets.zero,
                      onTapLink: (text, href, title) async {
                        if (href != null) {
                          chatPresenter.launchUrl(href);
                        }
                      },
                      sizedImageBuilder: (config) {
                        final path = config.uri.toString();

                        // Handle local SVG
                        if (path.endsWith(".svg")) {
                          return CircleAvatar(
                            radius: 12,
                            backgroundColor: Colors.transparent,
                            child: SvgPicture.asset(path),
                          );
                        }

                        // Handle normal PNG/JPG assets
                        if (path.startsWith("assets/")) {
                          return CircleAvatar(
                            radius: 12,
                            backgroundImage: AssetImage(path),
                            backgroundColor: Colors.transparent,
                          );
                        }

                        // Handle network images
                        return CircleAvatar(
                          radius: 12,
                          backgroundImage: NetworkImage(path),
                          backgroundColor: Colors.transparent,
                        );
                      },
                      styleSheet: MarkdownStyleSheet(
                        h1: FontTheme.of(context).body1().copyWith(
                              color: textColorOnType(context),
                            ),
                        p: FontTheme.of(context).body1().copyWith(
                              color: textColorOnType(context),
                            ),
                        // tableCellsDecoration: BoxDecoration(
                        //   color: Colors.grey[100], // background of each cell
                        //   border:
                        //       Border.all(color: Colors.grey), // cell borders

                        // ),
                        tableCellsPadding:
                            const EdgeInsets.all(Sizes.space2XSmall),
                        tableHead: FontTheme.of(context).caption2().copyWith(
                              color: textColorOnType(context),
                              fontWeight: FontWeight.w700,
                            ),
                        tableBody: FontTheme.of(context).caption2().copyWith(
                              color: textColorOnType(context),
                            ),
                      ),
                    )
              // Text(
              //     changeMessage(context, message),
              //     style: FontTheme.of(context).body1().copyWith(
              //           color: textColorOnType(context),

              //         ),
              //   ),
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
      // onNextBeforePause: (i, _) => chatPresenter.scrollToBottom(),
      // onNext: (i, _) => chatPresenter.scrollToBottom(),
      onFinished: () => widget.chatPresenter.scrollToBottom(),
    );
  }
}
