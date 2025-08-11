import 'package:moonchain_wallet/common/common.dart';
import 'package:moonchain_wallet/features/dapps/presentation/widgets/default_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mxc_ui/mxc_ui.dart';

import 'dapps_presenter.dart';
import 'dapps_state.dart';
import 'responsive_layout/responsive_layout.dart';

class DAppsPage extends HookConsumerWidget {
  const DAppsPage({Key? key}) : super(key: key);

  @override
  ProviderBase<DAppsPagePresenter> get presenter =>
      appsPagePageContainer.actions;

  @override
  ProviderBase<DAppsState> get state => appsPagePageContainer.state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dappsPresenter = ref.watch(presenter);
    final dappsState = ref.watch(state);
    return MxcPage(
      layout: LayoutType.column,
      useContentPadding: false,
      extendBodyBehindAppBar: true,
      backgroundColor: ColorsTheme.of(context).primary,
      presenter: ref.watch(presenter),
      appBar:  const DefaultAppBar(),
      children: const [
        Expanded(
          child: Align(
              alignment: AlignmentDirectional.topCenter,
              child: ResponsiveLayout()),
        )
      ],
    );
  }
}
