import 'package:delphino_app/providers/aprender.provider.dart';
import 'package:delphino_app/providers/user.provider.dart';
import 'package:delphino_app/theme.notifier.dart';
import 'package:delphino_app/views/auth_screens/login_screen.dart';
import 'package:delphino_app/views/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider<AprenderProvider>(
        create: (_) => AprenderProvider(),
      ),
      ChangeNotifierProvider<UserProvider>(
        create: (_) => UserProvider(),
      ),
    ],
    child: MaterialApp(
        title: 'Delphino App',
        home: LoginPage(),
      ),
    );
  }
}
