import 'package:cloud_firestore/cloud_firestore.dart';

import '../data/Message.dart';
import 'ChatRepository.dart';

class ChatRepositoryImpl extends ChatRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  String getChatId(String userId1, String userId2) {
    final ids = [userId1, userId2]..sort();
    return ids.join('_');
  }

  @override
  Stream<List<Message>> getMessages(String chatId) {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) => Message.fromDoc(doc)).toList());
  }

  @override
  Future<void> sendMessage(String chatId, Message message) async {
    final chatRef = _firestore.collection('chats').doc(chatId);
    final msgRef = chatRef.collection('messages').doc();

    await _firestore.runTransaction((tx) async {
      tx.set(msgRef, {
        'senderId': message.senderId,
        'text': message.text,
        'timestamp': FieldValue.serverTimestamp(),
      });

      tx.set(chatRef, {
        'participants': chatId.split('_'),
        'lastMessage': message.text,
        'lastTimestamp': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    });
  }
}
