import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:video_player/video_player.dart';
import '../../components/animation/fadingAnimation.dart';
import '../../components/buttons/CustomButton.dart';
import '../../components/buttons/CustomIconButton.dart';
import '../../components/loaders/doubleBoader.dart';
import '../../utils/colors.dart';
import '../../utils/fonts.dart';
import '../../utils/icons.dart';


class Viewsinglevideo extends StatefulWidget {
  final String path;
  Viewsinglevideo({ required this.path });

  @override
  State<Viewsinglevideo> createState() => _ViewsinglevideoState();
}

class _ViewsinglevideoState extends State<Viewsinglevideo> {
  late VideoPlayerController _controller;
  bool _isMuted = false;
  bool _isPlaying = false;
  bool _isSpeeded = false;
  bool _showControls = true;
  double _sliderValue = 0;
  Timer? _hideTimer;

  @override
  void initState() {
    super.initState();
    if(mounted){
      _controller = VideoPlayerController.file(File(widget.path))
        ..initialize().then((_) {
          setState(() {});
          _controller.play();
          _isPlaying = true;
          _startHideTimer();
        });
      _controller.addListener(() {
        if (!_controller.value.isInitialized) return;
        final pos = _controller.value.position;
        final dur = _controller.value.duration;

        if (dur.inMilliseconds > 0) {
          if (mounted) {
            setState(() {
              _sliderValue = pos.inMilliseconds.toDouble();
            });
          }
          if (_controller.value.position >= _controller.value.duration &&
              !_controller.value.isPlaying) {
            _controller.seekTo(Duration.zero);
            _controller.play();
          }
        }
      });
    }

  }

  @override
  void dispose() {
    _controller.dispose();
    _hideTimer?.cancel();
    super.dispose();
  }

  void _startHideTimer() {
    _hideTimer?.cancel();
    _hideTimer = Timer(const Duration(seconds: 3), () {});
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
        _controller.play();
        _startHideTimer();
      } else {
        _controller.pause();
      }
    });
  }

  void _toggleMute() {
    _onInteraction();
    setState(() {
      _isMuted = !_isMuted;
      _controller.setVolume(_isMuted ? 0 : 1);
    });
  }

  void _toggleSpeed() {
    _onInteraction();
    setState(() {
      _isSpeeded = !_isSpeeded;
      _controller.setPlaybackSpeed(_isSpeeded ? 2.0 : 1.0);
    });
  }

  void _seekBy(Duration offset) {
    _onInteraction();
    final current = _controller.value.position;
    final total = _controller.value.duration;
    Duration newPosition = current + offset;

    if (newPosition < Duration.zero) newPosition = Duration.zero;
    if (newPosition > total) newPosition = total;

    _controller.seekTo(newPosition);
    _controller.play();
  }

  String _format(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final isReady = _controller.value.isInitialized;
    final duration = isReady ? _controller.value.duration.inMilliseconds.toDouble() : 1.0;

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
              Positioned.fill(child: VideoPlayer(_controller))
            else FadingWidget( minOpacity: 0.1,child: Center(child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              spacing: 15,
              children: [
                SvgPicture.asset(CustomIcons.logo, height: 30),
                DoubleLoader(color: Colors.white, size: 10, strokeWidth: 2)
              ],
            ))),

            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [ Colors.transparent, Colors.black],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  AnimatedOpacity(
                    opacity: _showControls ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 300),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(_format(_controller.value.position), style: TextStyle(
                              color: Colors.white,
                              fontFamily: CustomFonts.titiliumWeb_SemiBold,
                              fontSize: 12
                          )),

                          Custom_IconButton(icon: _isPlaying ? CustomIcons.pause : CustomIcons.play, onpressed: _togglePlay ),


                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            spacing: 20,
                            children: [
                              CustomButton(
                                  horizontalPadding: 10,
                                  verticalPadding: 6,
                                  onpressed: _toggleSpeed,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    spacing: 3,
                                    children: [
                                      SvgPicture.asset(CustomIcons.speed, color: Colors.white, height: 20),
                                      Text(_isSpeeded ? "2x" : "1x", style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: CustomFonts.titiliumWeb_SemiBold,
                                          fontSize: 13.5
                                      )),
                                    ],
                                  )
                              ),
                              Custom_IconButton(
                                icon: _isMuted ? CustomIcons.mute : CustomIcons.unmute,
                                onpressed: _toggleMute,
                                iconSize: 17,
                                boxSize: 35,
                                borderRadius: 30,
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      trackHeight: 3,
                      thumbShape: SliderComponentShape.noThumb,
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
                        _controller.seekTo(Duration(milliseconds: value.toInt()));
                        _controller.play();
                      },
                    ),
                  ),
                ],
              ),
            ),
            if (isReady)AnimatedOpacity(
              opacity: !_isPlaying ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 300),
              child: Center(
                child: GestureDetector(
                  onTap: _togglePlay,
                  child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(30),
                      child: SvgPicture.asset(_isPlaying ? CustomIcons.pause : CustomIcons.play, height: 25, color: Colors.white,)
                  ),
                ),
              ),
            ),

            Positioned(
              bottom: 100,
              right: 0,
              child: Custom_IconButton(icon: _showControls ? CustomIcons.expand : CustomIcons.minimize, onpressed: (){
                setState(() {
                  _showControls = !_showControls;
                });
              }),
            ),

          ],
        ),
      ),
    );
  }
}