import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:phone_authentication/phone_number_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.teal,
        colorScheme:
            ColorScheme.fromSwatch().copyWith(secondary: Colors.tealAccent),
      ),
      home: const PhoneNumberAuth(),
      // ),
    );
  }
}
