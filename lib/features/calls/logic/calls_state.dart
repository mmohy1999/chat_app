import 'package:freezed_annotation/freezed_annotation.dart';

part 'calls_state.freezed.dart';

@freezed
class CallsState<T> with _$CallsState<T> {
  const factory CallsState.initial() = _Initial;
  const factory CallsState.loading()=Loading;
  const factory CallsState.success(T data)=Success;
  const factory CallsState.error({required String error})=Error;
}
