import 'package:flutter/material.dart';

class Responsive extends StatelessWidget {
  final Widget mobile;
  final Widget desktop;

  const Responsive({
    Key? key,
    required this.mobile,
    required this.desktop,
  }) : super(key: key);

  // This isMobile, isDesktop help us later
  static bool isMobile(BuildContext context) => MediaQuery.of(context).size.width < 850;
  static bool isDesktop(BuildContext context) => MediaQuery.of(context).size.width >= 1100;

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    //  If our width is more then 1100 then we consider it a desktop
    if(_size.width >= 1100){
      return desktop;
    }
    //  If width it less than 1100 and more than 850 we consider it as tablet
    //  Or less then that we called it mobile
    else {
      return mobile;
    }
  }


}