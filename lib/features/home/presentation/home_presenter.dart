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
    HomePageArguments>((params) => HomePagePresenter(params.homePageSubPage));

class HomePagePresenter extends CompletePresenter<HomeState> {
  HomePagePresenter(this.initialHomePageSubPage) : super(HomeState()) {
    changeBottomNavigationIndex(initialHomePageSubPage!.index);
  }

  late final _bookmarksUseCase = ref.read(bookmarksUseCaseProvider);
  late final _dappStoreUseCase = ref.read(dappStoreUseCaseProvider);
  late final _chainConfigurationUseCase =
      ref.read(chainConfigurationUseCaseProvider);
  late final _gesturesInstructionUseCase =
      ref.read(gesturesInstructionUseCaseProvider);
  late final _accountUseCase = ref.read(accountUseCaseProvider);
  late final _dappsOrderUseCase = ref.read(dappsOrderUseCaseProvider);

  final HomePageSubPage? initialHomePageSubPage;
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    // Future.delayed(const Duration(seconds: 1, ), () {
    //   if (initialHomePageSubPage != null) {
    //     changeBottomNavigationIndex(initialHomePageSubPage!.index);
    //   }
    // });
  }

  changeBottomNavigationIndex(int index) => notify(
        () => state.bottomNavigationCurrentIndex = index,
      );

  @override
  Future<void> dispose() async {
    super.dispose();
  }
}
