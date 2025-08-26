import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/rendering.dart';
import 'package:moonchain_wallet/core/core.dart';
import 'package:flutter/material.dart';
import 'package:mxc_logic/mxc_logic.dart';
import 'chat_state.dart';

final chatPagePageContainer =
    PresenterContainer<ChatPresenter, ChatState>(() => ChatPresenter());

class ChatPresenter extends CompletePresenter<ChatState> {
  ChatPresenter() : super(ChatState());

  late final _bookmarksUseCase = ref.read(bookmarksUseCaseProvider);
  late final _chatUseCase = ref.read(chatUseCaseProvider);
  final messageListScrollController = ScrollController();
  final messageTextController = TextEditingController();
  // Will be attached to only last message
  final animatedTextController = AnimatedTextController();
  bool _isUserScrolling = false;

  final messageFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    animatedTextController.stateNotifier.addListener(
      () {
        if (animatedTextController.state == AnimatedTextState.playing) {
          scrollToBottom();
        }
      },
    );

    messageListScrollController.addListener(() {
      if (messageListScrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        // user scrolling up
        _isUserScrolling = true;
      } else if (messageListScrollController.position.pixels >=
          messageListScrollController.position.maxScrollExtent - 20) {
        // near the bottom again
        _isUserScrolling = false;
      }
    });
    // messageFocusNode.requestFocus();
  }

  void sendMessage() {
    messageFocusNode.unfocus();
    notify(
      () => state.isProcessing = true,
    );

    final newMessage = messageTextController.text;
    state.messages.add(AIMessage(role: 'user', content: newMessage));
    final messagesStream = _chatUseCase.sendMessage(newMessage);
    String? finalResponse;
    messagesStream.listen(
      (event) {
        if (state.isProcessing != false) {
          notify(
            () => state.isProcessing = false,
          );
        }
        finalResponse = event;
      },
      onDone: () {
        notify(
          () =>
              state.messages.add(AIMessage(role: 'ai', content: finalResponse)),
        );
      },
      onError: (err) => addError(translate(err)),
    );

    messageListScrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );

    messageTextController.text = '';
  }

  void scrollToBottom() {
    if (!_isUserScrolling) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (messageListScrollController.hasClients) {
          messageListScrollController.animateTo(
            messageListScrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  @override
  Future<void> dispose() async {
    super.dispose();
  }
}
