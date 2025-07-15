import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jellyjelly/components/animation/fadingAnimation.dart';
import 'package:jellyjelly/components/buttons/CustomIconButton.dart';
import 'package:jellyjelly/utils/colors.dart';
import 'package:jellyjelly/utils/fonts.dart';
import 'package:jellyjelly/utils/icons.dart';
import 'package:jellyjelly/views/widget/videoThumbnail.dart';
import 'package:path/path.dart' as p;
import '../../../components/loaders/doubleBoader.dart';
import '../../../routing/router_constants.dart';
import '../../../services/splitvideoservice.dart';
import '../../../utils/dimensions.dart';

class Gallerypage extends StatefulWidget {
  const Gallerypage({Key? key}) : super(key: key);

  @override
  State<Gallerypage> createState() => _GallerypageState();
}

class _GallerypageState extends State<Gallerypage> {
  late Future<List<SplitVideoItem>> futureRecordings;

  Future<List<SplitVideoItem>> getVideos() async {
    await SplitVideoService.cleanInvalidRecordings();
    final validSplits = await SplitVideoService.getSplitVideoItems();
    return validSplits;
  }

  @override
  void initState() {
    super.initState();
    futureRecordings = getVideos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.primaryBackground,
      appBar: AppBar(
        centerTitle: false,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        title: Padding(
          padding: EdgeInsets.only(right: PaddingConstant, left: PaddingConstant, top: 20),
          child: Text(
            'Gallery',
            style: TextStyle(
              color: CustomColors.white,
              fontSize: 27,
              fontFamily: CustomFonts.ranchers,
            ),
          ),
        ),
        elevation: 0.3,
        toolbarHeight: 70,
      ),
      body: FutureBuilder<List<SplitVideoItem>>(
        future: futureRecordings,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return  Center(child: FadingWidget( minOpacity: 0.1,child: Center(child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              spacing: 15,
              children: [
                SvgPicture.asset(CustomIcons.logo, height: 20),
                DoubleLoader(color: Colors.white, size: 10, strokeWidth: 2)
              ],
            ))));
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final items = snapshot.data ?? [];

          if (items.isEmpty) {
            return const Center(child: Text("No recordings found.", style: TextStyle(
              color: Colors.white,
              fontFamily: CustomFonts.titiliumWeb_SemiBold,
              fontSize: 15
            ),));
          }

          return Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: PaddingConstant),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                mainAxisSpacing: 15,
                crossAxisSpacing: 15
              ),
              itemCount: items.length,
              itemBuilder: (context, index) {
                return Stack(
                  children: [
                    Videothumbnail(front: items[index].frontPath, back: items[index].backPath ),
                    Positioned(
                      bottom: 5,
                      left: 0,
                      child: Custom_IconButton(icon: CustomIcons.delete, onpressed: (){
                        SplitVideoService.deleteSplitVideo(items[index]);
                      }, boxSize: 40, iconSize: 30, background: CustomColors.black_30, borderRadius: 30),
                    )
                  ],
                );
              },
            ),
          );

        },
      ),
    );
  }
}
