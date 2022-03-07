import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:leg_barkr_app/view/home.dart';
import 'package:flutter/services.dart';
import 'package:leg_barkr_app/view/auth/login_form.dart';
import 'package:leg_barkr_app/view/auth/register_form.dart';
import 'firebase_options.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.black12));
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(Main());
}

class Main extends StatelessWidget {
  const Main({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData.light(),
        //home: HomeScreen(),
        initialRoute: '/',
        routes: {
          '/': (context) => const HomeScreen(),
          '/login': (context) => const LoginForm(),
          '/register': (context) => const RegisterForm()
        }
    );
  }
}

