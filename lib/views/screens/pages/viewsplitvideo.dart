import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jellyjelly/utils/dimensions.dart';
import 'package:video_player/video_player.dart';
import 'package:go_router/go_router.dart';
import '../../../components/animation/fadingAnimation.dart';
import '../../../components/buttons/CustomButton.dart';
import '../../../components/buttons/CustomIconButton.dart';
import '../../../components/loaders/doubleBoader.dart';
import '../../../services/splitvideoservice.dart';
import '../../../utils/colors.dart';
import '../../../utils/fonts.dart';
import '../../../utils/icons.dart';

class ViewSplitVideo extends StatefulWidget {
  final SplitVideoItem splitVideo;

  ViewSplitVideo({required this.splitVideo});

  @override
  State<ViewSplitVideo> createState() => _ViewSplitVideoState();
}

class _ViewSplitVideoState extends State<ViewSplitVideo> {
  late VideoPlayerController _frontController;
  late VideoPlayerController _backController;
  bool _isMuted = false;
  bool _isPlaying = false;
  bool _isSpeeded = false;
  bool _showControls = true;
  double _sliderValue = 0;
  Timer? _hideTimer;

  @override
  void initState() {
    super.initState();
    _initVideos();
  }

  Future<void> _initVideos() async {
    _frontController = VideoPlayerController.file(File(widget.splitVideo.frontPath));
    _backController = VideoPlayerController.file(File(widget.splitVideo.backPath));

    await Future.wait([
      _frontController.initialize(),
      _backController.initialize(),
    ]);

    if (!mounted) return;

    _frontController.setLooping(true);
    _backController.setLooping(true);
    _backController.setVolume(0);

    _frontController.addListener(_syncListener);
    _frontController.play();
    _backController.play();

    setState(() => _isPlaying = true);
    _startHideTimer();
  }

  void _syncListener() {
    if (!_frontController.value.isInitialized) return;

    final frontPos = _frontController.value.position;
    final backPos = _backController.value.position;

    if ((backPos - frontPos).inMilliseconds.abs() > 50) {
      _backController.seekTo(frontPos);
    }

    if (mounted) {
      setState(() => _sliderValue = frontPos.inMilliseconds.toDouble());
    }
  }

  @override
  void dispose() {
    _frontController.dispose();
    _backController.dispose();
    _hideTimer?.cancel();
    super.dispose();
  }

