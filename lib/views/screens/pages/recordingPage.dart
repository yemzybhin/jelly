import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class Recordingpage extends StatefulWidget {
  const Recordingpage({Key? key}) : super(key: key);

  @override
  State<Recordingpage> createState() => _RecordingpageState();
}

class _RecordingpageState extends State<Recordingpage> {
  final channel = MethodChannel('dual_camera_channel');

  void _startRecording() async {
    await channel.invokeMethod('startRecording');
  }

  void _stopRecording() async {
    final filePath = await channel.invokeMethod('stopRecording');
    print('------------------------> Recording saved to $filePath');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          AndroidView(
            viewType: 'combined_camera_view',
            layoutDirection: TextDirection.ltr,
          ),
          Positioned(
            bottom: 20,
            right: 0,
            left: 0,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              spacing: 50,
              children: [
                IconButton(onPressed: (){
                  _startRecording();
                }, icon: Icon( Icons.record_voice_over, size: 30,)),
                IconButton(onPressed: (){
                  _stopRecording();
                }, icon: Icon( Icons.video_call_outlined, size: 30,)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}