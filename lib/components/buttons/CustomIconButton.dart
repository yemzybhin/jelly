import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../utils/colors.dart';

class Custom_IconButton extends StatelessWidget {
  final String icon;
  final Color? color;
  final Color? borderColor;
  final double? margin;
  final Color background;
  final double iconSize;
  final double? boxSize;
  final EdgeInsets padding;
  final double borderRadius;
  final double? borderWidth;
  final bool hasborder;
  final bool hasColor;
  VoidCallback onpressed;

  Custom_IconButton({ required this.icon, this.color, this.background = Colors.transparent, required this.onpressed, this.iconSize = 15, this.padding = EdgeInsets.zero, this.borderRadius = 0, this.hasborder = false, this.borderColor, this.borderWidth, this.hasColor = true, this.margin, this.boxSize });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(margin ?? 0),
      child: IconButton(
          onPressed: onpressed,
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(background),
            splashFactory: InkSparkle.splashFactory,
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                side: hasborder ? BorderSide( color: borderColor ?? CustomColors.white_20, width: borderWidth ?? 1) : BorderSide.none
            )),
            minimumSize: MaterialStateProperty.all(Size.zero),
            padding: MaterialStateProperty.all(padding),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          icon: SizedBox(
              height: boxSize ?? iconSize * 2.7,
              width: boxSize ?? iconSize * 2.7,
              child: Center(child: SvgPicture.asset(icon, height: iconSize , color: hasColor ? color ?? Colors.white : null ))
          )
      ),
    );
  }
}
