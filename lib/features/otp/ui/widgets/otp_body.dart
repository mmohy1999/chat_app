import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';

import '../../../../core/theming/theming_const.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../logic/otp_cubit.dart';

class OtpBody extends StatelessWidget {
  const OtpBody({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit=context.read<OtpCubit>();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
          child: Column(
            children: [
              const Spacer(flex: 3,),
              Image.asset(
                MediaQuery.of(context).platformBrightness == Brightness.light
                    ? "assets/images/Logo_light.png"
                    : "assets/images/Logo_dark.png",
                height: 146,
              ),
              const Spacer(flex: 2,),
              const Text('Verification',style: TextStyle(fontSize: 32,fontWeight: FontWeight.bold)),
              const SizedBox(height: 16,),
              const Text('SMS Verification code will been send.',style: TextStyle(color: Colors.grey)),
              const Spacer(),
              Text(cubit.otpModel.phone,style: const TextStyle(fontSize: 24,fontWeight: FontWeight.w300)),
              const Spacer(flex: 2,),
              OTPTextField(
                length: 6,
                otpFieldStyle: OtpFieldStyle(enabledBorderColor: Colors.grey,focusBorderColor: primaryColor) ,
                width: MediaQuery.of(context).size.width,
                contentPadding:const EdgeInsets.all(8) ,
                style: const TextStyle(
                  fontSize: 17,
                ),
                textFieldAlignment: MainAxisAlignment.spaceAround,
                fieldStyle: FieldStyle.underline,
                onCompleted: (pin) {
                  cubit.otp=pin;
                },
              ),
              const Spacer(),
              PrimaryButton(text: 'Done',press:() => cubit.addPhoneUser()),

              const Spacer(flex: 3,),
            ],),
        ),
      ),
    );
  }
}
