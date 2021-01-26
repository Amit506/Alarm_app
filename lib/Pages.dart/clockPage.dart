import 'dart:typed_data';
import 'package:amitalarm/Painter.dart/ClockPagepainter.dart';
import 'package:amitalarm/Pages.dart/RepeatPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:intl/date_symbol_data_file.dart';
import 'Data.dart';
import 'AlarmInfo.dart';
import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'dart:isolate';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:ui';
import 'package:audioplayers/audioplayers.dart';
import 'ManageRepeat.dart';
import 'package:provider/provider.dart';
import 'package:amitalarm/colors.dart';
import 'package:amitalarm/HomePage.dart';
import 'dart:ui' as ui;
import 'RingtoneSelect.dart';
import 'package:intl/intl.dart';
// import 'package:flutter/services.dart';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';



const uri = 'https://soundcloud.com/steveaoki/steve-aoki-kd-bib';
// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();
    // const MethodChannel platform =
    // MethodChannel('dexterx.dev/flutter_local_notifications_example');

const String portName = "MyAppPort";

class ClockPage extends StatefulWidget {
  final Function onTimeChanged;
  ClockPage({this.onTimeChanged});

  _ClockPageState createState() => _ClockPageState();
}

class _ClockPageState extends State<ClockPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  DateTime currTime;
  DateTime tempcurrTime;
  Duration tempTime;
  DateTime _time;
  Data data = Data();
  bool isSaved = false;
  List<int> dayson = [];
  String daysRepeat = '';
  String label ='Alarm';
 
  final int helloAlarmID = 0;
  @override
  void initState() {
    currTime = DateTime.now();
    data.initializeDatabase().then((value) {
      print('-----------Initialized');
    });
    super.initState();
    
  }
 
  String getDuration(Duration duration) {
    return [duration.inHours, duration.inMinutes.remainder(60)]
        .map((e) => e.toString().padLeft(2, '0'))
        .join(':');
  }

  String getTime(DateTime dateTime) {
    var format = DateFormat.jm();
    String formatedDate = format.format(dateTime).toString();
    return formatedDate;
  }

  void showSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(value),
      duration: Duration(seconds: 2),
      
    ));
  }

  @override
  Widget build(BuildContext context) {
    tempcurrTime = currTime;
    var manageCheckBox = Provider.of<ManageRepeatPage>(context);

    if (manageCheckBox.repeat() == true) {
      daysRepeat = 'none';
    } else {
      daysRepeat = '';
      if (manageCheckBox.saturday() == true) {
        daysRepeat = daysRepeat + 'sat ';
      }
      if (manageCheckBox.sunday() == true) {
        daysRepeat = daysRepeat + 'sun ';
      }
      if (manageCheckBox.monday() == true) {
        daysRepeat = daysRepeat + 'mon ';
      }
      if (manageCheckBox.tuesday() == true) {
        daysRepeat = daysRepeat + 'tues ';
      }
      if (manageCheckBox.wednesday() == true) {
        daysRepeat = daysRepeat + 'wed ';
      }
      if (manageCheckBox.thursday() == true) {
        daysRepeat = daysRepeat + 'thur ';
      }
      if (manageCheckBox.friday() == true) {
        daysRepeat = daysRepeat + 'fri ';
      }
    }
    return Scaffold(
      key: _scaffoldKey,
      body: CustomPaint(
        painter: ClockPagePainter(),
        child: WillPopScope(
          onWillPop: () {
            if (isSaved == false) {
              return showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return Container(
                      child: Column(children: [
                        ListTile(
                            title: TextButton(
                          onPressed: () async {
                            await setAlarm(
                                manageCheckBox.sunday(),
                                manageCheckBox.monday(),
                                manageCheckBox.tuesday(),
                                manageCheckBox.wednesday(),
                                manageCheckBox.thursday(),
                                manageCheckBox.friday(),
                                manageCheckBox.saturday(),
                                manageCheckBox.repeat());
                            
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomePage()));
                          },
                          child: Text('Save'),
                        )),
                        ListTile(
                            title: TextButton(
                          onPressed: () {
                            Navigator.pop(context, true);
                          },
                          child: Text('Cancel'),
                        ))
                      ]),
                    );
                  });
            } else {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => HomePage()));

              return Future.delayed(Duration(seconds: 2),(){
              Navigator.pop(context,true);
              });
            }
          },
          child: SafeArea(
              child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 15, 10, 5.0),
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical:5,horizontal:0),
                                          child: Container(
                        child: Text('Add Alarm',style:TextStyle(fontSize: 25,color:Colors.white,letterSpacing: 1,fontWeight: FontWeight.w500)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: TimePickerSpinner(
                        time: tempcurrTime,
                        is24HourMode: false,
                        normalTextStyle: TextStyle(
                          fontSize: 22,
                          color: Colors.grey[500],
                        ),
                        highlightedTextStyle: TextStyle(
                          fontSize: 32,
                          shadows: [
                            Shadow(
                              offset: Offset(1.5, 2.0),
                              blurRadius: 1,
                              color: blue13,
                            ),
                            Shadow(
                              offset: Offset(2.3, 3.3),
                              blurRadius: 1,
                              color: blue16,
                            ),
                          ],
                          foreground: Paint()
                            ..shader = ui.Gradient.linear(
                              Offset(0.0, 0.3),
                              Offset(0.5, 1.0),
                              [
                                blue7,
                                blue13,
                              ],
                              [
                                2,
                                5,
                              ],
                              TileMode.mirror,
                            ), //.createShader(Rect.fromLTRB(10.0, 2.0, 0.0, 2.0)),
                        ),
                        spacing: 15,
                        itemHeight: 50,
                        isForce2Digits: true,
                        onTimeChange: (time) {
                          setState(() {
                            tempcurrTime = time;
                            _time = time;
                          });
                          if (time.isBefore(currTime)) {
                            time = time.add(Duration(days: 1));
                            setState(() {
                              tempTime = time.difference(currTime);
                              _time = time;
                            });
                          } else {
                            setState(() {
                              tempTime = time.difference(currTime);
                              _time = time;
                            });
                          }
                        },
                      ),
                    ),
                    Text(tempTime != null
                        ? ' alarm is after ' + getDuration(tempTime)
                        : 'loading',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w300,fontSize: 13
                        ),),
                     
                        Divider(
                          height: 15,
                          thickness: 3,
                        ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(getTime(tempcurrTime),style: TextStyle(color: Colors.white,fontSize: 18)),
                          Row(
                            children: [
                              TextButton(
                                  child: Text("Save",style:TextStyle(color:blue3,fontSize: 18)),
                                  onPressed: () async {
                      
                                    await setAlarm(
                                      manageCheckBox.sunday(),
                                      manageCheckBox.monday(),
                                      manageCheckBox.tuesday(),
                                      manageCheckBox.wednesday(),
                                      manageCheckBox.thursday(),
                                      manageCheckBox.friday(),
                                      manageCheckBox.saturday(),
                                      manageCheckBox.repeat(),
                                    );
                               
                                    // await showSnackBar(' alarm is after ' +
                                    //     getDuration(tempTime));
                                    // Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //         builder: (context) => HomePage()));
                                  }),
                              TextButton(
                                child: Text('Cancel',style:TextStyle(color:blue3,fontSize: 18)),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => HomePage()));
                                },
                              )
                            ],
                          ),
                        ]),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2,vertical: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Label',style: TextStyle(color: Colors.white,fontSize: 18)),
                          SizedBox(
                            width: 200,
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: TextFormField(
                                initialValue: 'Alarm',
                              style:      TextStyle(color: blue3,fontSize: 16),
                                textAlign: TextAlign.end,
                                decoration: InputDecoration.collapsed(
                                    hintText: '.....'),
                                onChanged: (value) {
                                  label = value;
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2,vertical: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Repeat',style: TextStyle(color: Colors.white,fontSize: 18)
                          ),

                          InkWell(
                            onTap: () {
                              
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Repeat()));
                            },
                            child: Row(mainAxisSize: MainAxisSize.min, children: [
                              Text(daysRepeat,style: TextStyle(color: blue3,fontSize: 17)),
                              Icon(Icons.arrow_forward_ios,color: blue3,),
                            ]),
                           
                          )
                        ],
                      ),
                    ),

                    Padding(
                           padding: const EdgeInsets.symmetric(horizontal: 2,vertical: 5),
                      child: Row(
                        
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children:[
                           Text('Ringtone',style: TextStyle(color: Colors.white,fontSize: 18)),
                            TextButton(onPressed:() {
                       Navigator.push(context, MaterialPageRoute(builder: (context)=>RingtoneSelect()));
                            }, child:Row(mainAxisSize: MainAxisSize.min, children: [
                              Text('choose',style: TextStyle(color: blue3,fontSize: 17)),
                              Icon(Icons.arrow_forward_ios,color: blue3,),
                            ]),)


                        ]
                        
                        ),
                    ),
                  ],
                ),
              ),
            ),
          )),
        ),
      ),
    );
  }

  DateTime wednesday(DateTime today) {
    while (today.weekday != 3) {
      today = today.add(Duration(days: 1));
    }
    return today;
  }

  Future setAlarm(
    bool sun,
    bool mon,
    tues,
    bool wed,
    bool thur,
    bool fri,
    bool sat,
    bool repeat,
  ) async {
    print('started');
    print('-------setrepeated aalram');
    print(_time.toString());
    print('-------one alaram');
    print(tempTime.toString());
   
    print('-----repeat is true or not');
    print(repeat.toString());

    if (repeat == true) {
      setOnceAlarm(8);
    } else {
      if (sun == true) {
        DateTime tempDate = sunday(_time);
        print('-----sunday date');
        print(tempDate.toString());
        dayson.add(6);
        setPeriodicAlarm(7, Duration(days: 7), tempDate);
      }
      if (mon == true) {
        DateTime tempDate = monday(_time);
        dayson.add(0);
        setPeriodicAlarm(1, Duration(days: 7), tempDate);
      }
      if (tues == true) {
        DateTime tempDate = tuesday(_time);
        dayson.add(1);
        setPeriodicAlarm(2, Duration(days: 7), tempDate);
      }
      if (wed == true) {
        DateTime tempDate = wednesday(_time);
        dayson.add(2);
        setPeriodicAlarm(3, Duration(days: 7), tempDate);
      }
      if (thur == true) {
        DateTime tempDate = thursday(_time);
        dayson.add(3);
        setPeriodicAlarm(4, Duration(days: 7), tempDate);
      }
      if (fri == true) {
        DateTime tempDate = friday(_time);
        dayson.add(4);
        setPeriodicAlarm(5, Duration(days: 7), tempDate);
      }
      if (sat == true) {
        dayson.add(5);
        DateTime tempDate = saturday(_time);
        setPeriodicAlarm(6, Duration(days: 7), tempDate);
      }
    }
    print('ended');
  }

  ////////

  void setOnceAlarm(int id) async {
    Uint8List tempDaysOn = Uint8List.fromList(dayson);
    setState(() {
      isSaved = true;
    });
    var result = await AndroidAlarmManager.oneShot(
        Duration(hours: tempTime.inHours, minutes: tempTime.inMinutes),
        8,
        printHello,
        alarmClock: true,
        allowWhileIdle: true,
        rescheduleOnReboot: true,
        wakeup: true);
    var alarmInfo = AlarmInfo(
        alarmDateTime: _time.toString(),
        alarmId: id,
        title: label,
        dayson: tempDaysOn);
    data.inserAalarm(alarmInfo);
    print('---once alarm result ');
    print(result.toString());
  }

  void setPeriodicAlarm(int id, Duration duration, DateTime dateTime) async {
    setState(() {
      isSaved = true;
    });
    Uint8List tempDaysOn = Uint8List.fromList(dayson);
    var result = await AndroidAlarmManager.periodic(
        Duration(days: 7), id, printHello,
        startAt: dateTime, rescheduleOnReboot: true, wakeup: true);

    var alarmInfo = AlarmInfo(
      alarmDateTime: dateTime.toIso8601String(),
      alarmId: id,
      dayson: tempDaysOn,
      title: label,
    );
    data.inserAalarm(alarmInfo);
    print('---result of periodic alarm');
    print(dateTime.toString());
    print(result.toString());
  }

  DateTime monday(DateTime today) {
    while (today.weekday != 1) {
      today = today.add(Duration(days: 1));
    }
    return today;
  }

  DateTime tuesday(DateTime today) {
    while (today.weekday != 2) {
      today = today.add(Duration(days: 1));
    }
    return today;
  }

  DateTime thursday(DateTime today) {
    while (today.weekday != 4) {
      today = today.add(Duration(days: 1));
    }
    return today;
  }

  DateTime friday(DateTime today) {
    while (today.weekday != 5) {
      today = today.add(Duration(days: 1));
    }
    return today;
  }

  DateTime saturday(DateTime today) {
    while (today.weekday != 6) {
      today = today.add(Duration(days: 1));
    }
    return today;
  }

  DateTime sunday(DateTime today) {
    while (today.weekday != 7) {
      today = today.add(Duration(days: 1));
    }
    return today;
  }
  
