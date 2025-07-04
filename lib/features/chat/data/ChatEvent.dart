
class ChatEvent {}

class LoadMessages extends ChatEvent {
  final String chatId;
  LoadMessages(this.chatId);

  @override
  List<Object?> get props => [chatId];
}
class GetChatID extends ChatEvent {
  final String current_user;
  final String other_user;
  GetChatID(this.current_user ,this.other_user);
}

class SendMessageEvent extends ChatEvent {
  final String chatId;
  final String senderId;
  final String text;

  SendMessageEvent(this.chatId, this.senderId, this.text);

  @override
  List<Object?> get props => [chatId, senderId, text];
}
