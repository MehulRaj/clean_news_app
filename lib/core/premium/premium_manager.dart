import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PremiumManager {
  final SharedPreferences _prefs;
  static const String _premiumKey = 'is_premium_user';
  InterstitialAd? _interstitialAd;
  BannerAd? _bannerAd;

  PremiumManager(this._prefs);

  bool get isPremium => _prefs.getBool(_premiumKey) ?? false;

  Future<void> setPremiumStatus(bool isPremium) async {
    await _prefs.setBool(_premiumKey, isPremium);
  }

  Future<void> loadInterstitialAd() async {
    if (isPremium) return;

    await InterstitialAd.load(
      adUnitId: 'your_ad_unit_id_here', // Replace with actual ad unit ID
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
        },
        onAdFailedToLoad: (error) {
          _interstitialAd = null;
        },
      ),
    );
  }

  Future<void> showInterstitialAd() async {
    if (isPremium) return;

    if (_interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          loadInterstitialAd();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          loadInterstitialAd();
        },
      );
      await _interstitialAd!.show();
      _interstitialAd = null;
    }
  }

  BannerAd? getBannerAd() {
    if (isPremium) return null;

    _bannerAd = BannerAd(
      size: AdSize.banner,
      adUnitId: 'your_banner_ad_unit_id_here', // Replace with actual ad unit ID
      listener: BannerAdListener(
        onAdLoaded: (_) {},
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          _bannerAd = null;
        },
      ),
      request: const AdRequest(),
    )..load();

    return _bannerAd;
  }

  void dispose() {
    _interstitialAd?.dispose();
    _bannerAd?.dispose();
  }
}
