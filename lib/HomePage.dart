import 'dart:isolate';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter/material.dart';
import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'dart:ui';
import 'package:audioplayers/audioplayers.dart';
import 'package:audioplayers/audio_cache.dart';
import 'Pages.dart/clockPage.dart';
import 'Pages.dart/Data.dart';
import 'colors.dart';
import 'Pages.dart/AlarmInfo.dart';
import 'package:intl/intl.dart';

import 'Painter.dart/HomePagepainter.dart';

const url = 'https://luan.xyz/files/audio/ambient_c_motion.mp3';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

const String portName = "MyAppPort";

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Duration time;
  final int helloAlarmID = 0;
  Data data = Data();

  ReceivePort receivePort = ReceivePort();
  final String alarm = 'amitAlar';

  @override
  void initState() {
    data.initializeDatabase().then((value) async {
      print('-----------Initialized');
      await getAlamr();
    });
    super.initState();

    IsolateNameServer.registerPortWithName(receivePort.sendPort, portName);
    AndroidAlarmManager.initialize();
    receivePort.listen((message) {
      print(message);
    });
  }
              void  loadingAlarm()async{
                await getAlamr();
              }
  Future<List<AlarmInfo>> getAlamr() async {
    List<AlarmInfo> _alarms = [];
    var db = await data.database;
    var result = await db.query(alarm);
    result.forEach((element) {
      var alarmInfo = AlarmInfo.fromJson(element);
      _alarms.add(alarmInfo);
    });
    print(_alarms.toString());
    return _alarms;
  }

  String getTime(DateTime dateTime) {
    var format = DateFormat.jm();
    String formatedDate = format.format(dateTime).toString();
    return formatedDate;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Alarm App',style: TextStyle(letterSpacing: 2,color: blue3
        
         ),),
        shadowColor: blue6,
        
        actions: [
          
          IconButton(icon: Icon(Icons.settings), onPressed: null)
        ],
      ),
      body: CustomPaint(
        painter: HomePagePainter(),
              child: Container(
              height: MediaQuery.of(context).size.height,
              child: Stack(
                              children:[ FutureBuilder(
          future: getAlamr(),
          builder: (context, AsyncSnapshot<List<AlarmInfo>> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, index) {
                        print(index.toString());
                        print(snapshot.data[index].id);

                        return Dismissible(
                          key: ValueKey(index),
                          background: Container(
                            color: Colors.white,
                          ),
                          onDismissed: (direction) async {
                            await data.deleteAlarms(snapshot.data[index].id);
                            await alarmCancel(snapshot.data[index].alarmId);
                          },
                          child: ListTile(
                            title: GestureDetector(
                                onTap: () async {
                                  await data
                                      .deleteAlarms(snapshot.data[index].id);
                                  await alarmCancel(
                                      snapshot.data[index].alarmId);
                                },
                                child: Text(snapshot.data[index].title,style:TextStyle(color:Colors.white,fontWeight: FontWeight.bold))),
                            subtitle: Text(getTime(DateTime.parse(snapshot.data[index].alarmDateTime)),style:TextStyle(color:Colors.white)
                                ),
                          ),
                        );
                      });
                } else {
                  return Text('gdjhajsdghjd');
                }
            } else {
                return Text('nhi hua');
            }
          }),
          Positioned(
            right:20,
            bottom: 30,
            child:FloatingActionButton(
              splashColor: blue6,
              focusColor: blue6,
              backgroundColor: Colors.white,
              onPressed: (){
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ClockPage()));
              },
              tooltip: 'Add Alarm',
              child: Icon(Icons.add,color: blue3,),
            ),
            
            
            ),
                              ]
              )),
      ),
    );
  }

  Future alarmCancel(int id) async {
    var result = AndroidAlarmManager.cancel(id);
    print(result.toString());
  }

  // void schedulealarm() async {
  //   tz.initializeTimeZones();
  //   await flutterLocalNotificationsPlugin.zonedSchedule(
  //       0,
  //       'scheduled title',
  //       'scheduled body',
  //       tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
  //       const NotificationDetails(
  //           android: AndroidNotificationDetails(
  //         'your channel id',
  //         'your channel name',
  //         'your channel description',
  //         playSound: true,
  //       )),
  //       androidAllowWhileIdle: true,
  //       uiLocalNotificationDateInterpretation:
  //           UILocalNotificationDateInterpretation.absoluteTime);
  // }
}

printHello(String hii) async {
  SendPort sendPort = IsolateNameServer.lookupPortByName(portName);

  if (sendPort != null) {
    sendPort.send('working');
    print('working');
  }
  if (sendPort == null) {
    print('hatt');
  }

  final DateTime now = DateTime.now();
  final int isolateId = Isolate.current.hashCode;

  print("[$now] Hello, world! isolate=$isolateId function='$printHello'");

  await flutterLocalNotificationsPlugin.show(
      1,
      'scheduled body',
      'Hii guys',
      NotificationDetails(
          android: AndroidNotificationDetails(
        'your channel id',
        'your channel name',
        'your channel description',
      )));
}
