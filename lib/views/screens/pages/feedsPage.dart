import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jellyjelly/utils/lottie.dart';
import 'package:jellyjelly/view_models/BasicStates.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../../../components/animation/fadingAnimation.dart';
import '../../../components/loaders/doubleBoader.dart';
import '../../../utils/icons.dart';
import '../../widget/customVideo.dart';

class FeedsPage extends StatefulWidget {
  const FeedsPage({Key? key}) : super(key: key);

  @override
  State<FeedsPage> createState() => _FeedsPageState();
}

class _FeedsPageState extends State<FeedsPage> {
  int _currentPage = 0;
  final PageController _pageController = PageController();

  void fetchJellies() async {
    var provider = Provider.of<BasicState>(context, listen: false);
    await provider.fetchJellies(context);
  }

  @override
  void initState() {
    super.initState();
    if(mounted) fetchJellies();
  }

  @override
  Widget build(BuildContext context) {
    BasicState basicState = context.watch<BasicState>();
    return Stack(
      alignment: Alignment.center,
      children: [
        basicState.jellies != null ?
        PageView.builder(
          controller: _pageController,
          scrollDirection: Axis.vertical,
          itemCount: basicState.jellies!.length,
          onPageChanged: (index) {
            setState(() => _currentPage = index);
          },
          itemBuilder: (context, index) {
            return CustomVideoPlayer(
              jelly: basicState.jellies![index],
              key: ValueKey(index),
            );
          },
        ) : PageView.builder(
          controller: _pageController,
          scrollDirection: Axis.vertical,
          itemCount: 1,
          onPageChanged: (index) {
            setState(() => _currentPage = index);
          },
          itemBuilder: (context, index) {
            return Center(
              child: FadingWidget( minOpacity: 0.1,child: Center(child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                spacing: 15,
                children: [
                  SvgPicture.asset(CustomIcons.logo, height: 30),
                  DoubleLoader(color: Colors.white, size: 10, strokeWidth: 2)
                ],
              )))
            );
          },
        ),
        Positioned( right: 0, child: 
        Opacity( opacity: 0.3, child: Lottie.asset(CustomLottie.hand_scroll, height: 100,)))
      ],
    );
  }
}
