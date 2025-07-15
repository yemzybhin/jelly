import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:jellyjelly/components/buttons/CustomButton.dart';
import 'package:jellyjelly/routing/router_constants.dart';
import 'package:jellyjelly/utils/colors.dart';
import 'package:jellyjelly/utils/fonts.dart';
import 'package:jellyjelly/utils/icons.dart';
import 'package:jellyjelly/view_models/BasicStates.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class PermissionsPage extends StatefulWidget {
  const PermissionsPage({Key? key}) : super(key: key);

  @override
  State<PermissionsPage> createState() => _PermissionsPageState();
}

class _PermissionsPageState extends State<PermissionsPage> {
  bool cameraPermission = false;
  bool audiosPermission = false;

  void updatePermissions() async {
    cameraPermission = await Permission.camera.isGranted;
    audiosPermission = await Permission.microphone.isGranted;
    setState(() {});
  }

  void checkFirstTime() async {
    var provider = Provider.of<BasicState>(context, listen: false);
    bool firstTime = await provider.getFirstTime();
    if(!firstTime){
      context.pushReplacementNamed(RouteConstants.rootPage);
    }
  }

  @override
  void initState() {
    super.initState();
    if(mounted){
      checkFirstTime();
      updatePermissions();
    }
  }


  @override
  Widget build(BuildContext context) {
    BasicState basicState = context.watch<BasicState>();
    return Scaffold(
      backgroundColor: CustomColors.primaryBackground,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          spacing: 30,
          children: [
            Text("Welcome to Jelly", style: TextStyle(
              color: Colors.white,
              fontFamily: CustomFonts.ranchers,
              fontSize: 25
            )),

            !cameraPermission ?
            CustomButton(
                onpressed: () async {
                  await Permission.camera.request();
                  updatePermissions();
                },
                backgroundColor: CustomColors.white_10,
                horizontalPadding: 20,
                verticalPadding: 7,
                borderRadius: 30,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  spacing: 10,
                  children: [
                    Text("Give Camera Permission", style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontFamily: CustomFonts.titiliumWeb_SemiBold)),
                    RotatedBox(
                        quarterTurns: 2,
                        child: SvgPicture.asset(CustomIcons.back_arrow , height: 10, color: Colors.white,)
                    )
                  ],
                )) : SizedBox.shrink(),
            !audiosPermission ?
            CustomButton(
                onpressed: () async {
                  await Permission.microphone.request();
                  updatePermissions();
                },
                backgroundColor: CustomColors.white_10,
                horizontalPadding: 20,
                verticalPadding: 7,
                borderRadius: 30,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  spacing: 10,
                  children: [
                    Text("Give Audio Videos Permission", style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontFamily: CustomFonts.titiliumWeb_SemiBold)),
                    RotatedBox(
                        quarterTurns: 2,
                        child: SvgPicture.asset(CustomIcons.back_arrow , height: 10, color: Colors.white,)
                    )
                  ],
                )) : SizedBox.shrink(),

            cameraPermission && audiosPermission ?
            CustomButton(
                onpressed: () async {
                  await basicState.updateFirstTime(false);
                  context.pushReplacementNamed(RouteConstants.rootPage);
                },
                backgroundColor: CustomColors.white,
                horizontalPadding: 30,
                verticalPadding: 10,
                borderRadius: 30,
                child: Text("Launch Jelly", style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontFamily: CustomFonts.titiliumWeb_Bold)
                )
            ): SizedBox.shrink(),

          ],
        ),
      ),
    );
  }
}