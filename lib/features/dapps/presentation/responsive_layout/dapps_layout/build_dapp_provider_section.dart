import 'package:flutter/material.dart';
import 'package:moonchain_wallet/features/dapps/presentation/responsive_layout/dapps_layout/partner_dapp/partner_dapp.dart';
import 'package:mxc_logic/mxc_logic.dart';

import 'dapps_layout.dart';
import 'native_dapp/native_dapp_card.dart';

List<Widget> buildDAppProviderSection(
  String providerTitle,
  List<Dapp> dapps,
  ProviderType providerType,
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
      ),
      const SizedBox(
        height: 20,
      ),
      if (providerType == ProviderType.native)
        ListView.builder(
          itemCount: 4,
          scrollDirection: Axis.vertical,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) => NativeDAppCard(
            index: index,
            dapp: dapps[index],
          ),
        ),
      if (providerType == ProviderType.thirdParty)
        SizedBox(
          height: 150,
          child: ListView.builder(
            itemCount: dapps.length,
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemBuilder: (context, index) => PartnerDAppCard(
              index: index,
              dapp: dapps[index],
            ),
          ),
        ),
      if (providerType == ProviderType.bookmark)
        // It's a bookmark dapp
        SizedBox(
          height: 190,
          child: BookMarksGridView(
            dapps: dapps,
          ),
        ),
      const SizedBox(
        height: 30,
      ),
    ];
  }
}
