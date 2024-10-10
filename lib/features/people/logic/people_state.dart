import 'package:freezed_annotation/freezed_annotation.dart';
import '../data/contact.dart';
part 'people_state.freezed.dart';
@freezed
class PeopleState<T> with _$PeopleState<T> {
  const factory PeopleState.initial() = _Initial;
  const factory PeopleState.loading()=Loading;
  const factory PeopleState.success(List<ContactModel> data)=Success;
  const factory PeopleState.error({required String error})=Error;
}
