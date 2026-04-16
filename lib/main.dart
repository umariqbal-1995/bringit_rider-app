import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'app/routes/app_pages.dart';
import 'app/theme/app_theme.dart';
import 'app/data/providers/storage_provider.dart';
import 'app/data/providers/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));

  // Firebase — replace appId with the Android/iOS app ID from Firebase console
  // for this app (Project Settings → Your apps → Rider App)
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyAG1_4lKUOhSGPdpBNsG_eCf2FAdEDMzZA',
      appId: '1:760074919513:android:REPLACE_WITH_RIDER_ANDROID_APP_ID',
      messagingSenderId: '760074919513',
      projectId: 'bringit-5fc69',
      storageBucket: 'bringit-5fc69.firebasestorage.app',
    ),
  );
  await NotificationService().initialize();

  const forceHome = false;
  final isLoggedIn = forceHome || await StorageProvider().isLoggedIn();
  runApp(BringItRiderApp(isLoggedIn: isLoggedIn));
}

class BringItRiderApp extends StatelessWidget {
  final bool isLoggedIn;
  const BringItRiderApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'BringIt Rider',
      theme: AppTheme.light,
      debugShowCheckedModeBanner: false,
      initialRoute: isLoggedIn ? Routes.HOME : Routes.AUTH,
      getPages: AppPages.routes,
      defaultTransition: Transition.cupertino,
    );
  }
}
