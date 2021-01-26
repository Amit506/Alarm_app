import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:flutter/material.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'HomePage.dart';
import 'package:provider/provider.dart';
import 'Pages.dart/ManageRepeat.dart';
import 'Pages.dart/clockPage.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final AndroidInitializationSettings initializationSettings =
      AndroidInitializationSettings('ic_launcher');
  // await flutterLocalNotificationsPlugin
  //     .initialize(InitializationSettings(android: initializationSettings),
  //         onSelectNotification: (String payload) async {
  //   if (payload != null) {
  //     debugPrint('notification payload' + payload);
  //   }
  // });
  await  AwesomeNotifications().initialize(
    
    'resource://drawable/ic_launcher',
    [
        NotificationChannel(
            channelKey: 'basic_channel',
            channelName: 'Basic notifications',
            channelDescription: 'Notification channel for basic tests',
            defaultColor: Color(0xFF9D50DD),
            ledColor: Colors.white
        )
    ]
);

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context)=>ManageRepeatPage(),
          child: MaterialApp(
          home: HomePage(),
        ),
    );
  }
}
