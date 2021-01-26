import 'package:flutter/material.dart';
import 'package:amitalarm/Pages.dart/clockPage.dart';
import 'package:amitalarm/colors.dart';

class ClockPagePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final height = size.height;
    final width = size.width;
    Paint paint = Paint();

    Path mainBackGround = Path();
    mainBackGround.addRect(Rect.fromLTRB(0, 0, width, height));
    paint.color = blue4;
    canvas.drawPath(mainBackGround, paint);

    Path ovalPath = Path();
    ovalPath.moveTo(0, height * 0.2);
    ovalPath.quadraticBezierTo(
        width * 0.45, height * 0.25, width * 0.52, height * 0.5);
    ovalPath.quadraticBezierTo(width * 0.58, height * 0.8, width * 0.1, height);
 ovalPath.lineTo(0, height);
    ovalPath.close();
    paint.color = blue10;
    canvas.drawPath(ovalPath, paint);
    
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}