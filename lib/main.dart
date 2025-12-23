import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/chat_screen.dart';
import 'services/nearby_service.dart';
import 'services/language_service.dart'; // <--- استدعينا الملف الجديد

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NearbyService()),
        ChangeNotifierProvider(create: (_) => LanguageService()), // <--- ضفنا الخدمة هنا
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // بنراقب تغيير اللغة عشان نغير اتجاه التطبيق كله
    final lang = Provider.of<LanguageService>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Mesh Chat',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // هنا بنحدد اتجاه التطبيق (يمين لشمال أو العكس)
      builder: (context, child) {
        return Directionality(
          textDirection: lang.textDirection,
          child: child!,
        );
      },
      home: ChatScreen(),
    );
  }
}