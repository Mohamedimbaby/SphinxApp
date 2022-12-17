import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/subjects.dart';
import 'package:saleing/SharedPref.dart';
import 'package:saleing/colors.dart';
import 'package:saleing/dialogs/dialogs.dart';


import 'package:saleing/model/order.dart';
import 'package:saleing/screens/order/order_bloc.dart';
import 'package:saleing/styles.dart';
import 'package:saleing/widgets/loading.dart';
class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => CartScreenState();
}


class CartScreenState extends State<CartScreen>{
  late LoadingDialog loadingDialog ;
  OrderBloc orderBloc = OrderBloc();
  BehaviorSubject<List<Item>> rxCartList = BehaviorSubject();
  @override
  void initState() {
    getCartItems ();
     loadingDialog = LoadingDialog(context);
    loadingDialog.initialize();
    loadingDialog.style("Place order...");
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: bgColor,
      body: StreamBuilder<List<Item>>(
          stream: rxCartList.stream,
        builder: (context, states) {
          if (states.hasData && states.data != null && states.data!.isNotEmpty)
          {
           return Stack (
              children: [
                SingleChildScrollView(
                    physics: const NeverScrollableScrollPhysics(),
                    child:Column(
                      children: [
                        BlocListener<OrderBloc, PlaceOrderStatus>(
                          bloc: orderBloc,
                          listener: (c, state) {
                            loadingDialog.hide();
                            if (state is SuccessPlaceOrderStatus) {
                              SharedPref.clearCart();
                              getCartItems();
                              showDialog(context: context, builder: (c)=>SuccessDialog("The order has been placed", () {
                                Navigator.pop(context);
                              }));

                            } else if (state is ErrorPlaceOrderStatus) {
                              showDialog(
                                  context: context,
                                  builder: (c) => ErrorDialog(state.error));
                            }
                          },
                          child: const SizedBox(),
                        ),
                        ListView.builder(
                            shrinkWrap: true,
                            itemCount: states.data!.length,
                            itemBuilder: (c, index){
                              return buildCartItem(context, states, index);
                            }),


                      ],
                    )
                ),
                rxCartList.hasValue &&  rxCartList.value.isNotEmpty ?
                Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: _buildButton(
                            ()async{
                              String? userId = await SharedPref.getUserId();
                              loadingDialog.show();
                          orderBloc.placeOrder(Order(rxCartList.value, "", rxCartList.value.length,userId!,DateFormat("dd-MM-yyyy").format(DateTime.now())));
                        })):const SizedBox()
              ],
            );
          }
          else {
            return SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child:  const Center(child: Text("There is no items")),
            );
          }
        }
      ),
    );
  }

  Container buildCartItem(BuildContext context, AsyncSnapshot<List<Item>> states, int index) {
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
                                      Text( states.data![index].itemDescription,overflow: TextOverflow.ellipsis,maxLines: 1, style: boldTextStyle.copyWith (color: secondColor, fontSize: 18),),
                                      const SizedBox(height: 8,),
                                      Row(
                                        children: [
                                          Icon(Icons.notes, color: greyColor,),
                                          Expanded(child: Text( states.data![index].notes + " dsadhadb dash dasbdj nasd as dashd asj dasj dsab dsajhd ",overflow: TextOverflow.ellipsis,maxLines: 1, style: TextStyle (color: greyColor, fontSize: 14),)),
                                        ],
                                      ),
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
                                Text( states.data![index].glassType, style: semiBoldTextStyle.copyWith (color: secondColor, fontSize: 16),),
                                const SizedBox(height: 10,),
                                Row(mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text("${states.data![index].quantity } ", style: TextStyle (color: mainColor, fontSize: 16),),
                                    Text( states.data![index].quantityUnits.name, style: TextStyle (color: mainColor, fontSize: 16),),
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    );
  }

  void getCartItems() async{
   rxCartList.add(await SharedPref.getCartItems() );
  }
  Widget _buildButton(void Function() onPressed) {
    return GestureDetector(
      onTap: (){
        onPressed();
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.symmetric( vertical: 20),
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32),
              color: mainColor,
            ),
            child: Text(
              "Order Now",
              style: boldTextStyle.copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
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

}