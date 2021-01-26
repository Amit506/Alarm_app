import 'dart:convert';

import 'dart:typed_data';

AlarmInfo welcomeFromJson(String str) => AlarmInfo.fromJson(json.decode(str));

String welcomeToJson(AlarmInfo data) => json.encode(data.toJson());

class AlarmInfo {
  AlarmInfo({
    this.id,
    this.alarmDateTime,
    this.alarmId,
    this.title,
    this.dayson,
  });

  int id;
  Uint8List dayson;
  int alarmId;
  String alarmDateTime;
  String title;

  factory AlarmInfo.fromJson(Map<String, dynamic> json) => AlarmInfo(
        id: json["id"],
        alarmDateTime: json["alarmDateTime"],
        alarmId: json["alarmId"],
        title: json["title"],
        dayson: json["dayson"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "alarmDateTime": alarmDateTime,
        "alarmId": alarmId,
        "title": title,
        "dayson": dayson,
      };
}
