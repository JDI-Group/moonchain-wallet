import 'package:flutter/material.dart';
import 'package:moonchain_wallet/features/ai_chat/presentation/widgets/messages/message_bubble_raw.dart';
import 'package:mxc_ui/mxc_ui.dart';

class MessageBubble extends MessageBubbleRaw {
  final String message;
  final bool isSender;
  final bool isLatests;
  const MessageBubble({
    super.key,
    required this.message,
    required this.isSender,
    required this.isLatests,
  }) : super(
          isSender: isSender,
          message: message,
          isRepeatingAnimation: false,
          shouldHaveTypeAnimation: isLatests,
          replay: false,
        );

  @override
  MainAxisAlignment get alignmentOnType {
    if (isSender) {
      return MainAxisAlignment.end;
    } else {
      return MainAxisAlignment.start;
    }
    // switch (chat.type) {
    //   case ChatMessageType.received:
    //     return MainAxisAlignment.start;

    //   case ChatMessageType.sent:
    //     return MainAxisAlignment.end;
    // }
  }

  @override
  Color colorOnType(BuildContext context) {
    if (isSender) {
      return ColorsTheme.of(context).primary;
    } else {
      return ColorsTheme.of(context).backgroundGrey;
    }
  }

  @override
  Color textColorOnType(BuildContext context) {
    if (isSender) {
      return ColorsTheme.of(context).black;
    } else {
      return ColorsTheme.of(context).white;
    }
  }

  @override
  Widget? trailingWidget()=> null;

  @override
  Widget border({required Widget child}) => Container(
        child: child,
      );
}
