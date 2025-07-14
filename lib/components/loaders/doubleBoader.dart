import 'package:flutter/material.dart';


class DoubleLoader extends StatelessWidget {
  final Color color;
  final double size;
  final double strokeWidth;
  DoubleLoader({ required this.color, required this.size, required this.strokeWidth});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          height: size * 2,
          width: size * 2,
          child: CircularProgressIndicator(
            color: color,
            strokeWidth: strokeWidth,
            strokeCap: StrokeCap.round,
          ),
        ),
        SizedBox(
          height: size,
          width: size,
          child: Center(
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationY(3.14159),
              child: CircularProgressIndicator(
                color: color,
                strokeWidth: strokeWidth,
                strokeCap: StrokeCap.round,
              ),
            ),
          )
          ,
        )
      ],
    );
  }
}
