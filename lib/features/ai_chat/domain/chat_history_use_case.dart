import 'package:moonchain_wallet/core/core.dart';
import 'package:mxc_logic/mxc_logic.dart';

import './chat_history_repository.dart';

class ChatHistoryUseCase extends ReactiveUseCase {
  ChatHistoryUseCase(
    this._repository,
  ) : super();

  final ChatHistoryRepository _repository;

  late final ValueStream<List<AIMessage>> messages =
      reactiveField(_repository.messages);

  List<AIMessage> getMessages() => _repository.items;

  void addItem(AIMessage item) {
    _repository.addItem(item);
    update(messages, _repository.items);
  }

  void removeItem(AIMessage item) {
    _repository.removeItem(item);
    update(messages, _repository.items);
  }

  void removeAll() {
    _repository.removeAll();
    update(messages, _repository.items);
  }
}
