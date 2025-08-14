import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mxc_ui/mxc_ui.dart';

class PreSetConversations extends StatelessWidget {
  final Function onTap;
  final String title;
  final String icon;
  const PreSetConversations(
      {super.key,
      required this.onTap,
      required this.title,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    String translate(String key) => FlutterI18n.translate(context, key);

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: ColorsTheme.of(context).backgroundGrey,
          borderRadius: const BorderRadius.all(Radius.circular(10))),
      child: Row(
        children: [
          SvgPicture.asset(icon),
          const SizedBox(
            width: 10,
          ),
          Text(translate(title),
              style: FontTheme.of(context)
                  .subtitle2()
                  .copyWith(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}