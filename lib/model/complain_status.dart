import 'package:flutter/material.dart';

class ComplainStatus {
  String icon ; 
  String status ;
  Color color ;

  ComplainStatus(this.icon, this.status, this.color);
  static String getIcon(String status){
   return complainStatus.where((element) => element.status ==status.toLowerCase()).first.icon;
  }
   static Color getColor(String status){
   return complainStatus.where((element) => element.status ==status.toLowerCase() ).first.color;
  }
}class OrderStatus {
  String icon ;
  String status ;
  Color color ;

  OrderStatus(this.icon, this.status, this.color);
  static String getIcon(String status){
   return orderStatus.where((element) => element.status ==status.toLowerCase()).first.icon;
  }
   static Color getColor(String status){
   return orderStatus.where((element) => element.status ==status.toLowerCase() ).first.color;
  }
}
List<ComplainStatus> complainStatus = [
  ComplainStatus("assets/pending.jpg", "pending", Colors.blue ),
  ComplainStatus("assets/pending.jpg", "seen", Colors.blueGrey ),
  ComplainStatus("assets/pending.jpg", "accepted", Colors.green ),
  ComplainStatus("assets/pending.jpg", "rejected", Colors.red ),
  ComplainStatus("assets/pending.jpg", "assignedTo", Colors.deepOrangeAccent ),
];
List<OrderStatus> orderStatus = [
  OrderStatus("assets/pending.jpg", "pending", Colors.blue ),
  OrderStatus("assets/pending.jpg", "preparing", Colors.deepOrangeAccent ),
  OrderStatus("assets/pending.jpg", "on it's way", Colors.blueAccent ),
  OrderStatus("assets/pending.jpg", "delivered", Colors.green ),
  OrderStatus("assets/pending.jpg", "cancelled", Colors.red ),
];
Map<String , Color > statusColors = {
  "pending" : Colors.blue ,
  "seen" : Colors.blueGrey ,
  "accepted" : Colors.green ,
  "rejected" : Colors.red ,
  "assignedTo" : Colors.deepOrangeAccent ,
};