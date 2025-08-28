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
  late final _mxcTransactionsUseCase = ref.read(mxcTransactionsUseCaseProvider);
  late final _chainConfigurationUseCase =
      ref.read(chainConfigurationUseCaseProvider);

  final messageListScrollController = ScrollController();
  final messageTextController = TextEditingController();
  // Will be attached to only last message
  final animatedTextController = AnimatedTextController();
  String? conversationId;

  final messageFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    listen(_chainConfigurationUseCase.selectedNetwork, (value) {
      if (value != null) {
        state.network = value;
      }
    });

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
      (val) => state.account = val,
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
        conversationId =
            await _chatUseCase.newConversation(state.account!.address);
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
              AIMessage(role: 'assistant', content: finalResponse ?? ''),
            );
          }
        },
        onError: (err) => addError(translate(err)),
      );
    } catch (e) {
      turnIsProcessingOff();
      addError(e);
    }
  }

  void handlePresetButtons(String command) {
    switch (command) {
      case "pending_swaps":
        handlePendingSwaps();
        break;

      case "iho_mining":
        print("Settings selected");
        break;

      case "view_portfolio":
        print("Logout selected");
        break;

      case "market_overview":
        print("Logout selected");
        break;

      default:
        print("Invalid option");
    }
  }

  void handlePendingSwaps() async {
    if (MXCChains.isMXCChains(state.network!.chainId)) {
      scrollToBottom();
      turnIsProcessingOn();

      try {
        final txList = await _mxcTransactionsUseCase
            .getMXCTransactions(state.account!.address);

        if (txList != null) {
          txList.sublist(txList.length - 6);
        }
      } catch (e) {
        addError(e);
        turnIsProcessingOff();
      }
    }
  }

  void handleIHOMining() async {
    // Need to check If current chain has mining 
    // We can get from previous page which was dapps page 
    if (MXCChains.isMXCChains(state.network!.chainId)) {
      scrollToBottom();
      turnIsProcessingOn();

      try {
        List<TransactionModel>? txList = await _mxcTransactionsUseCase
            .getMXCTransactions(state.account!.address);

        if (txList == null) {
          return;
        }

        if (txList.length > 6) {
          txList = txList.sublist(0, 6);
        }

        for (TransactionModel tx in txList) {
          
        }

      } catch (e) {
        addError(e);
        turnIsProcessingOff();
      }
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
