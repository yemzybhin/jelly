import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../utils/colors.dart';
import '../../utils/icons.dart';
import 'package:animate_do/animate_do.dart' as animations;

class CircleButton extends StatelessWidget {
  final String icon;
  final double iconHeight;
  final double size;
  final Color buttonBackground;
  final bool buttonHasDropShadow;
  final bool iconHasDropShadow;
  final Color iconColor;
  final bool rotate;
  final VoidCallback? onpressed;

  CircleButton({ required this.buttonBackground, this.buttonHasDropShadow = true, this.iconHasDropShadow = true, required this.iconColor, this.onpressed , required this.icon, required this.iconHeight, this.rotate = true, this.size = 75});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onpressed ?? (){
        print('No onPressed provided');
      },
      style: ElevatedButton.styleFrom(
        elevation: buttonHasDropShadow ? 20 : 0,
        shape: const CircleBorder(),
        padding: EdgeInsets.zero,
        backgroundColor: buttonBackground,
        shadowColor: CustomColors.black_30,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Transform.rotate(
        angle: rotate ? 0.3 : 0,
        child: SizedBox(
          width: size,
          height: size,
          child: Center(
            child: PhysicalModel(
              color: Colors.transparent,
              shadowColor: iconColor.withOpacity(0.25),
              elevation: iconHasDropShadow ? 10 : 0,
              shape: BoxShape.circle,
              child: SvgPicture.asset(
                icon,
                height: iconHeight,
                color: iconColor
              ),
            ),
          ),
        ),
      ),
    );
  }
}