  void _startHideTimer() {
    _hideTimer?.cancel();
    _hideTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) setState(() => _showControls = false);
    });
  }

  void _onInteraction() {
    setState(() => _showControls = true);
    _startHideTimer();
  }

  void _togglePlay() {
    _onInteraction();
    setState(() {
      _isPlaying = !_isPlaying;
      if (_isPlaying) {
        _frontController.play();
        _backController.play();
      } else {
        _frontController.pause();
        _backController.pause();
      }
    });
  }

  void _toggleMute() {
    _onInteraction();
    setState(() {
      _isMuted = !_isMuted;
      _frontController.setVolume(_isMuted ? 0 : 1);
    });
  }

  void _toggleSpeed() {
    _onInteraction();
    setState(() {
      _isSpeeded = !_isSpeeded;
      final speed = _isSpeeded ? 2.0 : 1.0;
      _frontController.setPlaybackSpeed(speed);
      _backController.setPlaybackSpeed(speed);
    });
  }

  void _seekBy(Duration offset) {
    final current = _frontController.value.position;
    Duration newPosition = current + offset;

    if (newPosition < Duration.zero) newPosition = Duration.zero;
    if (newPosition > _frontController.value.duration) {
      newPosition = _frontController.value.duration;
    }

    _frontController.seekTo(newPosition);
    _backController.seekTo(newPosition);
    if (_isPlaying) {
      _frontController.play();
      _backController.play();
    }
  }

  String _format(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final isReady = _frontController.value.isInitialized;
    final duration = isReady ? _frontController.value.duration.inMilliseconds.toDouble() : 1.0;

    return Scaffold(
      backgroundColor: CustomColors.primaryBackground,
      body: GestureDetector(
        onTap: _onInteraction,
        onDoubleTapDown: (details) {
          final width = MediaQuery.of(context).size.width;
          if (details.localPosition.dx < width / 2) {
            _seekBy(const Duration(seconds: -10));
          } else {
            _seekBy(const Duration(seconds: 10));
          }
        },
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            if (isReady)
              Column(
                children: [
                  Expanded(child: RotatedBox(quarterTurns: 1, child: VideoPlayer(_frontController))),
                  Expanded(child: RotatedBox(quarterTurns: 1, child: VideoPlayer(_backController))),
                ],
              )
            else
              FadingWidget(
                minOpacity: 0.1,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(CustomIcons.logo, height: 30),
                      SizedBox(height: 15),
                      DoubleLoader(color: Colors.white, size: 10, strokeWidth: 2)
                    ],
                  ),
                ),
              ),

            if (isReady)
              AnimatedOpacity(
                opacity: !_isPlaying ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: GestureDetector(
                  onTap: _togglePlay,
                  child: SizedBox(
                    height: height(context, 100),
                    width: width(context, 100),
                    child: Center(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(30),
                        child: SvgPicture.asset(
                          _isPlaying ? CustomIcons.pause : CustomIcons.play,
                          height: 25,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

            AnimatedOpacity(
              opacity: _showControls ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 300),
              child: _buildControls(duration),
            ),
            Positioned(
              top: 15,
              left: 15,
              child: SafeArea(
                child: Custom_IconButton(
                  icon: CustomIcons.back_arrow,
                  onpressed: () => context.pop(),
                  iconSize: 20,
                  boxSize: 45,
                  borderRadius: 20,
                  color: Colors.white,
                  background: CustomColors.black_30,
                ),
              ),
            ),

            // Top Right Logo
            Positioned(
              top: 15,
              right: 15,
              child: SafeArea(
                child: SvgPicture.asset(CustomIcons.logo, height: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControls(double duration) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _format(_frontController.value.position),
                style: TextStyle(color: Colors.white, fontFamily: CustomFonts.titiliumWeb_SemiBold, fontSize: 12),
              ),
              Custom_IconButton(icon: _isPlaying ? CustomIcons.pause : CustomIcons.play, onpressed: _togglePlay ),
              Row(
                children: [
                  CustomButton(
                    horizontalPadding: 10,
                    verticalPadding: 6,
                    onpressed: _toggleSpeed,
                    child: Row(
                      children: [
                        SvgPicture.asset(CustomIcons.speed, color: Colors.white, height: 20),
                        SizedBox(width: 3),
                        Text(
                          _isSpeeded ? "2x" : "1x",
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: CustomFonts.titiliumWeb_SemiBold,
                            fontSize: 13.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 10),
                  Custom_IconButton(
                    icon: _isMuted ? CustomIcons.mute : CustomIcons.unmute,
                    onpressed: _toggleMute,
                    iconSize: 17,
                    boxSize: 35,
                    borderRadius: 30,
                  ),
                  SizedBox(width: 10),
                  Custom_IconButton(
                    icon: _showControls ? CustomIcons.expand : CustomIcons.minimize,
                    onpressed: () => setState(() => _showControls = !_showControls),
                  ),
                ],
              ),
            ],
          ),
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 3,
            thumbColor: Colors.white,
            overlayShape: SliderComponentShape.noOverlay,
            activeTrackColor: Colors.white,
            inactiveTrackColor: CustomColors.white_20,
          ),
          child: Slider(
            value: _sliderValue.clamp(0, duration),
            min: 0,
            max: duration,
            onChanged: (value) {
              _onInteraction();
              setState(() => _sliderValue = value);
              final newPos = Duration(milliseconds: value.toInt());
              _frontController.seekTo(newPos);
              _backController.seekTo(newPos);
              _frontController.play();
              _backController.play();
            },
          ),
        ),
      ],
    );
  }
}
