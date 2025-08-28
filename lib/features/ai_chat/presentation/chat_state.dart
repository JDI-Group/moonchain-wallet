import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:mxc_logic/mxc_logic.dart';

class ChatState with EquatableMixin {
  List<AIMessage> messages = [];
  bool isProcessing = false;
  bool isTypeAnimation = false;
  Account? account;
  Network? network;

  @override
  List<Object?> get props => [
    messages,
    isProcessing,
    isTypeAnimation,
    account,
    network,
  ];
}
