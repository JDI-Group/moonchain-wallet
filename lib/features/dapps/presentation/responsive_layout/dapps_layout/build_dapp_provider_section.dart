import 'package:flutter/material.dart';
import 'package:moonchain_wallet/features/dapps/presentation/responsive_layout/dapps_layout/native_dapp/native_dapp_list.dart';
import 'package:moonchain_wallet/features/dapps/presentation/responsive_layout/dapps_layout/partner_dapp/partner_dapp.dart';
import 'package:mxc_logic/mxc_logic.dart';

import 'dapps_layout.dart';
import 'native_dapp/native_dapp_card.dart';

List<Widget> buildDAppProviderSection(
  String providerTitle,
  List<Dapp> dapps,
  ProviderType providerType,
  Widget listWidget,
  Widget seeAllListWidget,
) {
  if (dapps.isEmpty) {
    return [
      Container(),
    ];
  } else {
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
}
