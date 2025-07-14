import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart' as animations;
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../../utils/colors.dart';
import '../../utils/resources/pageItem.dart';
import '../../view_models/BasicStates.dart';

class Rootpage extends StatefulWidget {
  @override
  State<Rootpage> createState() => _RootpageState();
}

class _RootpageState extends State<Rootpage> {

  void _onItemTapped(int index) {
    Provider.of<BasicState>(context, listen: false).setCurrentIndex(index);
  }

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    BasicState basicState = context.watch<BasicState>();
    return Scaffold(
      backgroundColor: CustomColors.primaryBackground,
      body: PageItem.pages[basicState.currentIndex].widget,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 0,
        unselectedFontSize: 0,
        currentIndex: basicState.currentIndex,
        onTap: _onItemTapped,
        backgroundColor: CustomColors.primaryBackground,
        elevation: 4,
        items: [
          ...List.generate( PageItem.pages.length, ( index){
            return _buildNavItem( index, PageItem.pages[index].icon);
          }).toList()

        ],
    ),
    );
  }

  Widget _buildNavIcon({
    required String icon,
    required bool isSelected
  }) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        spacing: 7,
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: SvgPicture.asset(
              icon,
              key: ValueKey(isSelected),
              height: isSelected ? 30 : 22,
              color: isSelected
                  ? Colors.white
                  : CustomColors.white_60,
            ),
          ),
          if(isSelected)
          AnimatedOpacity(
            opacity: isSelected ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 200),
            child: Container(
              height: 7.5,
              width: 7.5,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  color: CustomColors.white,
                  width: 2.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem(
      int index,
      String icon) {
    return BottomNavigationBarItem(
      label: '',
      icon: _buildNavIcon(
        icon: icon,
        isSelected:  Provider.of<BasicState>(context, listen: false).currentIndex == index,
      ),
    );
  }

}
