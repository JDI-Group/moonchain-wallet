import 'package:flutter/material.dart';
import 'package:moonchain_wallet/core/core.dart';
import 'package:moonchain_wallet/features/dapps/dapps.dart';
import 'package:moonchain_wallet/features/dapps/domain/home_page_index_use_case.dart';
import 'package:moonchain_wallet/features/home/presentation/home_page.dart';
import 'package:moonchain_wallet/features/portfolio/presentation/portfolio_page.dart';
import 'package:moonchain_wallet/features/wallet/wallet.dart';

class AppLinksRouter {
  AppLinksRouter(this.navigator);

  NavigatorState? navigator;

  // TODO:
  // CHeck login
  // What if already in that page
  // Check to push and replace or only push
  // Link : https://www.mxc1usd.com/app/
  // Routes : dapps - wallet - portfolio (wallet sub page) - openDapp - sendCrypto -
  //
  // https://www.mxc1usd.com/app/openDapp?url=https://github.com/reasje
  Widget openLink(Uri uri) {
    final page = getPage(uri);
    final params = getParams(uri);

    return getPageWithParams(page, params);
  }

  // Get page from uri
  String getPage(Uri uri) => uri.pathSegments[1];

  // Get params
  // Note: https://mxc1usd.com/app/openDapp?url=https://testnet.blueberryring.com?invite=p8M6E7b02l has the
  // https://testnet.blueberryring.com?invite=p8M6E7b02l as List of params in the first index
  Map<String, List<String>>? getParams(Uri uri) =>
      uri.hasQuery ? uri.queryParametersAll : null;

  // Push to stack
  Future pushTo(Widget page) => navigator!.push(route(page));
  // Remove stacks until that page
  Future pushAndReplaceUntil(Widget page) => navigator!.pushAndRemoveUntil(
        route(page),
        (route) => false,
      );
  void popUntil(String page) => navigator?.popUntil(
        (route) {
          return route.settings.name?.contains(page) ?? false;
        },
      );

  // Combine page with It's params
  Widget getPageWithParams(String page, Map<String, List<String>>? params) {
    late Widget toPushPage;

    switch ('/$page') {
      case '/':
        toPushPage = const HomePage();
        break;
      case '/dapps':
        toPushPage = const DAppsPage();
        break;
      case '/openDapp':
        final url = params!['url']![0];
        toPushPage = OpenDAppPage(
          url: url,
        );
        break;
      case '/wallet':
        toPushPage = const WalletPage();
        break;
      case '/portfolio':
        toPushPage = const PortfolioPage();
        break;
      default:
        toPushPage = const HomePage();
    }

    return toPushPage;
  }

  /// This function will do the navigation according to the page widget that
  /// includes the params based on how page specific navigation instruction.
  void navigateTo(
      Widget toPushPage, HomePageIndexUseCase homePageIndexUseCase) {
    late Function() navigationFunc;

    if (toPushPage.runtimeType == OpenDAppPage) {
      navigationFunc = () {
        pushTo(toPushPage);
      };
    } else if (toPushPage.runtimeType == PortfolioPage) {
      navigationFunc = () {
        pushAndReplaceUntil(
          const HomePage(),
        );
      };
    } else if (toPushPage is HomePage) {
      navigationFunc = () {};
    } else if (toPushPage is WalletPage) {
      navigationFunc = () {
        popUntil('PasscodeRequireWrapperPage');
        homePageIndexUseCase
            .changeBottomNavigationSubPage(HomePageSubPage.wallet);
      };
    } else if (toPushPage is DAppsPage) {
      navigationFunc = () {
        popUntil('PasscodeRequireWrapperPage');
        homePageIndexUseCase
            .changeBottomNavigationSubPage(HomePageSubPage.dapps);
      };
    } else {
      navigationFunc = () {
        pushAndReplaceUntil(toPushPage);
      };
    }

    navigationFunc();
  }
}
