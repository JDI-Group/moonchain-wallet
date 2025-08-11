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
    final homePresenter = ref.read(presenter);
    final homeState = ref.watch(state);

    final additionalBottomPadding =
        math.max(MediaQuery.of(context).padding.bottom, 0.0);
    final bottomAppBarHeight = 50 + additionalBottomPadding;
    final screenWidth = MediaQuery.of(context).size.width;

    return MxcPage(
      layout: LayoutType.column,
      useContentPadding: false,
      floatingActionButton: const AiButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      backgroundColor: homeState.bottomNavigationCurrentIndex == 0
          ? ColorsTheme.of(context).primary
          : null,
      useBlackBackground:
          homeState.bottomNavigationCurrentIndex == 0 ? false : true,
      bottomNavigationBar: BottomAppBar(
        padding: const EdgeInsets.all(0),
        shape: ConvexNotchedRectangle(
          bottomAppBarHeight,
          screenWidth,
        ),
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
            index: homeState.bottomNavigationCurrentIndex,
            children: const [DAppsPage(), WalletPage()],
          ),
        ),
      ],
    );
  }
}

class ConvexNotchedRectangle extends NotchedShape {
  final double radius;
  final double height;
  final double width;

  /// Create Shape instance
  const ConvexNotchedRectangle(this.height, this.width, {this.radius = 0});

  @override
  Path getOuterPath(Rect host, Rect? guest) {
    var host = Rect.fromLTWH(0, 0, width, height);
    var percent = false
        ? (1 - const AlwaysStoppedAnimation<double>(0.5).value)
        : const AlwaysStoppedAnimation<double>(0.5).value;
    var guest = Rect.fromLTWH(width * percent - 180 / 2, -38.5, 180, 180);

    if (guest == null || !host.overlaps(guest)) return Path()..addRect(host);

    // The guest's shape is a circle bounded by the guest rectangle.
    // So the guest's radius is half the guest width.
    final notchRadius = guest.width / 2.0;

    const s1 = 15.0;
    const s2 = 1.0;

    final r = notchRadius;
    final a = -1.0 * r - s2;
    final b = host.top - guest.center.dy;

    final n2 = math.sqrt(b * b * r * r * (a * a + b * b - r * r));
    final p2xA = ((a * r * r) - n2) / (a * a + b * b);
    final p2xB = ((a * r * r) + n2) / (a * a + b * b);
    final p2yA = -math.sqrt(r * r - p2xA * p2xA);
    final p2yB = -math.sqrt(r * r - p2xB * p2xB);

    final p = List<Offset>.filled(6, Offset.zero, growable: false);
    // p0, p1, and p2 are the control points for segment A.
    p[0] = Offset(a - s1, b);
    p[1] = Offset(a, b);
    final cmp = b < 0 ? -1.0 : 1.0;
    p[2] = cmp * p2yA > cmp * p2yB ? Offset(p2xA, p2yA) : Offset(p2xB, p2yB);

    // p3, p4, and p5 are the control points for segment B, which is a mirror
    // of segment A around the y axis.
    p[3] = Offset(-1.0 * p[2].dx, p[2].dy);
    p[4] = Offset(-1.0 * p[1].dx, p[1].dy);
    p[5] = Offset(-1.0 * p[0].dx, p[0].dy);

    // translate all points back to the absolute coordinate system.
    for (var i = 0; i < p.length; i += 1) {
      p[i] = p[i] + guest.center;
      //p[i] += padding;
    }

    return radius > 0
        ? (Path()
          ..moveTo(host.left, host.top + radius)
          ..arcToPoint(Offset(host.left + radius, host.top),
              radius: Radius.circular(radius))
          ..lineTo(p[0].dx, p[0].dy)
          ..quadraticBezierTo(p[1].dx, p[1].dy, p[2].dx, p[2].dy)
          ..arcToPoint(
            p[3],
            radius: Radius.circular(notchRadius),
            clockwise: true,
          )
          ..quadraticBezierTo(p[4].dx, p[4].dy, p[5].dx, p[5].dy)
          ..lineTo(host.right - radius, host.top)
          ..arcToPoint(Offset(host.right, host.top + radius),
              radius: Radius.circular(radius))
          ..lineTo(host.right, host.bottom)
          ..lineTo(host.left, host.bottom)
          ..close())
        : (Path()
          ..moveTo(host.left, host.top)
          ..lineTo(p[0].dx, p[0].dy)
          ..quadraticBezierTo(p[1].dx, p[1].dy, p[2].dx, p[2].dy)
          ..arcToPoint(
            p[3],
            radius: Radius.circular(notchRadius),
            clockwise: true,
          )
          ..quadraticBezierTo(p[4].dx, p[4].dy, p[5].dx, p[5].dy)
          ..lineTo(host.right, host.top)
          ..lineTo(host.right, host.bottom)
          ..lineTo(host.left, host.bottom)
          ..close());
  }
}
