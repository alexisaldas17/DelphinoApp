import 'package:delphino_app/providers/aprender.provider.dart';
import 'package:delphino_app/providers/user.provider.dart';
import 'package:delphino_app/theme.notifier.dart';
import 'package:delphino_app/views/admin/pages/home_admin.dart';
import 'package:delphino_app/views/auth_screens/authguard.dart';
import 'package:delphino_app/views/auth_screens/loginEstudiante_screen.dart';
import 'package:delphino_app/views/home_screen.dart';
import 'package:delphino_app/views/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fluro/fluro.dart';
import 'package:delphino_app/views/welcome_screen.dart';

import 'controllers/auth_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    AuthControllerProvider(
      child: ChangeNotifierProvider<ThemeNotifier>(
        create: (_) => ThemeNotifier(),
        child: MyApp(),
      ),
    ),
  );
}

// Future initialization(BuildContext? context) async {
//   await Future.delayed(Duration(seconds: 3));
// }

class MyApp extends StatelessWidget {
  //final AuthGuard authGuard = AuthGuard();
  final FluroRouter router = FluroRouter();

  @override
  Widget build(BuildContext context) {
    //configureRoutes();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AprenderProvider>(
          create: (_) => AprenderProvider(),
        ),
        ChangeNotifierProvider<UserProvider>(
          create: (_) => UserProvider(),
        ),
      ],
      child: MaterialApp(
        theme: ThemeData(fontFamily: 'NunitoSans_7pt'),
        // theme: ThemeData(
        //   useMaterial3 = true,
        // ),
        title: 'Delphino App',
        home: HomeAdministrador(),
        routes: {
         // '/': (context) => AuthGuard(child: WelcomePage()),
          '/home': (context) => AuthGuard(child: HomePage())
        },
        initialRoute: '/',
      ),
    );
  }
}
