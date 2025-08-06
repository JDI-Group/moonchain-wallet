import 'dart:async';

import 'package:moonchain_wallet/core/core.dart';
import 'package:flutter/material.dart';
import 'home_state.dart';


final homePagePageContainer =
    PresenterContainer<HomePagePresenter, HomeState>(
        () => HomePagePresenter());

class HomePagePresenter extends CompletePresenter<HomeState> {
  HomePagePresenter() : super(HomeState());

  late final _bookmarksUseCase = ref.read(bookmarksUseCaseProvider);
  late final _dappStoreUseCase = ref.read(dappStoreUseCaseProvider);
  late final _chainConfigurationUseCase =
      ref.read(chainConfigurationUseCaseProvider);
  late final _gesturesInstructionUseCase =
      ref.read(gesturesInstructionUseCaseProvider);
  late final _accountUseCase = ref.read(accountUseCaseProvider);
  late final _dappsOrderUseCase = ref.read(dappsOrderUseCaseProvider);


  final scrollController = ScrollController();

  int attemptCount = 0;
  double? viewPortWidth;
  double? scrollingArea;

  @override
  void initState() {
    super.initState();


  }


  changeBottomNavigationIndex(index) => notify(
        () => state.bottomNavigationCurrentIndex == index,
      );

  @override
  Future<void> dispose() async {
    super.dispose();
  }
}