static printHello() async {
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
  //  final String alarmUri = await platform.invokeMethod('getAlarmUri');

   AudioPlayer audioplayer = AudioPlayer();
   var result =await audioplayer.play(uri);
   print(result.toString());


await AwesomeNotifications().createNotification(
  content: NotificationContent(
      id: 10,
      channelKey: 'basic_channel',
      title: 'Alarm',
      createdSource: NotificationSource.Local,
    

  ),
    actionButtons: [
        NotificationActionButton(
          key:'example',
          icon:'resource://drawable/ic_launcher',
          buttonType: ActionButtonType.Default,
          label: 'stop'
        )
      ]
);
 Future.delayed(Duration(seconds: 30),(){
    audioplayer.stop();
  });

     
// final UriAndroidNotificationSound uriSound =
//         UriAndroidNotificationSound(alarmUri);
// AndroidNotificationChannelAction androidNotificationChannelAction = AndroidNotificationChannelAction.createIfNotExists;
//   await flutterLocalNotificationsPlugin.show(
//       1,
//       'scheduled body',
//       'Hii guys',
//       NotificationDetails(
//           android: AndroidNotificationDetails(
//         'your channel id',
//         'your channel name',
//         'your channel description',
//         channelAction: androidNotificationChannelAction,
//         // sound: uriSound,
//         enableVibration: true,
        
//       )));
}

}

