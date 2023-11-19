import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {


  @override
  void initState() {
    initAppTrackingTransparencyPlugin();
    initAppFlyer();
    super.initState();
  }

  //this function initialize App Tracking Transparency Plugin
  Future<void> initAppTrackingTransparencyPlugin() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      final TrackingStatus status =
      await AppTrackingTransparency.trackingAuthorizationStatus;
      // If the system can show an authorization request dialog
      if (status == TrackingStatus.notDetermined) {
        await AppTrackingTransparency.requestTrackingAuthorization();
      }
    } catch (e) {
      if (kDebugMode) {
        print("e ${e.toString()}");
      }
    }
    await AppTrackingTransparency.getAdvertisingIdentifier();
  }

  //this function initialize AppFlyer Plugin
  Future<void> initAppFlyer() async {
    AppsflyerSdk appsflyerSdk;

    final appsFlyerOptions = AppsFlyerOptions(
      //afDevKey is AppsFlyer Dev key and it's a required parameter
      afDevKey: "3gnv2x6xnTA5sSXfoMEtcH",
      //Your apple Id is required for iOS apps and it's a required parameter
      //To access your Apple ID visit : https://appstoreconnect.apple.com/apps
      // Click on your app. Create new app if you don't have one.
      // Then click on App Information at the left side which will open a new window where you will find Apple ID
      appId: "1234567890",
      showDebug: kDebugMode,
      timeToWaitForATTUserAuthorization: 50,
    );
    appsflyerSdk = AppsflyerSdk(appsFlyerOptions);

    await appsflyerSdk.initSdk(
      registerConversionDataCallback: true,
      registerOnAppOpenAttributionCallback: true,
      registerOnDeepLinkingCallback: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Appflyer Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Appflyer Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    logAppFlyerEvent("af_increment_button_clicked", {"button_name": "increment_button"});
    setState(() {
      _counter++;
    });
  }

  //this function log events to AppFlyer
  Future<void> logAppFlyerEvent(String eventName, Map eventValues) async {
    AppsflyerSdk appsflyerSdk = AppsflyerSdk(
      AppsFlyerOptions(
        //afDevKey is AppsFlyer Dev key and it's a required parameter
        afDevKey: "3gnv2x6xnTA5sSXfoMEtcH",
        //Your apple Id is required for iOS apps and it's a required parameter
        //To access your Apple ID visit : https://appstoreconnect.apple.com/apps
        // Click on your app. Create new app if you don't have one.
        // Then click on App Information at the left side which will open a new window where you will find Apple ID
        appId: "1234567890",
        showDebug: kDebugMode,
        timeToWaitForATTUserAuthorization: 50,
        disableAdvertisingIdentifier: false,
        disableCollectASA: false,
      ),
    );

    try {
      await appsflyerSdk.logEvent(eventName, eventValues).then((value) {
      });
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
