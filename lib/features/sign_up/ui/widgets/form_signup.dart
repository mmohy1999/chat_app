import 'package:chat_app/core/helpers/spacing.dart';
import 'package:chat_app/features/sign_up/logic/signup_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/primary_button.dart';

class FormSignup extends StatelessWidget {
  const FormSignup({super.key});


  @override
  Widget build(BuildContext context) {
    final SignupCubit cubit=context.read<SignupCubit>();
    return Form(
        key: cubit.formKey,
        child:Column(
          children: [
            TextFormField(
              keyboardType: TextInputType.name,
              validator: cubit.nameValidator,
              controller: cubit.nameController,
              decoration: const InputDecoration(hintText: 'Full Name'),
            ),
            verticalSpace(20),
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
              decoration: const InputDecoration(hintText: 'password'),
            ),
            verticalSpace(20),
            TextFormField(
              keyboardType: TextInputType.phone,
              validator: cubit.phoneValidator,
              controller: cubit.phoneController,
              decoration: const InputDecoration(hintText: 'Phone'),
            ),

            verticalSpace(20),
            PrimaryButton(
              text: "Sign Up",
              press: () => cubit.validateThenDoSignup(),
            ),
          ],
        )
    );
  }
}
