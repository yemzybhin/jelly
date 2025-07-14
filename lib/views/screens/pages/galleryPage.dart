import 'package:flutter/material.dart';
import '../../../utils/colors.dart';


class Gallerypage extends StatefulWidget {
  const Gallerypage({Key? key}) : super(key: key);

  @override
  State<Gallerypage> createState() => _GallerypageState();
}

class _GallerypageState extends State<Gallerypage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.primaryBackground,
    );
  }
}
