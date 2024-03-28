import 'package:dotcomplypro/screens/policy/privacy_policy.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:upgrader/upgrader.dart';
import 'screens/auth/login.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey =
      'pk_live_51NLq7JKDVKTCqDI7GCmlFNVZO17b4iOL2j2yReOmCACZUbCdRTgmjpgRCkBo4B0mgfa5ayP8HcUFkYUaMt0dM7Cs00JxBdmlbE';
  await Firebase.initializeApp();
  await dotenv.load(fileName: '.env');
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<bool> _getAgreement() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isAgreedToPolicy') ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'DOT ComplyPro',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Color(0x0033d1b8)),
          useMaterial3: true,
        ),
        themeMode: ThemeMode.light,
        home: UpgradeAlert(
          dialogStyle: UpgradeDialogStyle.cupertino,
          child: FutureBuilder<bool>(
            future: _getAgreement(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data == true) {
                  return Login();
                } else {
                  return PrivacyPolicy(
                    flag: false,
                  );
                }
              } else {
                return PrivacyPolicy(
                  flag: false,
                );
              }
            },
          ),
        ));
  }
}
