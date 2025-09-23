import 'package:flutter/material.dart';
import 'package:moonchain_wallet/common/assets.gen.dart';
import 'package:moonchain_wallet/core/core.dart';
import 'package:moonchain_wallet/features/portfolio/presentation/portfolio_page.dart';
import 'package:mxc_logic/mxc_logic.dart';
import 'package:mxc_ui/mxc_ui.dart';

import '../../dapps_presenter.dart';
import '../../dapps_state.dart';
import 'dapp_icon.dart';

List<Widget> getMostUsedButtons(
    List<Dapp> dapps,
    BuildContext context,
    DAppsState state,
    DAppsPagePresenter actions,
    String Function(String key) translate) {
  final list = dapps
      .map(
        (e) => MostUsedSectionsButton(
            icon: e.reviewApi!.iconV3!,
            onTap: () async {
              final dappUrl = e.app!.url!;
              if (!state.isEditMode) {
                await actions.requestPermissions(e);
                actions.openDapp(
                  dappUrl,
                );
              }
            },
            title: e.app?.name ?? e.app?.url ?? ''),
      )
      .toList();

  list.insert(
    0,
    MostUsedSectionsButton(
      title: translate('my_x').replaceFirst('{0}', translate('portfolio')),
      icon: Assets.svg.portfilio,
      onTap: () {
        Navigator.of(context).push(
          route(
            const PortfolioPage(),
          ),
        );
      },
    ),
  );
  return list;
}

class MostUsedSectionsButton extends StatelessWidget {
  final String title;
  final String icon;
  final void Function() onTap;
  const MostUsedSectionsButton(
      {super.key,
      required this.icon,
      required this.onTap,
      required this.title});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: InkWell(
          onTap: onTap,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(Sizes.spaceNormal),
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: ColorsTheme.of(context, listen: false).backgroundGrey,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                child: DappIcon(
                  image: icon,
                  iconSize: 24,
                  iconColor: Colors.white,
                ),
              ),
              const SizedBox(height: Sizes.spaceXSmall),
              Text(
                title,
                style: FontTheme.of(context).subtitle1().copyWith(
                      color: ColorsTheme.of(context).textBlack,
                      fontWeight: FontWeight.w500,
                    ),
                softWrap: false,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              )
            ],
          ),
        ),
      ),
    );
  }
}