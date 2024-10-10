import 'package:chat_app/features/chat_messages/logic/messages_cubit.dart';
import 'package:chat_app/features/chats/logic/chats_cubit.dart';
import 'package:chat_app/features/forget_password/logic/forget_password_cubit.dart';
import 'package:chat_app/features/otp/logic/otp_cubit.dart';
import 'package:chat_app/features/people/logic/people_cubit.dart';
import 'package:chat_app/features/profile/logic/profile_cubit.dart';
import 'package:get_it/get_it.dart';

import '../../features/login/logic/login_cubit.dart';
import '../../features/sign_up/logic/signup_cubit.dart';

final getIt=GetIt.instance;
Future<void> setupGetIt() async{

  // login
  getIt.registerFactory<LoginCubit>(() => LoginCubit());
  // forget password
  getIt.registerFactory<ForgetPasswordCubit>(() => ForgetPasswordCubit());
  // signup
  getIt.registerFactory<SignupCubit>(() => SignupCubit());
  // otp
  getIt.registerFactory<OtpCubit>(() => OtpCubit());
  //
  // chats
  getIt.registerFactory<ChatsCubit>(() => ChatsCubit());

  // people
  getIt.registerFactory<PeopleCubit>(() => PeopleCubit());

  // profile
  getIt.registerFactory<ProfileCubit>(() => ProfileCubit());
  // messages
  getIt.registerFactory<MessagesCubit>(() => MessagesCubit());
}