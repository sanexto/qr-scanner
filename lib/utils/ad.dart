import 'package:qr_scanner/config.dart' as config;

import 'package:firebase_admob/firebase_admob.dart';

Future<void> showBannerAd() async{

  String appId = config.debug ? FirebaseAdMob.testAppId : config.adMobAppId;
  String bannerId = config.debug ? BannerAd.testAdUnitId : config.adMobBannerId;

  FirebaseAdMob.instance.initialize(
    appId: appId,
    analyticsEnabled: true,
  );

  BannerAd bannerAd = BannerAd(
    adUnitId: bannerId,
    size: AdSize.smartBanner,
  );

  await bannerAd.load();
  await bannerAd.show(
    anchorType: AnchorType.bottom,
  );

}
