import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:smart_home/data/Device.dart';
import 'package:smart_home/theme/Colors.dart';
import 'package:smart_home/theme/theme.dart';
import 'package:vector_math/vector_math.dart' show radians;
import 'dart:math' as math;


class DevicePage extends StatelessWidget {
  final Device device;

  const DevicePage({Key key, this.device}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Hero(
            tag: '${device.deviceName}bg',
            child: Container(
              decoration: widgetDecoration,
            ),
          ),
          SafeArea(
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: <Widget>[
                  new HeaderWidget(
                    device: device,
                  ),
                  new ControllerWidget(device: device),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HeaderWidget extends StatelessWidget {
  final Device device;

  const HeaderWidget({
    Key key,
    this.device,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Hero(
            tag: device.deviceIcon,
            child: Container(
              margin: const EdgeInsets.all(4),
              child: Icon(
                Icons.arrow_back_ios,
                size: 16,
                color: Colors.white,
              ),
              padding: const EdgeInsets.all(8),
              decoration: widgetDecoration,
            ),
          ),
        ),
        Expanded(
          child: Align(
            alignment: Alignment.center,
            child: Hero(
              tag: device.deviceName,
              child: Material(
                color: backgroundColor,
                child: Text(
                  device.deviceName,
                  style: titleStyle,
                ),
              ),
            ),
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Hero(
            tag: '${device.deviceIcon}2',
            child: Container(
              margin: const EdgeInsets.all(4),
              child: Icon(
                Icons.add,
                size: 16,
                color: Colors.white,
              ),
              padding: const EdgeInsets.all(8),
              decoration: widgetDecoration,
            ),
          ),
        ),
      ],
    );
  }
}

class ControllerWidget extends StatefulWidget {
  final Device device;

  const ControllerWidget({
    Key key,
    this.device,
  }) : super(key: key);

  @override
  _ControllerWidgetState createState() => _ControllerWidgetState();
}

class _ControllerWidgetState extends State<ControllerWidget> {
  double _progress = 25;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Hero(
              tag: '${widget.device.deviceName}tempreture',
              child: Material(
                color: backgroundColor,
                child: TempratureDial(
                  tempreture: _progress,
                ),
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Hero(
              tag: '${widget.device.deviceName}slider',
              child: Material(
                color: backgroundColor,
                child: Slider(
                  value: _progress,
                  onChanged: (progress) {
                    setState(() {
                      _progress = progress;
                    });
                  },
                  activeColor: Colors.deepOrange,
                  inactiveColor: Colors.deepOrangeAccent,
                  min: 0,
                  max: 100,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TempratureDial extends StatelessWidget {
  double tempreture;

  TempratureDial({this.tempreture});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      foregroundPainter: TempretureIndicator(tempreture: tempreture),
      child: Container(
        decoration: tempretureDialDecoration(),
        child: Container(
          margin: const EdgeInsets.all(14),
          padding: const EdgeInsets.all(5),
          decoration: tempretureDialDecoration(),
          child: CustomPaint(
            foregroundPainter: TempretureProgressBar(
              tempreture: tempreture,
            ),
            child: Container(
              margin: const EdgeInsets.all(28),
              child: Column(
                children: <Widget>[
                  Text(
                    '${tempreture.toInt()}\u00B0 C',
                    style: TextStyle(fontSize: 28, color: accentColor),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Cool mood',
                    style: TextStyle(fontSize: 14, color: accentColor),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TempretureProgressBar extends CustomPainter {
  final double tempreture;

  TempretureProgressBar({this.tempreture});

  @override
  void paint(Canvas canvas, Size size) {
    Paint progressPaint = Paint()
      ..color = accentColor
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    Offset center = Offset(size.width / 2, size.height / 2);
    double radius = min(size.width / 2, size.height / 2);

    double arcAngle = 2 * pi * (tempreture / 100);
    canvas.drawArc(new Rect.fromCircle(center: center, radius: radius), -pi / 2,
        arcAngle, false, progressPaint);

    Paint progressHeader = Paint()
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round
      ..color = accentColor;

    final progress = tempreture / 100;
    final thumbAngle = 2 * pi * progress - (pi / 2);
    final thumbX = cos(thumbAngle) * radius;
    final thumbY = sin(thumbAngle) * radius;
    final thumbCenter = new Offset(thumbX, thumbY) + center;
    final thumbRadius = 5.0;

    Paint progressHoleHeader = Paint()
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round
      ..color = Colors.white;

    canvas.drawCircle(
      thumbCenter,
      thumbRadius,
      progressHeader,
    );
    canvas.drawCircle(
      thumbCenter,
      thumbRadius / 2,
      progressHoleHeader,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class TempretureIndicator extends CustomPainter {
  final double tempreture;

  TempretureIndicator({this.tempreture});

  final linePainter = Paint()
    ..color = lineColor
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1.5;
  final double lineHeight = 8;
  final int maxLines = 12;
  final previousPoint = 0.0;
  @override
  void paint(Canvas canvas, Size size) {
    final circleWidth = 10.0;
    Offset center = Offset(size.width / 2, size.height / 2);
    double radius = min(size.width / 2, size.height / 2);
    Paint indicatorPaint = Paint()
      ..strokeWidth = circleWidth
      ..color = Brighter
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(center, radius, indicatorPaint);

    canvas.translate(size.width / 2, size.height / 2);

    canvas.save();

    final progressPercentage = tempreture/100;

    final progress = tempreture / 100;
    final thumbAngle = 2 * pi * progress - (pi / 2);
    final thumbX = cos(thumbAngle) * radius;
    final thumbY = sin(thumbAngle) * radius;
    final thumbCenter = new Offset(thumbX, thumbY) + center;

   // final deg  = atan2(y2-y1, x2-x1);
   // print('degree  $deg');
   // print('progress $progressPercentage');
    List.generate(maxLines, (i) {

      final lineAngle =2 * pi * progress - (pi / 2);

      //print('calculationg $lineAngle  and $thumbAngle');


      final a1 =  Offset(0, radius + 5);
      final b1 =  Offset(0, radius - 5);

      canvas.drawLine(
         a1, b1, linePainter);
      canvas.rotate(2 * pi / maxLines);


    });

    canvas.restore();

  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

BoxDecoration tempretureDialDecoration() => BoxDecoration(
    color: backgroundColor,
    shape: BoxShape.circle,
    boxShadow: [
      BoxShadow(
        color: Darker,
        blurRadius: 1,
        spreadRadius: 0,
        offset: Offset(2, 2),
      ),
      BoxShadow(
        color: Brighter,
        blurRadius: 1,
        spreadRadius: 0,
        offset: Offset(-2, -2),
      ),
    ],
    gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [LightBrighter, backgroundColor]));
