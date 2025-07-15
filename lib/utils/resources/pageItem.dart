import 'package:flutter/material.dart';
import 'package:jellyjelly/views/screens/pages/spltCameraView.dart';
import '../../views/screens/pages/feedsPage.dart';
import '../../views/screens/pages/galleryPage.dart';
import '../icons.dart';

class PageItem{
  final String title;
  final Widget widget;
  final String icon;
  final bool showDot;

  PageItem( { required this.title, required this.widget, required this.icon, this.showDot = false});

  static List<PageItem> pages = [
    PageItem(title: "Feeds", widget: FeedsPage(), icon: CustomIcons.feed),
    PageItem(title: "Record", widget: SplitCameraView(), icon: CustomIcons.camera),
    PageItem(title: "Gallery", widget: Gallerypage(), icon: CustomIcons.gallery),
  ];
}