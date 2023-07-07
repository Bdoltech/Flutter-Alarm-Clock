import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/subjects.dart';

void main() {
  runApp(ClockAlarmApp());
}

class ClockAlarmApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Clock Alarm',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey,
      ),
      home: ClockAlarmScreen(),
    );
  }
}

class ClockAlarmScreen extends StatefulWidget {
  @override
  _ClockAlarmScreenState createState() => _ClockAlarmScreenState();
}

class _ClockAlarmScreenState extends State<ClockAlarmScreen> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  BehaviorSubject<String> didReceiveLocalNotificationSubject =
      BehaviorSubject<String>();
  BehaviorSubject<String> selectNotificationSubject = BehaviorSubject<String>();

  get select => null;

  @override
  void initState() {
    super.initState();
    initializeNotifications();
    didReceiveLocalNotificationSubject.stream.listen((String payload) async {
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Alarm'),
          content: Text(payload),
          actions: <Widget>[
            FlatButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
              },
            ),
          ],
        ),
      );
    });
    selectNotificationSubject.stream.listen((String payload) async {
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Alarm'),
          content: Text(payload),
          actions: <Widget>[
            FlatButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
              },
            ),
          ],
        ),
      );
    });
  }

  Future<void> initializeNotifications() async {
    var initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = IOSInitializationSettings();
    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: select,
    );
  }

  Future<void> selectNotification(String payload) async {
    if (payload != null) {
      debugPrint('Notification payload: $payload');
    }
    selectNotificationSubject.add(payload);
  }

  Future<void> scheduleNotification() async {
    var scheduledNotificationDateTime =
        DateTime.now().add(Duration(seconds: 5));
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'alarm_channel',
      'Alarm',
      'Channel for Alarm notifications',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );
    await flutterLocalNotificationsPlugin.schedule(
      0,
      'Alarm',
      'Wake up!',
      scheduledNotificationDateTime,
      platformChannelSpecifics,
      payload: 'Alarm Payload',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text('Clock Alarm'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: scheduleNotification,
              child: Text('Set Alarm'),
            ),
          ],
        ),
      ),
    );
  }
}

// ignore: non_constant_identifier_names
FlatButton({required Text child, required Null Function() onPressed}) {}
