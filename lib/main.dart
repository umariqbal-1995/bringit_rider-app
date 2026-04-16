import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'app/routes/app_pages.dart';
import 'app/theme/app_theme.dart';
import 'app/data/providers/storage_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));
  const _forceHome = false;
  final isLoggedIn = _forceHome || await StorageProvider().isLoggedIn();
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
