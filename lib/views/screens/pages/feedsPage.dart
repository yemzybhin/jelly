import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import '../../widget/customVideo.dart';
import '../../../utils/colors.dart';
import '../../../utils/dimensions.dart';

class FeedsPage extends StatefulWidget {
  const FeedsPage({Key? key}) : super(key: key);

  @override
  State<FeedsPage> createState() => _FeedsPageState();
}

class _FeedsPageState extends State<FeedsPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<String> videoUrls = [
    'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
    'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
    'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
  ];

  Future<void> refreshState()async {
    Future.delayed(Duration.zero, (){
      setState(() {
        _currentPage = 0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _pageController,
      scrollDirection: Axis.vertical,
      itemCount: videoUrls.length,
      onPageChanged: (index) {
        setState(() => _currentPage = index);
      },
      itemBuilder: (context, index) {
        return CustomVideoPlayer(
          videoUrl: videoUrls[index],
          key: ValueKey(index),
        );
      },
    );
  }
}
