import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'src/app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize MobileAds asynchronously without blocking app startup
  MobileAds.instance.initialize();

  runApp(const ProviderScope(child: MyApp()));
}
