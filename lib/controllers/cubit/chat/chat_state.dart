part of 'chat_cubit.dart';

@immutable
abstract class ChatState {}

class ChatInitial extends ChatState {}
class ChangeButton extends ChatState {}
class LoadingState extends ChatState {}
class GetData extends ChatState {}

