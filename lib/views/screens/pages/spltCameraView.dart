import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jellyjelly/components/buttons/CustomButton.dart';
import 'package:jellyjelly/view_models/BasicStates.dart';
import 'package:jellyjelly/views/widget/timeSelector.dart';
import 'package:provider/provider.dart';
import 'package:timer_count_down/timer_count_down.dart' as Countdown;
import '../../../utils/colors.dart';
import '../../../utils/fonts.dart';

class SplitCameraController {
  static const MethodChannel _channel = MethodChannel('split_camera_channel');

  static Future<void> startRecording() async {
    await _channel.invokeMethod('startRecording');
  }

  static Future<void> stopRecording() async {
    await _channel.invokeMethod('stopRecording');
  }
}


class SplitCameraView extends StatefulWidget {
  const SplitCameraView({super.key});

  @override
  State<SplitCameraView> createState() => _SplitCameraViewState();
}

class _SplitCameraViewState extends State<SplitCameraView> {
  int _time = 15;
  bool recordingStarted = false;

  @override
  void initState() {
    super.initState();

    if(mounted){
      recordingStarted = false;
    }
  }
  @override
  Widget build(BuildContext context) {
    BasicState basicState = context.watch<BasicState>();
    const String viewType = 'split-camera-view';

    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Center(
            child: Text("Jelly is Preparing Camera\nPlease wait", textAlign: TextAlign.center,style: TextStyle(
                color: Colors.white,
                fontFamily: CustomFonts.titiliumWeb_SemiBold,
                fontSize: 13
            ),),
          ),
          Column(
            children: [
              Expanded(
                child: AndroidView(
                  viewType: viewType,
                  layoutDirection: TextDirection.ltr,
                ),
              ),
            ],
          ),
          if( recordingStarted )
          Align(
            alignment: Alignment.center,
            child: Countdown.Countdown(
                seconds: _time,
                build: (BuildContext context, double time) => Container(
                  padding: EdgeInsets.all(25),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: CustomColors.white_70, width: 1)
                  ),
                  child: Text("${time.toInt()}", style: TextStyle(
                      color: CustomColors.white,
                      fontFamily: CustomFonts.titiliumWeb_SemiBold,
                      fontSize: 30,
                      decoration: TextDecoration.none
                  ),),
                ),
                interval: Duration(milliseconds: 1000),
                onFinished: () async {
                  await SplitCameraController.stopRecording();
                  setState(() {
                    recordingStarted = false;
                    _time = 0;
                  });
                  basicState.setCurrentIndex(2);
                }
            ),
          ),

          !recordingStarted ? Positioned(
            bottom: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 100,
                  width: 400,
                  child: HorizontalWheelSelector(
                    items: [5, 10, 15, 20, 25],
                    onSelected: (value) {
                      setState(() {
                        _time = value;
                      });
                      print(_time);
                    },
                  ),
                ),


                CustomButton(
                    onpressed: (){
                      if( recordingStarted ) return;
                      SplitCameraController.startRecording();
                      setState(() {
                        recordingStarted = true;
                        if(_time == 0) _time = 15;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 2
                        )
                      ),
                      child: CircleAvatar(
                        radius: 30,
                        backgroundColor: CustomColors.red,
                      ),
                    )
                ),
              ],
            ),
          ) :
              Positioned(
                top: 30,
                  left: 30,
                  child: SafeArea(
                    child: CircleAvatar(
                      backgroundColor: CustomColors.red,
                      radius: 5
                    ),
                  )
              )
        ],
      )
    );
  }
}
