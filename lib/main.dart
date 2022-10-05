import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'app_widget.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyAH9ggxvRR0CbfNYFJUmw7Sh4qUZniZnqA",
          appId: "1:958457414591:web:d2b88697cc6f97ee97d70a",
          messagingSenderId: "958457414591",
          projectId: "psico-sys")
  );

  runApp(AppWidget());

}
