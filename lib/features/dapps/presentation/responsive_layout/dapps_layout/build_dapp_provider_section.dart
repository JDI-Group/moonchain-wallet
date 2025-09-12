import 'package:flutter/material.dart';
import 'package:mxc_logic/mxc_logic.dart';

import 'dapps_layout.dart';

List<Widget> buildDAppProviderSection(
  String providerTitle,
  List<Dapp> dapps,
  ProviderType providerType,
  Widget listWidget,
  Widget seeAllListWidget,
) {
  return [
    DAppProviderHeader(
      providerTitle: providerTitle,
      dapps: dapps,
      listWidget: seeAllListWidget,
    ),
    const SizedBox(
      height: 20,
    ),
    listWidget,
    const SizedBox(
      height: 30,
    ),
  ];
}
