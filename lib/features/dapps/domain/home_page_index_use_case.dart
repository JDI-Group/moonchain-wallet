import 'package:moonchain_wallet/core/core.dart';
import 'package:moonchain_wallet/features/home/home.dart';
import 'package:mxc_logic/mxc_logic.dart';

import 'dapps_order_repository.dart';

class HomePageIndexUseCase extends ReactiveUseCase {
  HomePageIndexUseCase();

  late final ValueStream<int> index = reactive(0);
  changeBottomNavigationSubPage(HomePageSubPage page) => changeBottomNavigationIndexTo(page.index);

  changeBottomNavigationIndexTo(int newIndex) => update(index, newIndex);
}
