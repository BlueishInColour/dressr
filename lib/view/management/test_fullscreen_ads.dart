// import 'package:fashion_dragon/view/utils/ad_helper.dart';
// import 'package:fashion_dragon/main.dart';
// import 'package:flutter/material.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
// import 'package:provider/provider.dart';

// class TestFullScreenAdsController extends ChangeNotifier {
//   // TODO: Add interstitialAd
//   InterstitialAd? interstitialAd;

//   void _loadInterstitialAd(Widget child, BuildContext context) {
//     InterstitialAd.load(
//       adUnitId: AdHelper.interstitialAdUnitId,
//       request: AdRequest(),
//       adLoadCallback: InterstitialAdLoadCallback(
//         onAdLoaded: (ad) {
//           ad.fullScreenContentCallback = FullScreenContentCallback(
//             onAdDismissedFullScreenContent: (ad) {
//               Navigator.pushReplacement(context,
//                   PageRouteBuilder(pageBuilder: (context, _, __) {
//                 return child;
//               }));
//             },
//           );

//           interstitialAd = ad;

//           notifyListeners();
//         },
//         onAdFailedToLoad: (err) {
//           print('Failed to load an interstitial ad: ${err.message}');
//         },
//       ),
//     );
//   }
// }

// // import 'package:flutter/material.dart';

// class TestFullScreenAds extends StatefulWidget {
//   const TestFullScreenAds({super.key});

//   @override
//   State<TestFullScreenAds> createState() => TestFullScreenAdsState();
// }

// class TestFullScreenAdsState extends State<TestFullScreenAds> {
//   // TODO: Add interstitialAd
//   InterstitialAd? interstitialAd;

//   void _loadInterstitialAd(Widget child, BuildContext context) {
//     InterstitialAd.load(
//       adUnitId: AdHelper.interstitialAdUnitId,
//       request: AdRequest(),
//       adLoadCallback: InterstitialAdLoadCallback(
//         onAdLoaded: (ad) {
//           ad.fullScreenContentCallback = FullScreenContentCallback(
//             onAdDismissedFullScreenContent: (ad) {
//               Navigator.pushReplacement(context,
//                   PageRouteBuilder(pageBuilder: (context, _, __) {
//                 return child;
//               }));
//             },
//           );

//           setState(() {
//             interstitialAd = ad;
//           });
//         },
//         onAdFailedToLoad: (err) {
//           print('Failed to load an interstitial ad: ${err.message}');
//         },
//       ),
//     );
//   }

//   @override
//   initState() {
//     super.initState();
//     TestFullScreenAdsController()._loadInterstitialAd(MainIndex(), context);
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (interstitialAd != null) {
//       interstitialAd?.show();
//       return Text('ijeoi');
//     } else {
//       return const Center(child: Icon(Icons.construction_sharp, size: 100));
//     }
//   }
// }
