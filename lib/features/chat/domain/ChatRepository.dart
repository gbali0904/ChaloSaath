import '../data/Message.dart';

abstract class ChatRepository {
  String getChatId(String userId1, String userId2);
  Stream<List<Message>> getMessages(String chatId);
  Future<void> sendMessage(String chatId, Message message);
}
