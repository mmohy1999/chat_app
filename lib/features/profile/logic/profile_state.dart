import 'dart:io';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_state.freezed.dart';

@freezed
class ProfileState<T> with _$ProfileState<T> {
  const factory ProfileState.initial() = _Initial;
  const factory ProfileState.loading()=Loading;
  const factory ProfileState.success(T data)=Success;
  const factory ProfileState.error({required String error})=Error;
  const factory ProfileState.loadingProfilePic()=LoadingProfilePic;
  const factory ProfileState.successProfilePic(File data)=SuccessProfilePic;
  const factory ProfileState.errorProfilePic({required String error})=ErrorProfilePic;
}
