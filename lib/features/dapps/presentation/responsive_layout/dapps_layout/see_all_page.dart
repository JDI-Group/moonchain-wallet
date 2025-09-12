import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:moonchain_wallet/common/common.dart';
import 'package:moonchain_wallet/features/common/common.dart';
import 'package:mxc_ui/mxc_ui.dart';

class SeeAllPage extends StatelessWidget {
  final String pageTitle;
  final Widget listWidget;
  const SeeAllPage(
      {super.key, required this.pageTitle, required this.listWidget});

  @override
  Widget build(BuildContext context) {
    String translate(String key) => FlutterI18n.translate(context, key);

    return MxcPage(
      resizeToAvoidBottomInset: true,
      layout: LayoutType.column,
      useContentPadding: false,
      useBlackBackground: true,
      childrenPadding: const EdgeInsets.only(
          top: Sizes.spaceNormal,
          right: Sizes.spaceXLarge,
          left: Sizes.spaceXLarge),
      appBar: AppNavBar(title: pageTitle),
      children: [
        listWidget,
      ],
    );
  }
}
