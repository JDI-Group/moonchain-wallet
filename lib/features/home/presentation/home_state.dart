import 'package:equatable/equatable.dart';

class HomeState with EquatableMixin {
  int bottomNavigationCurrentIndex = 0;

  @override
  List<Object?> get props => [
        bottomNavigationCurrentIndex,
      ];
}
