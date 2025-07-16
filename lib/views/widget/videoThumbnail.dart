import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:jellyjelly/services/splitvideoservice.dart';
import 'package:jellyjelly/utils/fonts.dart';
import 'package:jellyjelly/view_models/BasicStates.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import '../../components/buttons/CustomButton.dart';
import '../../components/loaders/doubleBoader.dart';
import '../../main.dart';
import '../../routing/router_constants.dart';
import '../../utils/colors.dart';
import '../../utils/dimensions.dart';
import '../../utils/icons.dart';

class Videothumbnail extends StatefulWidget {
  final String front;
  final String back;

  Videothumbnail({ required this.front, required this.back });

  @override
  State<Videothumbnail> createState() => _VideothumbnailState();
}

class _VideothumbnailState extends State<Videothumbnail> {
  bool isHighlighted = false;

  Future<String> _getThumbnailPath(String videoUrl) async {
    final tempDir = await getTemporaryDirectory();
    final hash = md5.convert(utf8.encode(videoUrl)).toString();
    return '${tempDir.path}/thumb_$hash.jpg';
  }

  Future<Map<String, File?>> getOrGenerateThumbnail(String front, String back) async {
    final thumbnailPath1 = await _getThumbnailPath(front);
    final thumbnailPath2 = await _getThumbnailPath(back);

    final generatedPath1 = await VideoThumbnail.thumbnailFile(
      video: front,
      thumbnailPath: thumbnailPath1,
      imageFormat: ImageFormat.JPEG,
      maxWidth: 200,
      quality: 100,
    );
    final generatedPath2 = await VideoThumbnail.thumbnailFile(
      video: back,
      thumbnailPath: thumbnailPath2,
      imageFormat: ImageFormat.JPEG,
      maxWidth: 200,
      quality: 100,
    );
    if (generatedPath1 != null) {
      return {
        "front" : generatedPath1 == null ? null : File(generatedPath1!),
        "back" : generatedPath2 == null ? null : File(generatedPath2!)
      };
    }
    return {
      "front" : null,
      "back" : null
    };
  }


  @override
  Widget build(BuildContext context) {
    BasicState basicState = context.watch<BasicState>();
    print(widget.front);
    return FutureBuilder<Map<String, File?>>(
      future: getOrGenerateThumbnail( widget.front, widget.back ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Padding(
            padding: const EdgeInsets.all(30),
            child: Center(child: DoubleLoader(color: Colors.white, size: 10, strokeWidth: 1,)),
          );
        }

        if (snapshot.hasData && snapshot.data != null) {
          File? frontImage = snapshot.data!["front"];
          File? backImage = snapshot.data!["back"];

          return CustomButton(
            borderRadius: 15,
            onpressed: (){
              navigatorKey.currentContext?.pushNamed(
                  RouteConstants.fullView,
                  extra: {
                    "splitVideo": SplitVideoItem(
                        frontPath: widget.front,
                        backPath: widget.back
                    )
                  }
              );
            },
            child: Container(
              padding: EdgeInsets.all(1),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20)
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Column(
                      children: [
                        frontImage != "" ?
                        Expanded(
                          child: RotatedBox(
                            quarterTurns: 1,
                            child: Image.file(
                              frontImage!,
                              height: double.infinity,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ) : Center(
                          child: Text("Front camera\nfailed", style: TextStyle(
                            color: Colors.white,
                            fontFamily: CustomFonts.titiliumWeb_Regular,
                            fontSize: 10
                          ),)
                        ),

                        backImage != "" ?
                        Expanded(
                          child: RotatedBox(
                            quarterTurns: 1,
                            child: Image.file(
                              backImage!,
                              height: double.infinity,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ) : Center(
                            child: Text("Back camera\nfailed", style: TextStyle(
                                color: Colors.white,
                                fontFamily: CustomFonts.titiliumWeb_Regular,
                                fontSize: 10
                            ),)
                        ),
                      ],
                    ),
                    SvgPicture.asset(
                        CustomIcons.play,
                        color: CustomColors.white,
                        height: 35
                    )
                  ],
                ),
              ),
            ),
          );
        }
        return SizedBox(
          width: double.maxFinite,
          height: height(context, 20),
          child: Center(child: Icon(Icons.error, color: CustomColors.red, size: 25)),
        );
      },
    );
  }
}