import 'package:controle_despesas/app/theme/spacing.dart';
import 'package:controle_despesas/app/theme/theme.dart';
import 'package:flutter/material.dart';

import 'package:flutter/scheduler.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late Ticker _ticker;
  double _progress = 0.0;

  @override
  void initState() {
    super.initState();

    _ticker = createTicker((elapsed) {
      setState(() {
        _progress = (elapsed.inMilliseconds % 2000) / 2000;
      });
    })
      ..start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: buildTheme(Brightness.light),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(width: 160, "assets/images/logo_to_liso.png"),
              const SizedBox(height: Spacing.defaultSpacing),
              const Text(
                "TÔ LISO",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: Spacing.defaultSpacing * 2),
              SizedBox(
                height: 3,
                width: 160,
                child: CustomPaint(
                  painter: _LoaderPainter(_progress),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoaderPainter extends CustomPainter {
  final double progress;

  _LoaderPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final backgroundPaint = Paint()
      ..color = Colors.grey[300]!
      ..strokeCap = StrokeCap.square
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.height;

    canvas.drawLine(
      Offset(0, size.height / 2),
      Offset(size.width, size.height / 2),
      backgroundPaint,
    );

    final animatedPaint = Paint()
      ..color = Colors.grey
      ..strokeCap = StrokeCap.square
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.height;

    const widthFraction = 0.25;
    final start = (progress * (1 + widthFraction) - widthFraction) * size.width;
    final end = start + widthFraction * size.width;

    final adjustedStart = start % size.width;
    final adjustedEnd = end % size.width;

    if (adjustedEnd > adjustedStart) {
      canvas.drawLine(
        Offset(adjustedStart, size.height / 2),
        Offset(adjustedEnd, size.height / 2),
        animatedPaint,
      );
    } else {
      canvas.drawLine(
        Offset(adjustedStart, size.height / 2),
        Offset(size.width, size.height / 2),
        animatedPaint,
      );
      canvas.drawLine(
        Offset(0, size.height / 2),
        Offset(adjustedEnd, size.height / 2),
        animatedPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
