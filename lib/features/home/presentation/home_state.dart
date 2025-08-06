import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:mxc_logic/mxc_logic.dart';

class HomeState with EquatableMixin {
  int bottomNavigationCurrentIndex = 0;

  @override
  List<Object?> get props => [
        bottomNavigationCurrentIndex,
      ];
}
