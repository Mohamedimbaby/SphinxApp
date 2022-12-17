import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:saleing/firebase_service.dart';
import 'package:saleing/model/VistsData.dart';
import 'package:saleing/model/item.dart';
import 'package:saleing/model/order.dart';

import '../../../colors.dart';
int? maximumVisitsForDay = 5 ;

class ReportBloc extends Cubit<ReportState> {
  ReportBloc() : super(ReportState([],[]));

  getCompanyReport() async {
    try {
    List<Visit>? visits =  await FirebaseService.getVisits();
    List<Order>? orders =  await FirebaseService.getAllOrders();
    if(visits != null && visits.isNotEmpty){
      List<VisitsData> resultVisits = _filterVisits(visits);
      List<OrderData> orderReport = _filterOrders(orders);
      emit(ReportState(resultVisits , orderReport));
    }

    } catch (e) {
      // TODO catch section
    }
  }
Map<int , String > months = {
  1:'Jan',
  2:'Feb',
  3:'Mar',
  4:'Apr',
  5:'May',
  6:'Jun',
  7:'Jul',
  8:'Aug',
  9:'Sep',
  10:'Oct',
  11:'Nov',
  12:'Dec',
};

  List<VisitsData> _filterVisits(List<Visit> visits) {
    List<VisitsData> visitsData = [];
    for(int month = 1 ; month < 13 ;month ++){

      VisitsData visitData = VisitsData();
      visitData.month= months[month]!;
      visits.forEach((element) {
        DateTime customDate = DateFormat("dd-MM-yyyy").parse(element.date);
        if(customDate.month == month){
          visitData.visits++;
        }
      });
      visitsData.add(visitData);
    }

    return visitsData;
  }
  List<OrderData> _filterOrders(List<Order> orders) {
    List<OrderData> visitsData = [];
    for(int month = 1 ; month < 13 ;month ++){

      OrderData visitData = OrderData();
      visitData.month= months[month]!;
      orders.forEach((element) {

        DateTime customDate = DateFormat("dd-MM-yyyy").parse(element.date);
        if(customDate.month == month){
          visitData.visits++;
        }

      });
      visitData.color = colors[Random().nextInt(colors.length-1)];
      visitsData.add(visitData);
    }

    return visitsData;
  }

}
class ReportModel {
  String date ;
  double percentage ;
  Color color ;

  ReportModel(this.date, this.percentage, this.color);
}
class ReportState {
  List <VisitsData> visits = [];
  List <OrderData> orders = [];

  ReportState(this.visits, this.orders);
}
