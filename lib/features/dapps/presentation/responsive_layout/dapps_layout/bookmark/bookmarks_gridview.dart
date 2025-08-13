import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moonchain_wallet/features/dapps/presentation/dapps_presenter.dart';
import 'package:mxc_logic/mxc_logic.dart';
import 'package:mxc_ui/mxc_ui.dart';

import '../dapps_layout.dart';
import 'bookmark_dapp_card.dart';

class BookMarksGridView extends HookConsumerWidget {
  final List<Dapp> dapps;
  final bool seeAll;

  const BookMarksGridView({
    super.key,
    required this.dapps,
    required this.seeAll,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // This is the case where dapps Then build empty space
    String translate(String key) => FlutterI18n.translate(context, key);
    final state = ref.watch(appsPagePageContainer.state);
    
    final isDappsEmpty = dapps.isEmpty;
    final itemCount = seeAll
        ? dapps.length + 1
        : dapps.length > 7
            ? 8
            : dapps.length + 1;

    return isDappsEmpty
        ? Container()
        : AbsorbPointer(
          absorbing: state.isEditMode,
          child: GridView.builder(
              scrollDirection: Axis.vertical,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                // mainAxisSpacing: 8,
                // crossAxisSpacing: 20,
              ),
              itemCount: itemCount,
              padding: const EdgeInsets.symmetric(vertical: 10),
              itemBuilder: (context, index) => index == dapps.length
                  ? SizedBox(
                      height: 82,
                      width: 84,
                      child: Column(
                        children: [
                          Container(
                            height: 54,
                            width: 54,
                            decoration: BoxDecoration(
                              color: ColorsTheme.of(context).backgroundGrey,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(20),
                              ),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.add_rounded,
                                size: Sizes.space2XLarge,
                                color: ColorsTheme.of(context).white,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            translate('add'),
                            style: FontTheme.of(context)
                                .subtitle2
                                .primary()
                                .copyWith(fontWeight: FontWeight.w800),
                            softWrap: false,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    )
                  : BookmarkCard(
                      index: index,
                      dapp: dapps[index],
                    ),
            ),
        );
  }
}
