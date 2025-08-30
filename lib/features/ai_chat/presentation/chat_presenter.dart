import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:collection/collection.dart';
import 'package:moonchain_wallet/core/core.dart';
import 'package:flutter/material.dart';
import 'package:moonchain_wallet/core/src/extensions.dart';
import 'package:moonchain_wallet/features/ai_chat/ai_chat.dart';
import 'package:mxc_logic/mxc_logic.dart';
import '../../dapps/presentation/responsive_layout/dapp_utils.dart';
import 'chat_state.dart';


final chatPagePageContainer =
    PresenterContainer<ChatPresenter, ChatState>(
        () => ChatPresenter());

class ChatPresenter extends CompletePresenter<ChatState> {
  ChatPresenter() : super(ChatState());

  late final ChatHistoryUseCase _chatHistoryUseCase =
      ref.read(chatHistoryUseCaseProvider);
  late final _chatUseCase = ref.read(chatUseCaseProvider);
  late final _accountUseCase = ref.read(accountUseCaseProvider);
  late final _mxcTransactionsUseCase = ref.read(mxcTransactionsUseCaseProvider);
  late final _chainConfigurationUseCase =
      ref.read(chainConfigurationUseCaseProvider);
  late final _launcherUseCase = ref.read(launcherUseCaseProvider);
  late final _dappStoreUseCase = ref.read(dappStoreUseCaseProvider);
  late final _tokenContractUseCase = ref.read(tokenContractUseCaseProvider);

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

      // turnIsProcessingOff();
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
        onError: (err) {
          turnIsProcessingOff();
          addError(translate(err));
        },
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

      case "iho":
        handleIHOMining();
        break;

      case "view_portfolio":
        handleViewPortfolio();
        break;

      case "market_overview":
        print("Logout selected");
        break;

      default:
        print("Invalid option");
    }
  }

  void handleViewPortfolio() async {
    // Need to check If current chain has mining
    // We can get from previous page which was dapps page
    if (MXCChains.isMXCChains(state.network!.chainId)) {
      scrollToBottom();
      turnIsProcessingOn();

      try {
        final buffer = StringBuffer();

        buffer.writeln('## 📊 Your Portfolio\n');
        buffer.writeln('| Token | Amount |');
        buffer.writeln('|--------|--------|');

        final tokens = _tokenContractUseCase.tokensList.value;

        print(tokens);

        if (tokens.isEmpty) {
          return;
        }

        for (Token e in tokens) {
          final logoUri = e.logoUri ?? 'assets/svg/networks/unknown.svg';
          final symbol = e.symbol ?? 'UNKNOWN';
          final balance = e.balance?.toString() ?? 'N/A';

          buffer.writeln(
              "| ![$symbol]($logoUri) $symbol  | $balance |");
        }

        final response = buffer.toString();
        turnIsProcessingOff();
        final newMessage = AIMessage(
          role: 'assistant',
          content: response,
        );
        _chatHistoryUseCase.addItem(newMessage);
      } catch (e) {
        addError(e);
        turnIsProcessingOff();
      }
    }
  }  

  void handleIHOMining() async {
    if (MXCChains.isMXCChains(state.network!.chainId)) {
      scrollToBottom();
      turnIsProcessingOn();

      try {
        final newMessageText = translate('what_is_iho')!;

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

        // turnIsProcessingOff();
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
              final ihoDApp = getIHODapp();
              if (ihoDApp != null) {
                StringBuffer buffer = StringBuffer(finalResponse!);
                buffer.writeln();
                buffer.writeln("[IHO mining](${ihoDApp.app?.url})");
                finalResponse = buffer.toString();
              }

              _chatHistoryUseCase.addItem(
                AIMessage(role: 'assistant', content: finalResponse ?? ''),
              );
            }
          },
          onError: (err) {
            turnIsProcessingOff();
            addError(translate(err));
          },
        );
      } catch (e) {
        addError(e);
        turnIsProcessingOff();
      }
    }
  }

  void handlePendingSwaps() async {
    // Need to check If current chain has mining
    // We can get from previous page which was dapps page
    if (MXCChains.isMXCChains(state.network!.chainId)) {
      scrollToBottom();
      turnIsProcessingOn();

      try {
        final buffer = StringBuffer();

        buffer.writeln('## 🔗 Transactions\n');
        buffer.writeln('| Status | Amount | Token | Date | Tx Hash |');
        buffer.writeln('|--------|--------|-------|------|---------|');

        List<TransactionModel>? txList = await _mxcTransactionsUseCase
            .getMXCTransactions(state.account!.address);

        if (txList == null) {
          return;
        }

        if (txList.length > 6) {
          txList = txList.sublist(0, 6);
        }

        for (TransactionModel e in txList) {
          // final foundToken = tokensList.firstWhere(
          //     (element) =>
          //         element.address?.toLowerCase() ==
          //         e.token.address?.toLowerCase(),
          //     orElse: () => const Token());
          // final logoUrl = foundToken.logoUri ??
          //     e.token.logoUri ??
          //     'assets/svg/networks/unknown.svg';
          final decimal = e.token.decimals ?? Config.ethDecimals;
          final symbol = e.token.symbol ?? 'UNKNOWN';
          final amount = e.value == null
              ? null
              : MXCFormatter.convertWeiToEth(e.value!, decimal);
          final timeStamp = e.timeStamp == null
              ? "Unknown"
              : MXCFormatter.localTime(e.timeStamp!);
          final formattedHash = MXCFormatter.formatWalletAddress(
            e.hash,
          );

          buffer.writeln(
              "| ${e.status.icon} (${e.type.name.capitalizeFirstLetter()}) | $amount | $symbol | $timeStamp | [$formattedHash](${getTransactionExplorerUrl(e.hash).toString()}) |");
        }

        final response = buffer.toString();
        turnIsProcessingOff();
        final newMessage = AIMessage(
          role: 'assistant',
          content: response,
        );
        _chatHistoryUseCase.addItem(newMessage);
      } catch (e) {
        addError(e);
        turnIsProcessingOff();
      }
    }
  }

  Dapp? getIHODapp() {
    final dapps = _dappStoreUseCase.dapps.value;

    final chainDapps = getChainDapps(dapps);

    final dapp = chainDapps
      .firstWhereOrNull((e) => e.app?.providerType == ProviderType.native && e.app?.name == "IHO");
  
    return dapp;

  }

  List<Dapp> getChainDapps(List<Dapp> allDapps) {
    List<Dapp> chainDapps = DappUtils.getDappsByChainId(
      allDapps: allDapps,
      chainId: state.network!.chainId,
    );
    return chainDapps;
  }

  void launchUrl(String href) {
    try {
      _launcherUseCase.launchUrlInExternalApp(Uri.parse(href));
    } catch (e) {
      addError(e);
    }
  }

  void removeAllMessages() {
    _chatHistoryUseCase.removeAll();
  }

  Uri getIHOMiningUrl(String txHash) {
    return _launcherUseCase.getTxExplorerUrl(txHash);
  }

  Uri getTransactionExplorerUrl(String txHash) {
    return _launcherUseCase.getTxExplorerUrl(txHash);
  }

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
