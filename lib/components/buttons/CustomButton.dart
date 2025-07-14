import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  VoidCallback onpressed;
  final VoidCallback? onLongPressed;
  final Color backgroundColor;
  final double borderRadius;
  final double verticalPadding;
  final double horizontalPadding;
  final bool hasBorder;
  final BorderRadius? borderRadius2;
  final EdgeInsets? buttonMargin;
  final Color borderColor;
  final double borderwidth;
  final Widget? overlay;
  final Widget child;
  final Alignment? overlayAlign;
  CustomButton({ required this.onpressed, required this.child, this.backgroundColor = Colors.transparent, this.borderRadius = 10, this.verticalPadding = 0, this.horizontalPadding = 0, this.hasBorder = false, this.borderColor = Colors.white, this.borderwidth = 1, this.borderRadius2, this.overlay, this.buttonMargin, this.overlayAlign, this.onLongPressed});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: buttonMargin ?? EdgeInsets.zero,
          child: TextButton(
              style:  TextButton.styleFrom(
                backgroundColor: backgroundColor,
                shape: RoundedRectangleBorder(
                    borderRadius: borderRadius2 ?? BorderRadius.circular(borderRadius),
                    side : hasBorder ? BorderSide( color: borderColor , width: borderwidth) : BorderSide.none
                ),
                minimumSize: Size.zero,
                padding: EdgeInsets.symmetric(vertical: verticalPadding , horizontal: horizontalPadding),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              onLongPress: onLongPressed ?? (){},
              onPressed: onpressed, child: child),
        ),
        overlay != null ?
        Align(
            alignment: overlayAlign ?? Alignment.topRight,
            child: overlay!
        ) : SizedBox(),
      ],
    );
  }
}

