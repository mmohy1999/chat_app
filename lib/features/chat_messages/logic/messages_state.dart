
import 'package:freezed_annotation/freezed_annotation.dart';

import '../data/chat_message.dart';
part 'messages_state.freezed.dart';
@freezed
class MessagesState<T> with _$MessagesState<T> {
  const factory MessagesState.initial() = _Initial;
  const factory MessagesState.loading()=Loading;
  const factory MessagesState.addMessage(ChatMessage data)=AddMessage;
  const factory MessagesState.success(T data)=Success;
  const factory MessagesState.error({required String error})=Error;
}
