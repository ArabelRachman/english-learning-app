import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import './screens/login_screen.dart';
import './screens/main_app_screen.dart';
import './screens/game_screen.dart';
import './screens/journal_screen.dart';
import './screens/settings_screen.dart';
import './screens/timer_screen.dart';
import './screens/sign_up_screen.dart';
import './screens/forgot_password_screen.dart';
import 'firebase_options.dart';

bool loggedIn = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: LoginScreen.routeName,
      routes: {
        LoginScreen.routeName: (BuildContext context) => LoginScreen(),
        MainAppScreen.routeName: (BuildContext context) => MainAppScreen(),
        GameScreen.routeName: (BuildContext context) => GameScreen(),
        JournalScreen.routeName: (BuildContext context) => JournalScreen(),
        SettingsScreen.routeName: (BuildContext context) => SettingsScreen(),
        TimerScreen.routeName: (BuildContext context) => TimerScreen(),
        SignupScreen.routeName: (BuildContext context) => SignupScreen(),
        ForgotPasswordScreen.routeName: (BuildContext context) => ForgotPasswordScreen()
      },
    );
  }
}
