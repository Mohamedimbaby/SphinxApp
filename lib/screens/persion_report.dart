import 'dart:math';

import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';
import 'package:saleing/colors.dart';
import 'package:saleing/firebase_service.dart';
import 'package:saleing/model/User.dart';
import 'package:saleing/model/item.dart';
import 'package:saleing/screens/reports/report_bloc/report_bloc.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class PersonReport extends StatefulWidget {
  const PersonReport({Key? key}) : super(key: key);

  @override
  State<PersonReport> createState() => _PersonReportState();
}

class _PersonReportState extends State<PersonReport> {
  TextEditingController searchController = TextEditingController();
  BehaviorSubject<List<UserModel>>  rxSuggestions = BehaviorSubject();
  BehaviorSubject<List<Visit>>  rxVisits = BehaviorSubject();
  @override
  void initState() {
    getUsers();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
          child: Column(
            children: [
              const SizedBox(height: 40,),
              _buildTextField("Enter Employee name" , searchController , Icons.search ),
              StreamBuilder<List<Visit>>(
                stream: rxVisits.stream,
                builder: (context, snapshot) {
                  if(snapshot.data != null && snapshot.hasData && snapshot.data!.isNotEmpty)
                  {
                    double percent = ( snapshot.data!.length / 10 ) * 100;
                    ReportModel report = ReportModel("", percent,colors[Random().nextInt(colors.length-1)]);
                    ReportModel rest = ReportModel("", 100 -percent, Colors.grey);
                    List<ReportModel> items = [
                      report,
                        rest
                    ];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20 , vertical:5),
                          margin: const EdgeInsets.only(
                            bottom: 16,
                              top:15),

                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey.shade300,
                                    offset: const Offset(3,3),
                                    blurRadius: 3,
                                    spreadRadius: 5
                                )
                              ]
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children:  [
                                  const Text("Name : " , style: TextStyle (color: Colors.grey, fontSize: 14),),
                                  Text( snapshot.data!.first.workerName, style: TextStyle (color: secondColor, fontSize: 14),),
                                ],
                              ),
                              Column(
                                children: [
                                  Text("%"+ percent.toString() ),
                                  SizedBox(
                                    width: 60,
                                    height: 60,
                                    child : SfCircularChart(
                                      series: <CircularSeries<ReportModel, String>>[
                                        DoughnutSeries<ReportModel, String>(
                                            xValueMapper: (ReportModel data, _) => data.date,
                                            yValueMapper: (ReportModel data, _) => data.percentage,
                                            pointColorMapper:(ReportModel data,  _) => data.color,
                                            dataSource: items
                                        )
                                      ],

                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Text("Vists" ,style: TextStyle (color: secondColor, fontSize: 22 , fontWeight: FontWeight.bold),),
                        SizedBox(
                          height :MediaQuery.of(context).size.height *.6,
                          child: ListView.builder(
                            itemCount: snapshot.hasData ? snapshot.data!.length : 0,
                            itemBuilder: (c , index){
                            return Container(
                              width: MediaQuery.of(context).size.width,
                              padding: const EdgeInsets.symmetric(horizontal: 10 , vertical: 10 ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.shade300,
                                    offset: const Offset(3,3),
                                    blurRadius: 3,
                                    spreadRadius: 5
                                  )
                                ]
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children:  [
                                      Row(
                                        children:  [
                                         const Text("Date : " , style: TextStyle (color: Colors.grey, fontSize: 14),),
                                          Text( snapshot.data![index].date, style: TextStyle (color: secondColor, fontSize: 14),),

                                        ],
                                      ),
                                      Row(
                                        children:  [
                                         const Text("Time : " , style: TextStyle (color: Colors.grey, fontSize: 14),),
                                          Text( snapshot.data![index].time, style: TextStyle (color: secondColor, fontSize: 14),),

                                        ],
                                      ),
                                      Row(
                                        children:  [
                                         const Text("Customer : " , style: TextStyle (color: Colors.grey, fontSize: 14),),
                                          Text( snapshot.data![index].customerName, style: TextStyle (color: secondColor, fontSize: 14),),
                                        ],
                                      ),

                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children:  [
                                      Row(
                                        children:  [
                                         const Text("Address : " , style: TextStyle (color: Colors.grey, fontSize: 14),),
                                          Text( snapshot.data![index].address,overflow: TextOverflow.ellipsis,maxLines: 1, style: TextStyle (color: secondColor, fontSize: 14),),

                                        ],
                                      ),

                                    ],
                                  ),
                                ],
                              ),
                            );
                  }),
                        ),
                      ],
                    );
                  }
                  else {
                    return  SizedBox(
                      height: MediaQuery.of(context).size.height * .9,
                      child: const Center(
                        child: Text("There is no data"),
                      ),
                    );
                  }
                }
              )
            ],
          ),
        ),
      ),
    );
  }
  static String _displayStringForOption(UserModel option) => option.name;

  Widget  _buildTextField (String hint , TextEditingController controller ,IconData icon , )  {
    return StreamBuilder<List<UserModel>>(
      stream: rxSuggestions.stream,
      builder: (context, snapshot) {
        return Autocomplete<UserModel>(
          displayStringForOption: _displayStringForOption,
          optionsBuilder: (TextEditingValue textEditingValue) {
            if (textEditingValue.text == '') {
              return const Iterable<UserModel>.empty();
            }
            return rxSuggestions.value.where((UserModel option) {
              return option
                  .toString()
                  .contains(textEditingValue.text.toLowerCase());
            });
          },

          onSelected: (UserModel selection) async{
           //UserModel? userModel = await FirebaseService.getUser(selection.id!);
            rxVisits.sink.add(await FirebaseService.getVisitsForUser(selection.id!));
          },
        );
      }
    );
  }
  _buildCustomField(String hint, IconData icon, TextEditingController controller
      ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20 , vertical: 10 ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          color:Colors.white,
        boxShadow: [BoxShadow(color: Colors.grey.shade300 , offset: const Offset(3,3) , blurRadius: 3 , spreadRadius: 5)]
      ),
      child: Theme(
        data: ThemeData().copyWith(
          cursorColor: Color(0xffE69024),
          colorScheme: ThemeData().colorScheme.copyWith(
            primary: const Color(0xffE69024),
          ),
        ),
        child: TextFormField(
          controller: controller,
          style: const TextStyle(color: Color(0xffE69024)),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle:  TextStyle(color: secondColor),
            suffixIcon: Icon(
              icon,
              color: Color(0xffE69024),
            ),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(32),
                borderSide: BorderSide(
                  color: Color(0xffE69024),
                )),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(32),
                borderSide: BorderSide(
                  color: Colors.white,
                )),
            errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(32),
                borderSide: BorderSide(
                  color: Colors.red,
                )),
            focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(32),
                borderSide: BorderSide(
                  color: Colors.red,
                )),
          ),
        ),
      ),
    );
  }
  void getUsers() async{
   rxSuggestions.sink.add(await FirebaseService.getUsers());
  }

}
