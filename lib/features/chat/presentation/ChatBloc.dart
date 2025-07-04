import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/ChatEvent.dart';
import '../data/ChatState.dart';
import '../data/Message.dart';
import '../domain/ChatRepository.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository repository;
  Stream<List<Message>>? _messageStream;

  ChatBloc(this.repository) : super(ChatInitial()) {
    on<LoadMessages>((event, emit) async {
      emit(ChatLoading());
      try {
        _messageStream = repository.getMessages(event.chatId);
        await emit.forEach<List<Message>>(
          _messageStream!,
          onData: (messages) => ChatLoaded(messages),
          onError: (_, __) => ChatError('Failed to load messages'),
        );
      } catch (e) {
        emit(ChatError(e.toString()));
      }
    });
    on<GetChatID>((event, emit) async {
      emit(ChatLoading());
      try {
        var data = repository.getChatId(event.current_user,event.other_user);
         emit(ChatIdSucces(data));
      } catch (e) {
        emit(ChatError(e.toString()));
      }
    });

    on<SendMessageEvent>((event, emit) async {
      try {
        final message = Message(
          id: '',
          senderId: event.senderId,
          text: event.text,
          timestamp: DateTime.now(),
        );
        await repository.sendMessage(event.chatId, message);
      } catch (e) {
        emit(ChatError(e.toString()));
      }
    });
  }
}
