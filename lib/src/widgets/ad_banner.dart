import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdBanner extends StatefulWidget {
  const AdBanner({super.key, this.useSafeArea = true});

  final bool useSafeArea;

  @override
  State<AdBanner> createState() => _AdBannerState();
}

class _AdBannerState extends State<AdBanner> {
  BannerAd? _bannerAd;
  bool _bannerLoaded = false;

  static const String _releaseBannerUnitIdAndroid =
      'ca-app-pub-8308156736791023/8516180965';
  static const String _releaseBannerUnitIdIos =
      'ca-app-pub-8308156736791023/2965073017';

  static const String _testBannerUnitIdAndroid =
      'ca-app-pub-3940256099942544/6300978111';
  static const String _testBannerUnitIdIos =
      'ca-app-pub-3940256099942544/2934735716';

  @override
  void initState() {
    super.initState();

    final releaseUnitId = switch (defaultTargetPlatform) {
      TargetPlatform.android => _releaseBannerUnitIdAndroid,
      TargetPlatform.iOS => _releaseBannerUnitIdIos,
      _ => _releaseBannerUnitIdAndroid,
    };

    final testUnitId = switch (defaultTargetPlatform) {
      TargetPlatform.android => _testBannerUnitIdAndroid,
      TargetPlatform.iOS => _testBannerUnitIdIos,
      _ => _testBannerUnitIdAndroid,
    };

    final adUnitId = kReleaseMode ? releaseUnitId : testUnitId;
    debugPrint(
        'AdBanner: Initializing with adUnitId: $adUnitId (releaseMode: $kReleaseMode)');

    _bannerAd = BannerAd(
      adUnitId: adUnitId,
      size: AdSize.banner, // Use standard banner (320x50) for minimal size
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          if (!mounted) return;
          setState(() => _bannerLoaded = true);
          debugPrint('AdBanner: Ad loaded successfully');
        },
        onAdFailedToLoad: (ad, error) {
          debugPrint('AdMob banner failed to load: $error');
          debugPrint(
              'AdBanner: Error code: ${error.code}, message: ${error.message}');
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
    if (_bannerAd == null) {
      debugPrint('AdBanner: Banner ad is null');
      return const SizedBox.shrink();
    }
    if (!_bannerLoaded) {
      debugPrint('AdBanner: Banner not loaded yet');
      return const SizedBox.shrink();
    }

    debugPrint('AdBanner: Displaying banner ad');

    final adWidget = SizedBox(
      width: _bannerAd!.size.width.toDouble(),
      height: _bannerAd!.size.height.toDouble(),
      child: AdWidget(ad: _bannerAd!),
    );

    return widget.useSafeArea
        ? SafeArea(top: false, child: adWidget)
        : adWidget;
  }
}
