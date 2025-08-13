import 'dart:async';

import 'package:moonchain_wallet/core/core.dart';
import 'package:moonchain_wallet/features/dapps/dapps.dart';
import 'package:moonchain_wallet/features/dapps/helpers/book_marks_helper.dart';
import 'package:moonchain_wallet/features/dapps/helpers/helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mxc_logic/mxc_logic.dart';
import 'chat_state.dart';

final chatPagePageContainer =
    PresenterContainer<ChatPresenter, ChatState>(() => ChatPresenter());

class ChatPresenter extends CompletePresenter<ChatState> {
  ChatPresenter() : super(ChatState());

  late final _bookmarksUseCase = ref.read(bookmarksUseCaseProvider);
  final messageTextController = TextEditingController();
  final messageFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    messageFocusNode.requestFocus();
  }

  @override
  Future<void> dispose() async {
    super.dispose();
  }
}
