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

  late final ChatHistoryUseCase _chatHistoryUseCase =
      ref.read(chatHistoryUseCaseProvider);
  late final _chatUseCase = ref.read(chatUseCaseProvider);
  late final _accountUseCase = ref.read(accountUseCaseProvider);

  final messageListScrollController = ScrollController();
  final messageTextController = TextEditingController();
  // Will be attached to only last message
  final animatedTextController = AnimatedTextController();
  String? conversationId;
  Account? account;

  final messageFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    _chatHistoryUseCase.messages.listen(
      (val) => notify(
        () => state.messages = val,
      ),
    );

    _chatHistoryUseCase.conversationId.listen(
      (val) => notify(
        () => conversationId = val,
      ),
    );

    _accountUseCase.account.listen(
      (val) => account = val,
    );

    messageFocusNode.addListener(
      () {
        if (messageFocusNode.hasFocus) {
          scrollToBottom();
        }
      },
    );
  }

  void sendMessage() async {
    messageFocusNode.unfocus();
    scrollToBottom();
    turnIsProcessingOn();

    try {
      final newMessageText = messageTextController.text;
      if (newMessageText.isEmpty || newMessageText == '') {
        turnIsProcessingOff();
        return;
      }

      if (conversationId == null) {
        conversationId = await _chatUseCase.newConversation(account!.address);
        _chatHistoryUseCase.setConversationId(conversationId!);
      }

      final newMessage = AIMessage(
        role: 'user',
        content: newMessageText,
      );
      _chatHistoryUseCase.addItem(newMessage);

      final messagesStream =
          _chatUseCase.sendMessage([newMessage], conversationId!);
      messageTextController.text = '';
      String? finalResponse;
      messagesStream.listen(
        (event) {
          turnIsProcessingOff();
          finalResponse = event;
        },
        onDone: () {
          if (finalResponse != null) {
            _chatHistoryUseCase.addItem(
                AIMessage(role: 'assistant', content: finalResponse ?? ''));
          }
        },
        onError: (err) => addError(translate(err)),
      );
    } catch (e) {
      turnIsProcessingOff();
      addError(e);
    }
  }

  void removeAllMessages() {}

  turnIsProcessingOff() {
    if (state.isProcessing != false) {
      notify(
        () => state.isProcessing = false,
      );
    }
  }

  turnIsProcessingOn() {
    state.isTypeAnimation = true;
    notify(
      () => state.isProcessing = true,
    );
  }

  void scrollToBottom() {
    if (messageListScrollController.hasClients) {
      messageListScrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Future<void> dispose() async {
    super.dispose();
  }
}
