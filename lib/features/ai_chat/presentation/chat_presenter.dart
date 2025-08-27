import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:moonchain_wallet/core/core.dart';
import 'package:flutter/material.dart';
import 'package:moonchain_wallet/features/ai_chat/ai_chat.dart';
import 'package:mxc_logic/mxc_logic.dart';
import 'chat_state.dart';

final chatPagePageContainer =
    PresenterContainer<ChatPresenter, ChatState>(() => ChatPresenter());

class ChatPresenter extends CompletePresenter<ChatState> {
  ChatPresenter() : super(ChatState());

  late final _bookmarksUseCase = ref.read(bookmarksUseCaseProvider);
  late final ChatHistoryUseCase _chatHistoryUseCase =
      ref.read(chatHistoryUseCaseProvider);
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

    _chatHistoryUseCase.messages.listen(
      (event) => notify(
        () => state.messages = event,
      ),
    );

    messageFocusNode.addListener(
      () {
        if (messageFocusNode.hasFocus) {
          scrollToBottom();
        }
      },
    );
  }

  void sendMessage() {
    messageFocusNode.unfocus();
    scrollToBottom();
    notify(
      () => state.isProcessing = true,
    );

    try {
      final newMessage = messageTextController.text;
      if (newMessage.isEmpty || newMessage == '') {
        turnIsProcessingOff();
        return;
      }
      _chatHistoryUseCase.addItem(
        AIMessage(
          role: 'user',
          content: newMessage,
        ),
      );
      final messagesStream = _chatUseCase.sendMessage(newMessage);
      messageTextController.text = '';
      String? finalResponse;
      messagesStream.listen(
        (event) {
          turnIsProcessingOff();
          finalResponse = event;
        },
        onDone: () {
          if (finalResponse != null) {
            _chatHistoryUseCase
                .addItem(AIMessage(role: 'ai', content: finalResponse ?? ''));
          }
        },
        onError: (err) => addError(translate(err)),
      );
    } catch (e) {
      turnIsProcessingOff();
      addError(e);
    }
  }

  turnIsProcessingOff() {
    if (state.isProcessing != false) {
      notify(
        () => state.isProcessing = false,
      );
    }
  }

  void scrollToBottom() {
    messageListScrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Future<void> dispose() async {
    super.dispose();
  }
}
