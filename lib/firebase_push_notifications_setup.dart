import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:moss_yoga/common/resources/page_path.dart';
import 'package:moss_yoga/presentation/providers/firebase_messaging_providers/firebase_messaging_provider.dart';

import 'app/app_router.dart';

class FirebaseApi {
  FirebaseApi(this.ref);

  final ProviderContainer ref;
  var myDeviceToken = '';
  final _androidChannel = const AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This channel is used for important notifications',
    importance: Importance.defaultImportance,
  );

  final _localNotifications = FlutterLocalNotificationsPlugin();

  static Future<void> handleBackgroundMessage(RemoteMessage message) async {
    print('Title: ${message.notification?.title}');
    print('body: ${message.notification?.body}');
    print('Payload: ${message.data}');
    // return
  }

  Future initPushNotifications() async {
    ///This is important for iOS Foreground notifications
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    ///Responsible for performing an action when an app is opened from a
    ///terminated state via a notification.
    ///we pass handle msg function meaning we want it to execute that method
    ///when app is opened from notification.
    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);

    ///This is responsible when app is in background when a notification comes.
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);

    ///This is just for backgroundNotification( When the app is closed).
    ///When app is in background state;
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);

    ///When App is open and a notification pops, we use
    ///Flutter Local notifications to show it but we listen
    ///to the local notifications throught listen
    FirebaseMessaging.onMessage.listen((message) {
      final notification = message.notification;
      if (notification == null) return;

      _localNotifications.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              _androidChannel.id,
              _androidChannel.name,
              channelDescription: _androidChannel.description,
              icon: '@drawable/ic_launcher',
            ),
          ),
          payload: jsonEncode(
            message.toMap(),
          ));
    });
  }

  ///THIS IS FOR BELOW LOCAL NOTIFICATION HANDLING
  void onDidReceiveNotificationResponse(NotificationResponse response) {
    if (response.payload == null) return;
    final message = RemoteMessage.fromMap(jsonDecode(response.payload!));
    handleMessage(message);
  }

  void onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) {
    // Handle foreground notification content here
    if (payload == null) return;
    final message = RemoteMessage.fromMap(jsonDecode(payload));
    handleMessage(message);
  }

  Future onSelectNotification(String payload) async {}

  Future initLocalNotifications() async {
    // Initialization settings for Android
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@drawable/ic_launcher');

    // Initialization settings for iOS
    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
            onDidReceiveLocalNotification: onDidReceiveLocalNotification);

    // Initialize the plugin
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsDarwin);

    await _localNotifications.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);

    final platform = _localNotifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await platform?.createNotificationChannel(_androidChannel);
  }

  Future<void> initNotifications() async {
    ///Request for permission first.
    await requestPermission();

    ///Get The Token when the permission is granted.
    ///Save the token to sharedPrefs once token gotten. (Save method is called inside).
    await getToken();

    ///Initialize all push notifications. foreground, background, killed States.
    initPushNotifications();

    ///Initialize Android and iOS Local Notifications for showing notification in foreground.
    initLocalNotifications();
  }

  Future<void> requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  Future<void> getToken() async {
    await FirebaseMessaging.instance.getToken().then((token) {
      // setState(() {
      myDeviceToken = token!;
      print('This is the new value of myDeviceToken: $myDeviceToken');
      // });
      saveToken(token: myDeviceToken);
    });
  }

  Future<void> saveToken({String? token}) async {
    if (token == null || token == '') {
      return;
    }

    /// save to sharedPreferences
    await ref
        .read(firebaseMessagingNotifierProvider.notifier)
        .saveTokenOnSharedPrefs(token: token);

    ///send to BackEnd API
    ///Specific User
  }

  void handleMessage(RemoteMessage? message) {
    if (message == null) return;

    // navigatorKey.currentState
    //     ?.pushNamed(PagePath.notification, arguments: message);
    print(
        'inside handleMessage with the message ${message.notification?.title}');
    print(
        'inside handleMessage with the message ${message.notification?.body}');
    // GoRouter.of(context).go(
    // '${PagePath.loginBothUserExists}?userType=$userType&userId=${user.userId}&userToken=${user.token}&userEmail=${user.email}');
    rootNavigatorKey.currentState?.context
        .go(PagePath.notificationScreen, extra: message);
  }
}
