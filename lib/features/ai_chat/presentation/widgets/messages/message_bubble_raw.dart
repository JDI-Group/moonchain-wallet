import 'package:flutter/material.dart';
import 'package:mxc_ui/mxc_ui.dart';

abstract class MessageBubbleRaw extends StatelessWidget {
  final String message;
  final bool isSender;
  const MessageBubbleRaw({
    super.key,
    required this.message,
    required this.isSender,
  });

  @override
  Widget build(BuildContext context) {
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
            child: Text(
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
