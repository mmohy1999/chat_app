import 'package:chat_app/core/di/dependency_injection.dart';
import 'package:chat_app/features/chat_messages/logic/messages_cubit.dart';
import 'package:chat_app/features/chat_messages/ui/messages_screen.dart';
import 'package:chat_app/features/forget_password/logic/forget_password_cubit.dart';
import 'package:chat_app/features/forget_password/ui/forget_password_screen.dart';
import 'package:chat_app/features/login/logic/login_cubit.dart';
import 'package:chat_app/features/login/ui/login_screen.dart';
import 'package:chat_app/features/otp/logic/otp_cubit.dart';
import 'package:chat_app/features/otp/ui/otp_screen.dart';
import 'package:chat_app/features/sign_in_or_sign_up/sign_in_or_sign_up_screen.dart';
import 'package:chat_app/features/sign_up/logic/signup_cubit.dart';
import 'package:chat_app/features/sign_up/ui/sign_up_screen.dart';
import 'package:chat_app/features/welcome/welcome_screen.dart';
import 'package:chat_app/features/layout/bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'routes.dart';

class AppRouter {
  Route? generateRoute(RouteSettings settings) {

    switch (settings.name) {
      case Routes.welcomeScreen:
        return MaterialPageRoute(builder: (_) => const WelcomeScreen(),);
      case Routes.signInOrSignupScreen:
        return MaterialPageRoute(builder: (_) => const LoginOrSignupScreen(),);
      case Routes.loginScreen:
        return MaterialPageRoute(builder: (context) =>
            BlocProvider(
              create: (context) => getIt<LoginCubit>(),
              child: const LoginScreen(),
            ),);
      case Routes.forgetScreen:
        return MaterialPageRoute(builder: (context) =>
            BlocProvider(
              create: (context) => getIt<ForgetPasswordCubit>(),
              child: const ForgetPasswordScreen(),
            ),);
      case Routes.signUpScreen:
        return MaterialPageRoute(builder: (context) =>
            BlocProvider(
              create: (context) => getIt<SignupCubit>(),
              child: const SignUpScreen(),
            ),);
      case Routes.otpScreen:
        return MaterialPageRoute(builder: (context) =>
            BlocProvider(
              create: (context) => getIt<OtpCubit>(),
              child: const OtpScreen(),
            ),);
      case Routes.navigationScreen:
        return MaterialPageRoute(
          builder: (_) => const BottomNavigationLayout(),);

      case Routes.messagesScreen:
        return MaterialPageRoute(builder: (context) =>
            BlocProvider(
              create: (context) => getIt<MessagesCubit>(),
              child: const MessagesScreen(),
            ),);

      default:
        return MaterialPageRoute(
            builder: (_) =>
                Scaffold(
                  body: Center(
                    child: Text('No route defined for ${settings.name}'),
                  ),
                )
        );
    }
  }
}