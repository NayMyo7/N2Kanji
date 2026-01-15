import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'src/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await MobileAds.instance.initialize();
  } catch (e) {
    debugPrint('AdMob initialization failed: $e');
  }

  runApp(const ProviderScope(child: MyApp()));
}
