import 'dart:async';

import 'package:moonchain_wallet/core/core.dart';
import 'package:mxc_logic/mxc_logic.dart';

class ChatUseCase extends ReactiveUseCase {
  ChatUseCase(
    this._repository,
  );

  final Web3Repository _repository;
  late final ValueStream<DefaultTweets?> defaultTweets = reactive(null);

  Future<String> newConversation(String walletAddress) async {
    return await _repository.chatRepository.newConversation(walletAddress);
  }

  Stream<String> sendMessage(List<AIMessage> messages, String conversationId) {
    return _repository.chatRepository.sendMessage(
      conversationId,
      messages,
      Config.aiAgentName,
    );
  }
}
