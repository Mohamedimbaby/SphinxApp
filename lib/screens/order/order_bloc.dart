import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saleing/firebase_service.dart';
import 'package:saleing/model/order.dart';

class OrderBloc extends Cubit<PlaceOrderStatus>{
OrderBloc():super(PlaceOrderStatus());
    placeOrder (Order order)async{
      try
      {
       await FirebaseService.placeOrder(order);
       emit(SuccessPlaceOrderStatus());
      }
      catch(e){
        emit(ErrorPlaceOrderStatus(e.toString())) ;
      }
      }
      getOrders ()async{
      try
      {
       List<Order> orders = await FirebaseService.getOrders();
       print(orders);
       emit(SuccessGetOrderStatus(orders));
      }
      catch(e){
        emit(ErrorPlaceOrderStatus(e.toString())) ;
      }
      }

  }
  enum Status{
  loading , error , success
  }

class PlaceOrderStatus {
}

class ErrorPlaceOrderStatus extends PlaceOrderStatus{
  String error ;

  ErrorPlaceOrderStatus(this.error);
}
class SuccessPlaceOrderStatus extends PlaceOrderStatus{}
class SuccessGetOrderStatus extends PlaceOrderStatus{
  List<Order> orders ;

  SuccessGetOrderStatus(this.orders);
}