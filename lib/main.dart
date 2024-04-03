import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:footballer/screens/home/home.dart';
import 'package:footballer/screens/login.dart';
import 'package:footballer/screens/signup.dart';
import 'package:footballer/screens/tutorial_screen.dart';
import 'package:footballer/testFile.dart';

import 'languages.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FlutterLocalization _localization = FlutterLocalization.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    _localization.init(
      mapLocales: [
        const MapLocale('en', AppLocale.EN),
        const MapLocale('so', AppLocale.SO),
      ],
      initLanguageCode: 'en',
    );
    _localization.onTranslatedLanguage = _onTranslatedLanguage;
    super.initState();
  }

  void _onTranslatedLanguage(Locale locale) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      supportedLocales: _localization.supportedLocales,
      localizationsDelegates: _localization.localizationsDelegates,
      title: 'Footballer',
      theme: ThemeData(primarySwatch: Colors.blue, fontFamily: "ComicSans"),
      debugShowCheckedModeBanner: false,
      home: _auth.currentUser != null ? Home(): TutorialScreen(),
      // home: LoginScreen(),
      // initialRoute: TutorialScreen.route,
      routes: {
        TutorialScreen.route: (_) => const TutorialScreen(),
        LoginScreen.route: (_) => const LoginScreen(),
        Home.route: (_) => const Home(),
      },
    );
  }
}
