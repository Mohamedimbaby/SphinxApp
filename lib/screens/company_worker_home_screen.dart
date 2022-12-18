import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';
import 'package:saleing/SharedPref.dart';
import 'package:saleing/colors.dart';
import 'package:saleing/firebase_service.dart';
import 'package:saleing/model/User.dart';
import 'package:saleing/screens/order/order_bloc.dart';
import 'package:saleing/screens/worker/notification_screen.dart';
import 'package:saleing/styles.dart';
import 'package:saleing/widgets/loading.dart';
import 'package:saleing/widgets/worker_drawer.dart';

class CompanyWorkerHomeScreen extends StatefulWidget {
  const CompanyWorkerHomeScreen({Key? key}) : super(key: key);

  @override
  State<CompanyWorkerHomeScreen> createState() => _CompanyWorkerHomeScreenState();
}

class _CompanyWorkerHomeScreenState extends State<CompanyWorkerHomeScreen> {
  BehaviorSubject<int> rxCurrentPageIndex = BehaviorSubject();
  BehaviorSubject<int> rxThicknessSubject = BehaviorSubject();
  BehaviorSubject<UserModel> rxUserModel = BehaviorSubject();
  final TextEditingController _itemDescController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final OrderBloc orderBloc = OrderBloc();
  final formKey = GlobalKey<FormState>();
  late LoadingDialog loadingDialog;
  UserModel? loggedinUser ;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  String dropdownValue = "packs";

  var userTypes = ["packs", "tons"];
  List<String> pagesTitle = ["Activity" , "Notifications", ];

  @override
  void initState() {
    getLoggedInUser ();
    rxCurrentPageIndex.sink.add(0);
    super.initState();
  }

  @override
  void dispose() {
    _itemDescController.clear();
    _descController.dispose();
    _quantityController.dispose();
    rxThicknessSubject.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
        stream: rxCurrentPageIndex.stream,
        builder: (context, snapshot) {
          return Scaffold(
            key: scaffoldKey,
            backgroundColor: bgColor,
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
            body: _buildSuitableScreen(),
            drawer: WorkerDrawerWidget(rxCurrentPageIndex),
          );
        }
    );
  }

  _buildSuitableScreen() {
    switch (rxCurrentPageIndex.value) {
      case 0:
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20),
          child: buildOrderScreen(),
        );
      case 1:
        return const NotificationScreen();


    }
  }

  buildOrderScreen() {
    return StreamBuilder<UserModel>(
        stream: rxUserModel.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null){
            return SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    const SizedBox(
                      height: 20,
                    ),
                    buildHeaderSection(),
                    const SizedBox(
                      height: 20,
                    ),
                    Text("Visit Details" , style: boldTextStyle.copyWith(fontSize: 20),),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            flex:6,
                            child: TextFormField(
                              controller: _itemDescController,
                              decoration: InputDecoration(
                                hintText: "visit",
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(color: Colors.grey.shade400),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(color: secondColor),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(color: Colors.red),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(color: Colors.red),
                                ),
                              ),
                              validator: (String? text) {
                                return text!.length < 3 ? "Enter valid item" : null;
                              },
                            ),
                          ),
                          const SizedBox(width: 10,),
                          Expanded(
                            flex: 6,
                            child: TextFormField(
                              controller: _quantityController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: "Quantity",
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(color: Colors.grey.shade400),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(color: secondColor),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(color: Colors.red),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(color: Colors.red),
                                ),
                              ),
                              validator: (String? text) {
                                return text!.isEmpty ? "Enter quantity" : null;
                              },
                            ),
                          ),
                          const SizedBox(width: 5,),
                          Expanded(
                            flex: 3,
                            child: DropdownButton<String>(
                              isExpanded: true,
                              value: dropdownValue,
                              icon: const Icon(Icons.arrow_drop_down),
                              iconSize: 24,
                              elevation: 16,
                              style: TextStyle(color: secondColor),
                              underline: null,

                              onChanged: (String? newValue) {
                                setState(() {
                                  dropdownValue = newValue!;
                                });
                              },
                              items: userTypes.map<DropdownMenuItem<String>>((
                                  String value) {
                                return DropdownMenuItem<String>(
                                  value: value,

                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),

                    _buildButton(() async {
                      String? userId = await SharedPref.getUserId();
                      UserModel? user = await FirebaseService.getUserInfo(userId!);
                      if (formKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text("Added To cart")));
                        _resetControllers();

                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Fill all information")));
                      }
                    }),
                  ],
                ),
              ),
            );
          }else {
            return SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: const Center(child:  CircularProgressIndicator()));
          }
        }
    );
  }

  Widget _buildButton(void Function() onPressed) {
    return GestureDetector(
      onTap: () {
        onPressed();
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32),
              color: mainColor,
            ),
            child: Text(
              "Add To Cart",
              style: boldTextStyle.copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _resetControllers() {
    _quantityController.clear();
    _descController.clear();
    _itemDescController.clear();
    rxThicknessSubject.sink.add(0);
  }

  void getLoggedInUser() async{
    String? userId = await SharedPref.getUserId();
    loggedinUser = await FirebaseService.getUserInfo(userId!);
    rxUserModel.sink.add(loggedinUser!);
  }

  buildHeaderSection() {
    return  Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                lighterSecondColor,
                const Color(0xff8D75E8).withOpacity(.8),
                lighterSecondColor,
              ]
          ),
          boxShadow: [
            BoxShadow(
                color: greyColor,
                offset:const Offset(0,2),
                blurRadius: 4,
                spreadRadius: 2
            )
          ]
      ),
      height: MediaQuery.of(context).size.height * .18,
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            children: <Widget>[
              Text("Name : " ,style: normalTextStyle.copyWith(fontSize: 16).copyWith(color: Colors.white),),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(loggedinUser!.name ,style: boldTextStyle.copyWith(fontSize: 16).copyWith(color: Colors.white,)),
                ],
              ),

            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("Phone : " ,style: normalTextStyle.copyWith(fontSize: 16,color: Colors.white),),
              Text(loggedinUser!.phoneNumber ,style: boldTextStyle.copyWith(fontSize: 16,color: Colors.white),),
            ],
          ),
          Row(
            children: <Widget>[
              Text("Address : " ,style: normalTextStyle.copyWith(fontSize: 16,color: Colors.white),),
              Text(loggedinUser!.address.toString() ,style: boldTextStyle.copyWith(fontSize: 16,color: Colors.white),),
            ],
          ),
          Row(
            children: <Widget>[
              Text("Email : " ,style: normalTextStyle.copyWith(fontSize: 16,color: Colors.white),),
              Flexible(child: Text(loggedinUser!.email ,overflow:TextOverflow.ellipsis,
                maxLines: 1,
                style: boldTextStyle.copyWith(fontSize: 16,color: Colors.white),)),

            ],
          ),
        ],
      ),
    );
  }


}


