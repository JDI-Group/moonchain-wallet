import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moonchain_wallet/common/assets.gen.dart' show Assets;
import 'package:moonchain_wallet/core/core.dart';
import 'package:moonchain_wallet/features/ai_chat/presentation/chat_page.dart';
import 'package:moonchain_wallet/features/dapps/presentation/dapps_presenter.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moonchain_wallet/features/dapps/presentation/dapps_state.dart';
import 'package:moonchain_wallet/features/portfolio/presentation/portfolio_page.dart';
import 'package:mxc_logic/mxc_logic.dart' show Dapp, ProviderType;

import 'package:mxc_ui/mxc_ui.dart';

import 'dapp_loading.dart';
import 'dapp_utils.dart';
import 'dapps_layout/dapps_layout.dart';
import 'dapps_layout/native_dapp/native_dapp_list.dart';

class DappCardLayout extends HookConsumerWidget {
  const DappCardLayout({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(appsPagePageContainer.state);
    final actions = ref.read(appsPagePageContainer.actions);
    final dapps = state.orderedDapps;

    if (state.orderedDapps.isEmpty) {
      return Container();
    }

    final List<Dapp> bookmarksDapps = actions.getBookmarkDapps();
    final List<Dapp> nativeDapps = actions.getNativeDapps();
    final List<Dapp> partnerDapps = actions.getPartnerDapps();
    final List<Dapp> mostUsedDapps = actions.getMostUsedDapps();

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

    return InkWell(
      onTap: actions.changeEditMode,
      child: constraintWrapperWidget(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Flexible(
              flex: 30,
              child: Container(
                padding: const EdgeInsets.only(
                    left: Sizes.spaceXLarge,
                    right: Sizes.spaceXLarge,
                    bottom: Sizes.spaceLarge,
                    top: Sizes.spaceXSmall),
                decoration: BoxDecoration(
                  color: ColorsTheme.of(context).primary,
                ),
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          route(
                            const ChatPage(),
                          ),
                        );
                      },
                      child: Container(
                        key: const Key('AITextField'),
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        height: 56,
                        decoration: BoxDecoration(
                            color: ColorsTheme.of(context)
                                .white
                                .withValues(alpha: 0.12),
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
                              style: FontTheme.of(context).body1().copyWith(
                                    color: ColorsTheme.of(context, listen: false)
                                        .backgroundGrey,
                                  ),
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
                    const SizedBox(
                      height: Sizes.spaceXLarge,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: getMostUsedButtons(
                        mostUsedDapps,
                        context,
                        state,
                        actions,
                        translate,
                      ),
                    )
                  ],
                ),
              ),
            ),
            Flexible(
              fit: FlexFit.loose,
              flex: 70,
              child: Align(
                alignment: Alignment.topCenter,
                child: Container(
                  padding: const EdgeInsets.only(
                    right: Sizes.spaceXLarge,
                    left: Sizes.spaceXLarge,
                    top: Sizes.space4XLarge,
                    // vertical: Sizes.space4XLarge,
                  ),
                  decoration: BoxDecoration(
                    color: ColorsTheme.of(context).black,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        ...buildDAppProviderSection(
                          '${translate('native')} ${translate('dapps')}',
                          nativeDapps,
                          ProviderType.native,
                          NativeDappList(
                            dapps: nativeDapps.sublist(nativeDapps.length > 4
                                ? nativeDapps.length - 4
                                : nativeDapps.length),
                            isScrollingLocked: true,
                          ),
                          NativeDappList(dapps: nativeDapps),
                        ),
                        ...buildDAppProviderSection(
                          '${translate('partner')} ${translate('dapps')}',
                          partnerDapps,
                          ProviderType.thirdParty,
                          SizedBox(
                            height: 120,
                            child: ListView.separated(
                              itemCount: partnerDapps.length,
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemBuilder: (context, index) => PartnerDAppCard(
                                index: index,
                                dapp: partnerDapps[index],
                                horizontallyExpanded: false,
                              ),
                              separatorBuilder: (context, index) =>
                                  const SizedBox(width: 16),
                            ),
                          ),
                          ListView.separated(
                            itemCount: partnerDapps.length,
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemBuilder: (context, index) => SizedBox(
                              height: 100,
                              child: PartnerDAppCard(
                                index: index,
                                dapp: partnerDapps[index],
                                horizontallyExpanded: true,
                              ),
                            ),
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 16),
                          ),
                        ),
                        ...buildDAppProviderSection(
                          translate('webhooks'),
                          bookmarksDapps,
                          ProviderType.bookmark,
                          SizedBox(
                            height: 200,
                            child: BookMarksGridView(
                              dapps: bookmarksDapps,
                              seeAll: false,
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.8,
                            child: BookMarksGridView(
                              dapps: bookmarksDapps,
                              seeAll: true,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
      
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
      ),
    );
  }
}

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
// [
//   // const SizedBox(
//   //   width: Sizes.space2XSmall,
//   // ),
//   // Fixed
//   MostUsedSectionsButton(
//     title: translate('my_x').replaceFirst('{0}', translate('portfolio')),
//     icon: Assets.svg.portfilio,
//     onTap: () {
//       Navigator.of(context).push(
//         route(
//           const PortfolioPage(),
//         ),
//       );
//     },
//   ),
//   // Most used dapps
//   MostUsedSectionsButton(
//     title: translate('portfolio'),
//     icon: Assets.svg.portfilio,
//     onTap: () {
//       Navigator.of(context).push(
//         route(
//           const PortfolioPage(),
//         ),
//       );
//     },
//   ),
//   MostUsedSectionsButton(
//     title: translate('portfolio'),
//     icon: Assets.svg.portfilio,
//     onTap: () {
//       Navigator.of(context).push(
//         route(
//           const PortfolioPage(),
//         ),
//       );
//     },
//   ),
//   // Fixed
//   MostUsedSectionsButton(
//     title: translate('track_x').replaceFirst('{0}', translate('tokens')),
//     icon: Assets.svg.token,
//     onTap: () {
//       Navigator.of(context).push(
//         route(
//           const PortfolioPage(),
//         ),
//       );
//     },
//   ),
//   // const SizedBox(
//   //   width: Sizes.space2XSmall,
//   // ),
// ];

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
              )),
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
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: ColorsTheme.of(context, listen: false).backgroundGrey,
          ),
          child: SvgPicture.asset(assetPath),
        )
      ],
    );
  }
}
