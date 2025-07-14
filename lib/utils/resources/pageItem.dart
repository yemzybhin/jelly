import 'package:flutter/material.dart';
import '../../views/screens/pages/feedsPage.dart';
import '../../views/screens/pages/galleryPage.dart';
import '../../views/screens/pages/recordingPage.dart';
import '../icons.dart';

class PageItem{
  final String title;
  final Widget widget;
  final String icon;
  final bool showDot;

  PageItem( { required this.title, required this.widget, required this.icon, this.showDot = false});

  static List<PageItem> pages = [
    PageItem(title: "Feeds", widget: FeedsPage(), icon: CustomIcons.feed),
    PageItem(title: "Record", widget: Recordingpage(), icon: CustomIcons.camera),
    PageItem(title: "Gallery", widget: Gallerypage(), icon: CustomIcons.gallery),
  ];
}