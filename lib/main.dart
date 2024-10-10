import 'package:chat_app/core/routing/routes.dart';
import 'package:chat_app/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:zego_zim/zego_zim.dart';
import 'core/di/dependency_injection.dart';
import 'core/helpers/bloc_observer.dart';
import 'core/routing/app_router.dart';
import 'core/theming/theme.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await ScreenUtil.ensureScreenSize();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Bloc.observer = MyBlocObserver();
  await Hive.initFlutter();
  ZIMAppConfig appConfig = ZIMAppConfig();
  appConfig.appID =-1;//your zego app id
  appConfig.appSign = 'Your_App_Sing';
  ZIM.create(appConfig)!;
  setupGetIt();

  runApp(MyApp(appRouter: AppRouter(),));
}

class MyApp extends StatelessWidget {
  final AppRouter appRouter;
  const MyApp({super.key, required this.appRouter});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      builder:(context, child) =>  MaterialApp(
        title: 'Chat App',
        debugShowCheckedModeBanner: false,
        theme: lightThemeData(context),
        darkTheme: darkThemeData(context),
         initialRoute:FirebaseAuth.instance.currentUser==null?Routes.welcomeScreen:Routes.navigationScreen,
        onGenerateRoute: appRouter.generateRoute,
      ),
    );
  }
}
