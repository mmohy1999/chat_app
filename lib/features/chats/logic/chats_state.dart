import 'package:freezed_annotation/freezed_annotation.dart';

import '../data/chat.dart';
part 'chats_state.freezed.dart';
@freezed
class ChatsState<T> with _$ChatsState<T> {
  const factory ChatsState.initial() = _Initial;
  const factory ChatsState.loading()=Loading;
  const factory ChatsState.success(List<Chat> data)=Success;
  const factory ChatsState.error({required String error})=Error;
  const factory ChatsState.loadingAddChat()=LoadingChat;
  const factory ChatsState.successAddChat()=SuccessChat;


}
