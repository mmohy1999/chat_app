import 'package:chat_app/core/helpers/spacing.dart';
import 'package:chat_app/features/login/logic/login_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/primary_button.dart';

class FormLogin extends StatefulWidget {
  const FormLogin({super.key});

  @override
  State<FormLogin> createState() => _FormLoginState();
}

class _FormLoginState extends State<FormLogin> {
  late LoginCubit cubit;
  @override
  void initState() {
    cubit=context.read<LoginCubit>();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Form(
      key: cubit.formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
       children: [
              TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  validator: cubit.emailValidator,
                  controller: cubit.emailController,
                  decoration: const InputDecoration(hintText: 'Email')
              ),
              verticalSpace(20),
              TextFormField(
                keyboardType: TextInputType.visiblePassword,
                validator: cubit.passwordValidator,
                controller: cubit.passwordController,
                obscureText: true,
                focusNode: cubit.passwordFocusNode,
                decoration: const InputDecoration(hintText: 'password'),
              ),
             verticalSpace(20),
              PrimaryButton(
                text: "Sign In",
                press: () => cubit.validateThenDoLogin(),
              ),
       ],
      ),
    );
  }
}