// void printHello() async {
//   SendPort sendPort = IsolateNameServer.lookupPortByName(portName);

//   if (sendPort != null) {
//     sendPort.send('working');
//     print('working');
//   }
//   if (sendPort == null) {
//     print('hatt');
//   }

//   final DateTime now = DateTime.now();
//   final int isolateId = Isolate.current.hashCode;

//   print("[$now] Hello, world! isolate=$isolateId function='$printHello'");
// //    final String alarmUri = await platform.invokeMethod('getAlarmUri');
// // final UriAndroidNotificationSound uriSound =
// //         UriAndroidNotificationSound(alarmUri);
// AndroidNotificationChannelAction androidNotificationChannelAction = AndroidNotificationChannelAction.createIfNotExists;
//   await flutterLocalNotificationsPlugin.show(
//       1,
//       'scheduled body',
//       'Hii guys',
//       NotificationDetails(
//           android: AndroidNotificationDetails(
//         'your channel id',
//         'your channel name',
//         'your channel description',
//         channelAction: androidNotificationChannelAction,
//         // sound: uriSound,
//         enableVibration: true,
//       )));
// }


















































// Future<void> _showSoundUriNotification() async {
//     /// this calls a method over a platform channel implemented within the
//     /// example app to return the Uri for the default alarm sound and uses
//     /// as the notification sound
//     final String alarmUri = await platform.invokeMethod('getAlarmUri');
//     final UriAndroidNotificationSound uriSound =
//         UriAndroidNotificationSound(alarmUri);
//     final AndroidNotificationDetails androidPlatformChannelSpecifics =
//         AndroidNotificationDetails(
//             'uri channel id', 'uri channel name', 'uri channel description',
//             sound: uriSound,
//             styleInformation: const DefaultStyleInformation(true, true));
//     final NotificationDetails platformChannelSpecifics =
//         NotificationDetails(android: androidPlatformChannelSpecifics);
//     await flutterLocalNotificationsPlugin.show(
//         0, 'uri sound title', 'uri sound body', platformChannelSpecifics);
//   }