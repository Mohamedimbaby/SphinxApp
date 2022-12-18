import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:saleing/colors.dart';
import 'package:saleing/firebase_service.dart';
import 'package:saleing/main.dart';
import 'package:saleing/styles.dart';
late BehaviorSubject<int> rxCurrentPageIndex ;
enum UserType {user , admin , worker}
class DrawerWidget extends StatelessWidget {
  UserType userType ;
  DrawerWidget(subject,this.userType){
    rxCurrentPageIndex= subject;
  }

  List<Widget> tabs = [
    Row(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(image: AssetImage("assets/logo.jpg"),fit: BoxFit.fill)
          ),
        ),
        const SizedBox(width: 8,),
        Text("Sphinx", style: boldTextStyle.copyWith(color: Colors.white,fontSize: 22),)
      ],
    ),
    const SizedBox(height: 30,),
    DrawerItemWidget(
    icon: const Icon(Icons.add_shopping_cart,color: Colors.white,),
    label: 'Order',
      index: 0,
    ),
    const SizedBox(height: 10,),
    DrawerItemWidget(
      icon: const Icon(Icons.comment_outlined,color: Colors.white,),
      label: 'Complains',
      index: 1,
    ),
    const SizedBox(height: 10,),

    DrawerItemWidget(
      icon: const Icon(Icons.real_estate_agent_rounded,color: Colors.white,),
      label: 'Order Tracking',
      index: 2,

    ),
    const SizedBox(height: 10,),
    DrawerItemWidget(
      icon: const Icon(Icons.shopping_cart_rounded , color: Colors.white,),
      label: 'Cart',
      index: 3,
    ),
    const SizedBox(height: 10,),
    DrawerItemWidget(
      icon: const Icon(Icons.local_shipping_outlined , color: Colors.white,),
      label: 'Shipping',
      index: 4,
    ),
    const SizedBox(height: 10,),
    DrawerItemWidget(
      icon: const Icon(Icons.local_activity , color: Colors.white,),
      label: 'Activity',
      index: 5,
    ),
    const SizedBox(height: 10,),
  ];
  List<Widget> adminTabs = [
    Row(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(image: AssetImage("assets/logo.jpg"),fit: BoxFit.fill)
          ),
        ),
        const SizedBox(width: 8,),
        Text("Sphinx", style: boldTextStyle.copyWith(color: Colors.white,fontSize: 22),)
      ],
    ),
    const SizedBox(height: 30,),
    DrawerItemWidget(
      icon: const Icon(Icons.home , color: Colors.white,),
      label: 'Home', index: 0,
    ),
    const SizedBox(height: 10,),
    DrawerItemWidget(
      icon: const Icon(Icons.business, color: Colors.white,),
      label: 'Complains', index: 1,
    ),
    const SizedBox(height: 10,),
    DrawerItemWidget(
      icon: const Icon(Icons.bar_chart, color: Colors.white,),
      label: 'Reports', index: 2,
    ),
    const SizedBox(height: 10,),
    DrawerItemWidget(
      icon: const Icon(Icons.manage_accounts_sharp , color: Colors.white,),
      label: "Accounts", index: 3,
    ),
    const SizedBox(height: 10,),
    DrawerItemWidget(
      icon: const Icon(Icons.local_shipping_outlined , color: Colors.white,),
      label: 'Shipping',
      index: 4,
    ),
    const SizedBox(height: 10,),
    DrawerItemWidget(
      icon: const Icon(Icons.local_activity , color: Colors.white,),
      label: 'Activity',
      index: 5,
    ),
    const SizedBox(height: 10,),
  ];

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * .7,
      child: Container(
        padding: const EdgeInsets.only(top: 80 , left: 10, right: 10),
        width: MediaQuery.of(context).size.width * .7,
        color: secondColor,
        child: Column(
          children: [
            Column(
                children: userType == UserType.admin ?  adminTabs : tabs
            ),
            DrawerItemWidget(
              icon: const Icon(Icons.logout , color: Colors.white,),
              label: 'Logout',
              index: 6,
            )
          ],
        ),

      ),
    );
  }



}
class DrawerItemWidget extends StatelessWidget {
  final Icon icon ;
  final String label ;
  final int index ;

  DrawerItemWidget({required this.icon, required this.label,required this.index,}) ;
 _logout()async{
   await FirebaseService.logout();
 }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        if(index == 6){
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (c) => LoginScreen()), (route) => true);
          _logout();
        }else {
          Navigator.pop(context);
          rxCurrentPageIndex.sink.add(index);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15,horizontal: 8),
        decoration: BoxDecoration(
            color: rxCurrentPageIndex.value == index ? highlighter:secondColor ,
          borderRadius: BorderRadius.circular(8)
        )    ,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            icon,
            const SizedBox(width: 10,),
            Text(label, style: boldTextStyle.copyWith(color: Colors.white),),

          ],
        ),
      ),
    );
  }
}

