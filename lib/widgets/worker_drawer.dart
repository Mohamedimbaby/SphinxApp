
import 'package:flutter/material.dart';
import 'package:saleing/colors.dart';
import 'package:saleing/styles.dart';
import 'package:saleing/widgets/drawer.dart';

class WorkerDrawerWidget extends StatelessWidget {
   WorkerDrawerWidget(subject){
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
      icon: const Icon(Icons.local_activity,color: Colors.white,),
      label: 'Activity',
      index: 0,
    ),
    const SizedBox(height: 10,),
    DrawerItemWidget(
      icon: const Icon(Icons.notifications,color: Colors.white,),
      label: 'Notifications',
      index: 1,
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
                children: tabs
            ),
            DrawerItemWidget(
              icon: const Icon(Icons.logout , color: Colors.white,),
              label: 'Logout',
              index: 2,
            )
          ],
        ),

      ),
    );
  }



}