import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:rxdart/subjects.dart';
import 'package:saleing/SharedPref.dart';
import 'package:saleing/colors.dart';
import 'package:saleing/model/item.dart';
import 'package:saleing/screens/activity.dart';
import 'package:saleing/screens/add_account/add_account_screen.dart';
import 'package:saleing/screens/company_worker_home_screen.dart';
import 'package:saleing/screens/complains/complains_screen.dart';
import 'package:saleing/screens/driver_home_screen.dart';
import 'package:saleing/screens/reports_screen.dart';
import 'package:saleing/screens/shipping.dart';
import 'package:saleing/screens/user_home_screen.dart';
import 'package:saleing/visits_bloc.dart';
import 'package:saleing/widgets/drawer.dart';

import '../styles.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  BehaviorSubject<int> rxCurrentPageIndex = BehaviorSubject();
  BehaviorSubject<int> rxUserType = BehaviorSubject();
  VisitBloc visitBloc = VisitBloc();
  var scaffoldKey = GlobalKey<ScaffoldState>();
  List<String> pagesTitle = ["Home" , "Complains", "Reports", "Accounts","Shipping", "Activity"];

  @override
  void initState() {
    rxCurrentPageIndex.sink.add(0);
    specifyUserType();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
      stream: rxUserType.stream,
      builder: (context, snapshot) {
        if(rxUserType.hasValue){
        if(rxUserType.value == 1){
        return StreamBuilder<int>(
          stream: rxCurrentPageIndex.stream,
          builder: (context, snapshot) {
            return Scaffold(
              key: scaffoldKey,
              appBar: AppBar(
                backgroundColor: bgColor,
                elevation: 0.0,
                leading: InkWell(
                    onTap: (){
                      scaffoldKey.currentState!.openDrawer();
                    },
                    child: Icon(Icons.menu , color: secondColor,)),
                title: Row(
                  children: [
                    const SizedBox(width: 8,),
                    Text(pagesTitle[rxCurrentPageIndex.value] , style: boldTextStyle.copyWith(fontSize: 20,color: secondColor),),
                  ],
                ),
              ),
              body: getSuitableScreen(),
              drawer: DrawerWidget(rxCurrentPageIndex,UserType.admin),
            );
          }
        );
      }else if(rxUserType.value == 2){
          return const CompanyWorkerHomeScreen();
        }
        else if(rxUserType.value == 3){
          return const DriverHomeScreen();
        }else {
          return const UserHomeScreen();
        }
      }else{
          return Container(
            alignment: Alignment.center,
            child:const Text("There is a problem ,, can you logout and login again"),
          );
        }
      }
    );
  }
  int? userType = 4 ;
  void specifyUserType() async{
    userType = await SharedPref.getUserType();
    if(userType != null) {
      rxUserType.sink.add(userType!);
    }
    else {
      rxUserType.sink.add(1);
    }
  }

  getSuitableScreen () {
    switch(rxCurrentPageIndex.value){
      case 0 :
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0 , horizontal: 20),
          child: buildVisitsList(),
        );
      case 1 :
        return const ComplainsScreen();
      case 2 :
        return  const ReportsScreen();
      case 3 :
        return const AddAccountScreen();
        case 4 :
        return const ShippingScreen();
        case 5 :
        return const ActivityScreen();

    }
  }

  Widget buildVisitsList() {
    visitBloc.getVisits();
    return StreamBuilder<List<Visit>?>(
      stream: visitBloc.rxVisits.stream,
      builder: (context, snapshot) {
        if(!visitBloc.rxVisits.hasValue){
          return Container(
              alignment: Alignment.center,
              child: CircularProgressIndicator(color: secondColor,));
        }else  if (visitBloc.rxVisits.value == null  || visitBloc.rxVisits.value!.isEmpty){
          return Container(
              alignment: Alignment.center,
              child: Text("There is no visits till now ", style: boldTextStyle,));
        }else {

        return GroupedListView<Visit, String>(
          elements: visitBloc.rxVisits.value!,
          separator: const Divider(indent: 5,endIndent: 5,),
          groupBy: (element) => element.date,
          groupSeparatorBuilder: (String groupByValue) => Text(groupByValue, style: boldTextStyle,),
          itemBuilder: (context, Visit element) => buildVisitItem(context, element),
          //itemComparator: (item1, item2) => item1['name'].compareTo(item2['name']), // optional
          floatingHeader: true, // optional
          order: GroupedListOrder.ASC,
            stickyHeaderBackgroundColor:secondColor
          // optional
        );
      }
      }
    );
  }

  Widget buildVisitItem(BuildContext context , Visit item , ) {
    return Container(
      height: MediaQuery.of(context).size.height *.2,
      width: MediaQuery.of(context).size.width *.8,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            spreadRadius: 4,
            blurRadius: 5,
            offset: const Offset(5,5),
            color:Colors.grey.shade300
          )
        ]
      ),
      margin:const EdgeInsets.symmetric(horizontal: 20,vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
              flex: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(item.date , style: boldTextStyle.copyWith(fontSize: 12),),
                ],
              )),
          Expanded(
            flex: 5,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(topRight: Radius.circular(16) , bottomRight:  Radius.circular(16)),
                color: secondColor,

              ),
              child: Padding(
                padding: const EdgeInsets.only(left:  16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                     Row(
                       children: [
                         Text("Company Worker : " , style: boldTextStyle.copyWith(color: greyColor),),
                         Text(item.workerName , style: semiBoldTextStyle.copyWith(color: Colors.white),),
                       ],
                     ),
                    Row(
                      children: [
                        Text("Visit Type : " ,style: boldTextStyle.copyWith(color: greyColor),),
                        Text(item.visitType , style: semiBoldTextStyle.copyWith(color: Colors.white),),
                      ],
                    ),
                    Row(
                      children: [
                        Text("Address :   " , style: boldTextStyle.copyWith(color: greyColor),),
                        Text(item.address , style: semiBoldTextStyle.copyWith(color: Colors.white),),

                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }

}
