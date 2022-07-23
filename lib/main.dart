import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:outlook/config.dart';
import 'package:outlook/responsive.dart';
import 'package:outlook/screens/Welcome/home.dart';
import 'package:outlook/screens/Welcome/welcome_screen.dart';
import 'package:outlook/screens/auth/login.dart';
import 'package:outlook/screens/auth/navscreen.dart';
import 'package:outlook/screens/main/main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  Stripe.publishableKey = '$STRIPE_KEY';
  await Stripe.instance.applySettings();

  SharedPreferences preferences = await SharedPreferences.getInstance();
  var email = preferences.getString('email');
  var role = preferences.getString('role');
  runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      '/welcome': (context) => HomePage(),
    },
    debugShowCheckedModeBanner: false,
    theme: ThemeData(),
    home: kIsWeb
        ? HomePage()
        : email == null
            ? HomePage()
            : NavScreen(email: email, role: role),
  ));
}
