import 'package:mxc_logic/mxc_logic.dart';
import 'package:moonchain_wallet/core/core.dart';

class ChatHistoryRepository extends GlobalCacheRepository {
  @override
  String get zone => 'chat-history';

  late final Field<List<AIMessage>> messages = fieldWithDefault(
    'chat-history',
    [],
    serializer: (t) => t
        .map((e) => {
              'content': e.content,
              'role': e.role,
              'createdAt': e.createdAt.millisecondsSinceEpoch,
              'uuid': e.uuid,
            })
        .toList(),
    deserializer: (t) => (t as List)
        .map((e) => AIMessage(
              content: e['content'],
              role: e['role'],
              createdAt: DateTime.fromMillisecondsSinceEpoch(e['createdAt']),
              uuid: e['uuid'],
            ))
        .toList(),
  );

  late final Field<String?> conversationId = field(
    'conversationId',
  );

  List<AIMessage> get items => messages.value;

  // We need to insert to index 0
  void addItem(AIMessage item) => messages.value = [item, ...messages.value];

  void removeAll() => messages.value = [];

  void removeItem(AIMessage item) => messages.value =
      messages.value.where((e) => e.uuid != item.uuid).toList();
}
