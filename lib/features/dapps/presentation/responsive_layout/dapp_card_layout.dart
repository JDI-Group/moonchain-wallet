import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moonchain_wallet/common/assets.gen.dart' show Assets;
import 'package:moonchain_wallet/core/src/routing/route.dart';
import 'package:moonchain_wallet/features/dapps/presentation/dapps_presenter.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moonchain_wallet/features/portfolio/presentation/portfolio_page.dart';
import 'package:mxc_logic/mxc_logic.dart' show Dapp;

import 'package:mxc_ui/mxc_ui.dart';

import 'dapp_loading.dart';
import 'dapp_utils.dart';
import 'dapps_layout/dapps_layout.dart';

class DappCardLayout extends HookConsumerWidget {
  const DappCardLayout({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(appsPagePageContainer.state);
    final actions = ref.read(appsPagePageContainer.actions);
    final dapps = state.orderedDapps;

    final List<Dapp> bookmarksDapps = actions.getBookmarkDapps();
    final List<Dapp> nativeDapps = actions.getNativeDapps();
    final List<Dapp> partnerDapps = actions.getPartnerDapps();

    // final pages = actions.calculateMaxItemsCount(
    //     dapps.length, mainAxisCount, crossAxisCount);
    // final emptyItems = actions.getRequiredItems(
    //     dapps.length, mainAxisCount, crossAxisCount, pages);
    // List<Widget> emptyWidgets =
    //     List.generate(emptyItems, (index) => Container());

    if (state.loading && DappUtils.loadingOnce) {
      return DAppLoading();
    }

    if (dapps.isEmpty) return Container();

    String translate(String key) => FlutterI18n.translate(context, key);

    Widget constraintWrapperWidget(Widget child) => ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 780),
          child: child,
        );

    if (state.seeAllDapps != null) {
      return DAppsListView(mainAxisCount: 0);
    }

    return constraintWrapperWidget(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            flex: 30,
              child: Container(
            padding: const EdgeInsets.only(
                left: Sizes.spaceXLarge,
                right: Sizes.spaceXLarge,
                bottom: Sizes.spaceXLarge,
                top: Sizes.spaceSmall),
            decoration: BoxDecoration(
              color: ColorsTheme.of(context).primary,
            ),
            child: Column(
              children: [
                InkWell(
                  onTap: () {},
                  child: Container(
                    key: const Key('AITextField'),
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    height: 58,
                    decoration: BoxDecoration(
                        color: ColorsTheme.of(context)
                            .primary
                            .withValues(alpha: 0.8),
                        border: Border.all(
                          color: Colors.black,
                          width: 2,
                        ),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20))),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          translate('ask_moonchain_ai_anything'),
                          style: FontTheme.of(context)
                              .body1()
                              .copyWith(color: const Color(0xFF1E1F24)),
                        ),
                        const Spacer(),
                        SvgPicture.asset(
                          Assets.svg.aiBlack,
                          colorFilter: const ColorFilter.mode(
                              Colors.black, BlendMode.srcIn),
                        )
                      ],
                    ),
                  ),
                ),
                // MxcTextField(
                //   key: const Key('AITextField'),
                //   controller: TextEditingController(),
                //   hint: translate('ask_moonchain_ai_anything'),
                //   suffixButton: MxcTextFieldButton.svg(
                //     svg: Assets.svg.aiBlack,
                //     color: Colors.black,
                //     onTap: () {},
                //   ),
                //   readOnly: true,
                //   hasClearButton: false,
                // ),
                const SizedBox(
                  height: Sizes.spaceXLarge,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: getMostUsedButtons(context, translate),
                )
              ],
            ),
          )),
          Expanded(
              flex: 70,
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: Sizes.spaceXLarge,
                    vertical: Sizes.space4XLarge),
                decoration: BoxDecoration(
                  color: ColorsTheme.of(context).black,
                ),
                child: Column(
                  children: [
                    ListView.builder(itemCount: 4, itemBuilder: (context, index) {
                      
                    },),
                    ...buildDAppProviderSection(
                        '${translate('native')} ${translate('dapps')}',
                        nativeDapps,
                        2,
                        ),
                  ],
                ),
              ))

          // ...buildDAppProviderSection(
          //     '${translate('partner')} ${translate('dapps')}',
          //     partnerDapps,
          //     2,
          //     2,
          //     mainAxisCount),
          // ...buildDAppProviderSection(
          //     translate('bookmark'), bookmarksDapps, 1, 1, mainAxisCount),
        ],
      ),
    );
  }
}

List<Widget> getMostUsedButtons(
        BuildContext context, String Function(String key) translate) =>
    [
      // const SizedBox(
      //   width: Sizes.space2XSmall,
      // ),
      // Fixed
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
      // Most used dapps
      MostUsedSectionsButton(
        title: translate('portfolio'),
        icon: Assets.svg.portfilio,
        onTap: () {
          Navigator.of(context).push(
            route(
              const PortfolioPage(),
            ),
          );
        },
      ),
      MostUsedSectionsButton(
        title: translate('portfolio'),
        icon: Assets.svg.portfilio,
        onTap: () {
          Navigator.of(context).push(
            route(
              const PortfolioPage(),
            ),
          );
        },
      ),
      // Fixed
      MostUsedSectionsButton(
        title: translate('track_x').replaceFirst('{0}', translate('tokens')),
        icon: Assets.svg.token,
        onTap: () {
          Navigator.of(context).push(
            route(
              const PortfolioPage(),
            ),
          );
        },
      ),
      // const SizedBox(
      //   width: Sizes.space2XSmall,
      // ),
    ];

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
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(Sizes.spaceNormal),
            decoration: const BoxDecoration(
              shape: BoxShape.rectangle,
              color: Color(0XFF1E1F24),
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            child: SvgPicture.asset(
              icon,
              height: 24,
              width: 24,
              colorFilter: const ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
            ),
          ),
          const SizedBox(height: Sizes.spaceXSmall),
          Text(
            title,
            style: FontTheme.of(context).body1().copyWith(
                color: ColorsTheme.of(context).textBlack,
                fontWeight: FontWeight.w600),
          )
        ],
      ),
    );
  }
}


class NativeDAppItem extends StatelessWidget {
  final String assetPath;
  const NativeDAppItem({super.key, required this.assetPath});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFF1E1F24)
          ),
          child: SvgPicture.asset(assetPath),
        )
      ],
    );
  }
}