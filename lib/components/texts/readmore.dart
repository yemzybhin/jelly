import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import '../../utils/fonts.dart';

class ReadMoreText extends StatefulWidget {
  final String text;
  final int trimLength;
  final TextStyle? style;
  final TextStyle? moreStyle;

  const ReadMoreText({
    Key? key,
    required this.text,
    this.trimLength = 150,
    this.style,
    this.moreStyle,
  }) : super(key: key);

  @override
  _ReadMoreTextState createState() => _ReadMoreTextState();
}

class _ReadMoreTextState extends State<ReadMoreText> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final bool shouldTrim = widget.text.length > widget.trimLength;
    final String visibleText = shouldTrim && !_isExpanded
        ? widget.text.substring(0, widget.trimLength).trim()
        : widget.text;

    final String toggleText = shouldTrim
        ? (_isExpanded ? " View less" : " Read more")
        : '';

    return RichText(
      text: TextSpan(
        style: widget.style ?? TextStyle(
            color: CustomColors.white,
            fontFamily: CustomFonts.titiliumWeb_Regular,
            fontSize: 13.5
        ),
        children: [
          TextSpan(text: visibleText),
          if (shouldTrim) TextSpan(
              text: " ...$toggleText",
              style: widget.moreStyle ?? TextStyle(
                  color: CustomColors.white,
                  fontWeight: FontWeight.w900,
                  fontFamily: CustomFonts.titiliumWeb_Bold,
                  fontStyle: FontStyle.italic,
                  fontSize: 13
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                },
            ),
        ],
      ),
    );
  }
}
