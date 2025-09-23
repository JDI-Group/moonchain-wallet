import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:moonchain_wallet/features/dapps/presentation/dapps_presenter.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moonchain_wallet/features/dapps/presentation/responsive_layout/dapps_layout/ai_textfield.dart';
import 'package:mxc_logic/mxc_logic.dart' show Dapp, ProviderType;

import 'package:mxc_ui/mxc_ui.dart';

import 'dapp_loading.dart';
import 'dapp_utils.dart';
import 'dapps_layout/dapps_layout.dart';
import 'dapps_layout/most_used_section_button.dart';
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

    return GestureDetector(
      onTap: state.isEditMode ? actions.changeEditMode : null,
      child: constraintWrapperWidget(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
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
                  const AiTextfield(),
                  const SizedBox(
                    height: Sizes.spaceXLarge,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
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
            Flexible(
              fit: FlexFit.loose,
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
                        // if (nativeDapps.isNotEmpty)
                        ...buildDAppProviderSection(
                          '${translate('native')} ${translate('dapps')}',
                          nativeDapps,
                          ProviderType.native,
                          NativeDappList(
                            dapps: nativeDapps.length > 4
                                ? nativeDapps.sublist(nativeDapps.length > 4
                                    ? nativeDapps.length - 4
                                    : nativeDapps.length)
                                : nativeDapps,
                            isScrollingLocked: true,
                          ),
                          NativeDappList(dapps: nativeDapps),
                        ),
                        if (partnerDapps.isNotEmpty)
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
                                itemBuilder: (context, index) =>
                                    PartnerDAppCard(
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
          ],
        ),
      ),
    );
  }
}
