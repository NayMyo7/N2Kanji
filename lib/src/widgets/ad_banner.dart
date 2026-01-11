import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdBanner extends StatefulWidget {
  const AdBanner({super.key});

  @override
  State<AdBanner> createState() => _AdBannerState();
}

class _AdBannerState extends State<AdBanner> {
  BannerAd? _bannerAd;
  bool _bannerLoaded = false;

  static const String _releaseBannerUnitId =
      'ca-app-pub-8308156736791023/8516180965';

  static const String _testBannerUnitIdAndroid =
      'ca-app-pub-3940256099942544/6300978111';
  static const String _testBannerUnitIdIos =
      'ca-app-pub-3940256099942544/2934735716';

  @override
  void initState() {
    super.initState();

    if (kIsWeb) return;

    final testUnitId = switch (defaultTargetPlatform) {
      TargetPlatform.android => _testBannerUnitIdAndroid,
      TargetPlatform.iOS => _testBannerUnitIdIos,
      _ => _testBannerUnitIdAndroid,
    };

    final adUnitId = kReleaseMode ? _releaseBannerUnitId : testUnitId;

    _bannerAd = BannerAd(
      adUnitId: adUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          if (!mounted) return;
          setState(() => _bannerLoaded = true);
        },
        onAdFailedToLoad: (ad, error) {
          debugPrint('AdMob banner failed to load: $error');
          ad.dispose();
          if (!mounted) return;
          setState(() {
            _bannerAd = null;
            _bannerLoaded = false;
          });
        },
      ),
    )..load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) return const SizedBox.shrink();
    if (_bannerAd == null || !_bannerLoaded) return const SizedBox.shrink();

    return SafeArea(
      top: false,
      child: SizedBox(
        width: _bannerAd!.size.width.toDouble(),
        height: _bannerAd!.size.height.toDouble(),
        child: AdWidget(ad: _bannerAd!),
      ),
    );
  }
}
