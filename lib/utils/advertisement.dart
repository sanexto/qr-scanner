import 'package:qr_scanner/config.dart' as config;

import 'package:firebase_admob/firebase_admob.dart';

class Advertisement{

  static BannerAd adBlock;

  static Future<void> initialize() async{

    String appId = config.debug ? FirebaseAdMob.testAppId : config.adMobAppId;
    String adBlockId = config.debug ? BannerAd.testAdUnitId : config.adMobBannerId;

    await FirebaseAdMob.instance.initialize(
      appId: appId,
      analyticsEnabled: true,
    );

    Advertisement.adBlock = BannerAd(
      adUnitId: adBlockId,
      size: AdSize.smartBanner,
    );

  }

  static Future<void> show() async{

    await Advertisement.adBlock.load();

    await Advertisement.adBlock.show(
      anchorType: AnchorType.bottom,
    );

  }

  static Future<void> dispose() async{

    await Advertisement.adBlock.dispose();

  }

}
