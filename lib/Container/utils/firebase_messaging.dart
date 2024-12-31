import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_router/go_router.dart';
import 'package:hafilaty_driver/Container/utils/error_notification.dart';
import 'package:hafilaty_driver/View/Screens/Main_Screens/Map_Screen/map_logics.dart';


class MessagingService {
  static String? fcmToken; // Variable to store the FCM token

  static final MessagingService _instance = MessagingService._internal();

  factory MessagingService() => _instance;

  MessagingService._internal();

  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  Future<void> init(BuildContext context) async {
    try {
      // Requesting permission for notifications
      NotificationSettings settings = await _fcm.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      debugPrint(
          'User granted notifications permission: ${settings.authorizationStatus}');

      // Retrieving the FCM token
      fcmToken = await _fcm.getToken();
      print('fcmToken: $fcmToken');


      const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'Trippo (Driver)', // title // description
  importance: Importance.max,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

await flutterLocalNotificationsPlugin
  .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
  ?.createNotificationChannel(channel);

      // Handling background messages using the specified handler
      FirebaseMessaging.onBackgroundMessage(
          _firebaseMessagingBackgroundHandler);


     void showNotDialog(message , notificationData){
  showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return PopScope(
                  canPop: false,
                  child: AlertDialog(
                    title: Text(message.notification!.title!),
                    content: Text(
                      message.notification!.body!,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(color: Colors.black54),
                    ),
                    actions: [
                      if (notificationData.containsKey('screen'))
                        TextButton(
                          onPressed: () {
                            HomeLogics()
                                .sendNotificationToUser(context, "accepted");

                                
                          },
                          child: const Text('Accept request'),
                        ),
                      TextButton(
                        onPressed: () {
                          HomeLogics()
                              .sendNotificationToUser(context, "denied");
                          context.pop();
                        },
                        child: const Text('Deny Request'),
                      ),
                    ],
                  ),
                );
              },
            );
     }

      // Listening for incoming messages while the app is in the foreground
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {


        if (message.notification != null) {
          if (message.notification!.title != null &&
              message.notification!.body != null) {
            final notificationData = message.data;
showNotDialog(message ,notificationData );
            // Showing an alert dialog when a notification is received (Foreground state)

          }
        }
      });

      // Handling a notification click event by navigating to the specified screen
      void handleNotificationClick(
          BuildContext context, RemoteMessage message) {
        final notificationData = message.data;

        if (notificationData.containsKey('screen')) {
          final screen = notificationData['screen'];
          context.goNamed(screen);

          showNotDialog(message ,notificationData );
        }
      }

      // Handling the initial message received when the app is launched from dead (killed state)
      // When the app is killed and a new notification arrives when user clicks on it
      // It gets the data to which screen to open
      FirebaseMessaging.instance.getInitialMessage().then((message) {
        if (message != null) {
          handleNotificationClick(context, message);
        }
      });

      // Handling a notification click event when the app is in the background
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {

        handleNotificationClick(context, message);
      });
    } catch (e) {
      await Future.delayed(const Duration(seconds: 2));
      SystemChannels.platform.invokeMethod("SystemNavigator.pop");

      if (context.mounted) {
        ErrorNotification().showError(context, e.toString());
      }
    }
  }
}

// Handler for background messages
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  debugPrint('Handling a background message: ${message.notification!.title}');
}
