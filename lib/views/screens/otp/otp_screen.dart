import 'package:chat_app/views/components/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';

import '../../../controllers/cubit/auth/auth_cubit.dart';
import '../../../helper/constants.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({Key? key,required this.phone,required this.state}) : super(key: key);
  final String phone,state;
  @override
  Widget build(BuildContext context) {
    final cubitContext = ModalRoute.of(context)!.settings.arguments as BuildContext;
    AuthCubit cubit=AuthCubit.get(cubitContext);
    return  BlocProvider.value(value: cubit,
          child: Scaffold(
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
                     Text(phone,style: const TextStyle(fontSize: 24,fontWeight: FontWeight.w300)),
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
                    PrimaryButton(text: 'Done',press:() => cubit.addPhoneUser(context,state)),

                    const Spacer(flex: 3,),
                  ],),
              ),
            ),
          )
      );
  }
}
