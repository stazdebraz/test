import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_app/features/web_view/ui/screens/app_web_view.dart';
import 'package:test_app/core/services/service_locator.dart' as di;
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await di.init();
  final prefs = await SharedPreferences.getInstance();
  runApp(MyApp(
    link: prefs.getString('link') ?? '',
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.link});
  final String link;

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AppWebView(),
    );
  }
}
