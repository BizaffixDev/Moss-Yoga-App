import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moss_yoga/app/app.dart';
import 'package:moss_yoga/app/app_config.dart';
import 'package:moss_yoga/di/injector.dart';
import 'package:moss_yoga/firebase_options.dart';
import 'package:moss_yoga/firebase_push_notifications_setup.dart';
import 'package:moss_yoga/global.dart';

final GlobalKey<NavigatorState> mossYogaNavigatorKey =
    GlobalKey<NavigatorState>();

Future<void> main() async {
  //Assign publishable key to flutter_stripe
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey =
      "pk_test_51NH5CJC4SpUmTFv8nShCNbYhWGjPewnhiTYuezQBGqYLFZTFKAyX1mfH3GPVdZueqxIW5iJuVNEOZob8dcQUrQAr00X1CvvGU8";

  //Load our .env file that contains our Stripe Secret key
  await dotenv.load(fileName: "assets/.env");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final container = ProviderContainer();
  Injector.setup(appConfig: AppConfig.dev(), container: container);
  print('--------Before FirebaseAPI launches Sir');
  await FirebaseApi(container).initNotifications();
  print('--------After FirebaseAPI launches Sir');
  runApp(

    UncontrolledProviderScope(
      container: container,
      child: DevicePreview(
        enabled: GlobalVariable.enablePreview,
        builder: (context) {
          return MossYoga(
            key: mossYogaNavigatorKey,
          );
        },
      ),

      /*MossYoga(
        key: mossYogaNavigatorKey,
      ),*/
    ),
  );
}
