import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:moonchain_wallet/core/core.dart';
import 'package:flutter/material.dart';
import 'package:moonchain_wallet/features/home/home.dart';
import 'home_state.dart';

class HomePageArguments with EquatableMixin {
  const HomePageArguments({
    required this.homePageSubPage,
  });

  final HomePageSubPage? homePageSubPage;

  @override
  List<dynamic> get props => [
        homePageSubPage,
      ];
}

final homePagePageContainer = PresenterContainerWithParameter<
    HomePagePresenter,
    HomeState,
    HomePageArguments?>((params) => HomePagePresenter(params?.homePageSubPage));

class HomePagePresenter extends CompletePresenter<HomeState> {
  HomePagePresenter(this.initialHomePageSubPage) : super(HomeState());

  late final _bookmarksUseCase = ref.read(bookmarksUseCaseProvider);
  late final _dappStoreUseCase = ref.read(dappStoreUseCaseProvider);
  late final _chainConfigurationUseCase =
      ref.read(chainConfigurationUseCaseProvider);
  late final _gesturesInstructionUseCase =
      ref.read(gesturesInstructionUseCaseProvider);
  late final _accountUseCase = ref.read(accountUseCaseProvider);
  late final _dappsOrderUseCase = ref.read(dappsOrderUseCaseProvider);
  late final _homePageIndexUseCase = ref.read(homePageIndexUseCaseProvider);

  final HomePageSubPage? initialHomePageSubPage;
  final scrollController = ScrollController();
  final PageController pageController = PageController(initialPage: 0);

  @override
  void initState() {
    super.initState();

    pageController.addListener(() {
      final pageIndex = pageController.page!.toInt();
      notify(
        () => state.bottomNavigationCurrentIndex = pageIndex
      );
      _homePageIndexUseCase.updateIndex(pageIndex);
    });

    _homePageIndexUseCase.index.listen((index) {
      if (index != state.bottomNavigationCurrentIndex) {
        moveToPage(index);
      }
    });
  }

  changePage(int index) =>
      _homePageIndexUseCase.changeBottomNavigationIndexTo(index);

  moveToPage(int index) => pageController.page == null
      ? null
      : pageController.animateToPage(index,
          duration: const Duration(seconds: 1), curve: Curves.easeInOut);

  @override
  Future<void> dispose() async {
    super.dispose();
  }
}
