import 'package:flutter/material.dart';

class FadingWidget extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final double minOpacity;
  final bool shouldAnimate;

  const FadingWidget({
    Key? key,
    required this.child,
    this.duration = const Duration(milliseconds: 1000),
    this.minOpacity = 0.2,
    this.shouldAnimate = true,
  }) : super(key: key);

  @override
  State<FadingWidget> createState() => _FadingWidgetState();
}

class _FadingWidgetState extends State<FadingWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _opacityAnimation = Tween<double>(
      begin: 1.0,
      end: widget.minOpacity,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    if (widget.shouldAnimate) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(covariant FadingWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.shouldAnimate != widget.shouldAnimate) {
      if (widget.shouldAnimate) {
        _controller.repeat(reverse: true);
      } else {
        _controller.stop();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: widget.shouldAnimate ? _opacityAnimation : Tween<double>(
        begin: 1.0,
        end: 1,
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      )),
      child: widget.child,
    );
  }
}
