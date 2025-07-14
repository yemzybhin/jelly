import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


double height(context , size )=> MediaQuery.of(context).size.height * ( size / 100 );
double width(context , size )=>MediaQuery.of(context).size.width * ( size / 100 );
double BottomHeight(context)=>MediaQuery.of(context).viewInsets.bottom;
double PaddingConstant = 35.0;
// double PaddingConstant2 = 18.0;
// double CardSpacing = 45.0;

SizedBox baseHeight( context) =>  SizedBox(height: MediaQuery.of(context).viewInsets.bottom);
SizedBox RemainingSpace( context ) => SizedBox(height: MediaQuery.of(context).viewInsets.bottom);


class customSize{
  static double heading = 25;
  static double smallarrow = 7;
  static double smalltext = 13;
  static double buttonInsider1 = 11.0;
}
