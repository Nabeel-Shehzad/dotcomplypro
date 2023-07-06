import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'screens/auth/login.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message)async {
  await Firebase.initializeApp();
}

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = 'pk_live_51NLq7JKDVKTCqDI7GCmlFNVZO17b4iOL2j2yReOmCACZUbCdRTgmjpgRCkBo4B0mgfa5ayP8HcUFkYUaMt0dM7Cs00JxBdmlbE';
  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DOT ComplyPro',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0x33d1b8)),
        useMaterial3: true,
      ),
      themeMode: ThemeMode.light,
      home: Login(),
    );
  }
}
