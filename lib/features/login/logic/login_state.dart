import 'package:freezed_annotation/freezed_annotation.dart';
part 'login_state.freezed.dart';

@freezed
sealed class LoginState<T> with _$LoginState<T> {
  const factory LoginState.initial()=_Ininitial;
  const factory LoginState.loading()=Loading;
  const factory LoginState.success(T data)=Success;
  const factory LoginState.error({required String error})=Error;
}

