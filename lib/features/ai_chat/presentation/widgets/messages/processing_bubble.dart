import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:moonchain_wallet/features/ai_chat/presentation/widgets/gredient.dart';
import 'package:moonchain_wallet/features/ai_chat/presentation/widgets/messages/message_bubble_raw.dart';
import 'package:mxc_ui/mxc_ui.dart';

class ProcessingBubble extends MessageBubbleRaw {
  const ProcessingBubble({
    super.key,
  }) : super(
          isSender: false,
          // Will format message
          message: '',
          isRepeatingAnimation: true,
          shouldHaveTypeAnimation: true,
          replay: true,
          charDelay: const Duration(milliseconds: 70),
        );

  // @override
  String changeMessage(BuildContext context, String message) =>
      "${FlutterI18n.translate(context, 'processing')} ...";

  @override
  Widget border({required Widget child}) => Container(
        padding: const EdgeInsets.all(1),
        decoration: BoxDecoration(
          gradient: getLinearGradient(vertically: false),
          borderRadius: const BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        child: child,
      );

  @override
  MainAxisAlignment get alignmentOnType {
    return MainAxisAlignment.start;
  }

  @override
  Color colorOnType(BuildContext context) {
    return ColorsTheme.of(context).backgroundGrey;
  }

  @override
  Color textColorOnType(BuildContext context) {
    return ColorsTheme.of(context).white;
  }
}
