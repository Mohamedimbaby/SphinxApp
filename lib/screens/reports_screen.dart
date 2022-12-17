import 'package:flutter/material.dart';
import 'package:saleing/colors.dart';
import 'package:saleing/screens/reports/company_report_screen.dart';
import 'package:saleing/screens/persion_report.dart';
import 'package:saleing/styles.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({Key? key}) : super(key: key);

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Image.asset("assets/reports.jpeg", width: MediaQuery.of(context).size.width , height:MediaQuery.of(context).size.height * .3,  fit: BoxFit.cover,),
          const SizedBox(height: 20,),
          GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (c){
                  return const PersonReport();
                }));
              },
              child: buildItem(Icons.person , "Person")),
          const SizedBox(height: 20,),
          GestureDetector(
              onTap : ()
              {
                Navigator.push(context, MaterialPageRoute(builder: (c){
                  return const CompanyReportsScreen();
                }));
              },
              child: buildItem(Icons.group , "Company")),


        ],
      ),
    );
  }

  Widget buildItem (IconData data , String title) {
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
          Icon(data, color: secondColor, size: 60,),
          Text(title , style: boldTextStyle.copyWith(color: secondColor, fontSize: 30 ),)
        ],
      ),
    );

  }
}
