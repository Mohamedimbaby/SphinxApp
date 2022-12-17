import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/subjects.dart';
import 'package:saleing/colors.dart';
import 'package:saleing/model/complain.dart';
import 'package:saleing/model/complain_status.dart';
import 'package:saleing/model/order.dart';
import 'package:saleing/screens/order/order_bloc.dart';
import 'package:saleing/styles.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  BehaviorSubject<List<Complain>> rxComplains = BehaviorSubject();
  OrderBloc orderBloc =OrderBloc ();

  @override
  void initState() {
    orderBloc.getOrders();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderBloc,PlaceOrderStatus>(
            bloc: orderBloc,
            builder: (context, state) {
              if(state is SuccessGetOrderStatus)
             {
               if(state.orders.isNotEmpty)
              {
                return ListView.builder(
                  itemCount: state.orders.length ,
                  itemBuilder: (c , index){
                    return buildOrderItem(c, state.orders ,index);
                  });
              }
               else {
               return  SizedBox(height: MediaQuery.of(context).size.height * .8,
                 child: const Center(child: Text("There is no data"),),
               );
             }
             }else if(state is SuccessGetOrderStatus){
                return SizedBox(height: MediaQuery.of(context).size.height * .8,
                  child: const Center(child: Text("An Error happen ,Try later"),),
                );
              }else {
                return SizedBox(height: MediaQuery.of(context).size.height * .8,
                  child: const Center(child: CircularProgressIndicator(),),
                );
              }

            }
        );
  }
  buildCircleShape  () {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          border: Border.all(color: greyColor),
          image: const DecorationImage(
              image: AssetImage("assets/logo.jpg")
          )
      ),
    );
  }
  Container buildOrderItem(BuildContext context, List<Order> states, int index) {
    return Container(
      margin:const EdgeInsets.symmetric(horizontal: 20 , vertical: 10 ),
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(horizontal: 10 , vertical: 10 ),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),

      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 7,
            child: Row(
              children: [
                buildCircleShape(),
                const SizedBox(width: 10,),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:  [
                      Text( states[index].orderId.toString(),overflow: TextOverflow.ellipsis,maxLines: 1, style: boldTextStyle.copyWith (color: secondColor, fontSize: 18),),
                      const SizedBox(height: 8,),
                    ],

                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text( states[index].status, style: semiBoldTextStyle.copyWith (color: secondColor, fontSize: 16),),
                const SizedBox(height: 10,),
                Row(mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text("${states[index].items.length } ", style: TextStyle (color: mainColor, fontSize: 16),),
                    Text( "Items", style: TextStyle (color: mainColor, fontSize: 16),),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

}
