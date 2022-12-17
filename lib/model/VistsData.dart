import 'package:flutter/material.dart';

class VisitsData {
  late String month ;
  late num visits = 0;

  VisitsData();
}class OrderData {
  late String month ;
  late num visits = 0 ;
  late Color color ;

}
class MonthsData {
  String month ;
  int score ;

  MonthsData( this.month, this.score);
}