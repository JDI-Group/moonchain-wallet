import 'package:flutter_svg/svg.dart';
import 'package:moonchain_wallet/common/assets.gen.dart';
import 'package:moonchain_wallet/common/common.dart';
import 'package:moonchain_wallet/features/dapps/dapps.dart';
import 'package:moonchain_wallet/features/dapps/presentation/widgets/ai_button.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moonchain_wallet/features/wallet/wallet.dart';
import 'package:mxc_ui/mxc_ui.dart';

import 'dart:math' as math;

import 'home_presenter.dart';
import 'home_state.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  ProviderBase<HomePagePresenter> get presenter =>
      homePagePageContainer.actions;

  @override
  ProviderBase<HomeState> get state => homePagePageContainer.state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homePresenter = ref.watch(presenter);
    final homeState = ref.watch(state);
    return MxcPage(
      layout: LayoutType.column,
      useContentPadding: false,
      floatingActionButton: const AiButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterDocked,
      bottomNavigationBar: BottomAppBar(
        padding: const EdgeInsets.all(0),
        shape: HillNotchedShape(),
        color: ColorsTheme.of(context).backgroundGrey,
        notchMargin: 10,
        surfaceTintColor: ColorsTheme.of(context).backgroundGrey,
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: ColorsTheme.of(context).backgroundGrey,
          fixedColor: ColorsTheme.of(context).backgroundGrey,
          currentIndex: homeState.bottomNavigationCurrentIndex,
          onTap: homePresenter.changeBottomNavigationIndex,
          items: [
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                Assets.svg.indexGary,
                height: 24,
                width: 24,
              ),
              activeIcon: SvgPicture.asset(
                Assets.svg.indexWhite,
                height: 24,
                width: 24,
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                Assets.svg.walletGary,
                height: 24,
                width: 24,
              ),
              activeIcon: SvgPicture.asset(
                Assets.svg.walletWhite,
                height: 24,
                width: 24,
              ),
              label: '',
            ),
          ],
        ),
      ),
      childrenPadding: EdgeInsets.zero,
      // childrenPadding: const EdgeInsets.symmetric(
      //     horizontal: Sizes.spaceSmall, vertical: Sizes.spaceNormal),
      // useGradientBackground: true,
      presenter: ref.watch(presenter),
      // appBar: Column(
      //   children: [
      //     ref.watch(state).isEditMode
      //         ? const EditModeAppBar()
      //         : const DefaultAppBar(),
      //   ],
      // ),
      children: [
        Expanded(
          child: IndexedStack(
            index: homeState.pageIndex,
            children: const [DAppsPage(), WalletPage()],
          ),
        ),
      ],
    );
  }
}


class HillNotchedShape extends NotchedShape {
  @override
  Path getOuterPath(Rect host, Rect? guest) {
    if (guest == null || !host.overlaps(guest)) {
      return Path()..addRect(host);
    }

    final notchCenter = guest.center.dx;
    final hillWidth = guest.width * 2.5;
    const hillHeight = 40.0;

    final hillStart = notchCenter - hillWidth / 2;
    final hillEnd = notchCenter + hillWidth / 2;

    final path = Path()
      ..moveTo(host.left, host.top)
      ..lineTo(hillStart, host.top)

      // Left curve (steep/thin start)
      ..cubicTo(
        hillStart + hillWidth * 0.03, host.top,                     // control point 1 (very close to hillStart)
        notchCenter - hillWidth * 0.35, host.top - hillHeight,      // control point 2
        notchCenter, host.top - hillHeight                          // peak
      )

      // Right curve (steep/thin end)
      ..cubicTo(
        notchCenter + hillWidth * 0.35, host.top - hillHeight,      // control point 1
        hillEnd - hillWidth * 0.03, host.top,                       // control point 2 (very close to hillEnd)
        hillEnd, host.top                                           // end of hill
      )

      ..lineTo(host.right, host.top)
      ..lineTo(host.right, host.bottom)
      ..lineTo(host.left, host.bottom)
      ..close();

    return path;
  }
}