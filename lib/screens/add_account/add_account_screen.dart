import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saleing/colors.dart';
import 'package:saleing/dialogs/dialogs.dart';
import 'package:saleing/firebase_service.dart';
import 'package:saleing/main.dart';
import 'package:saleing/model/User.dart';
import 'package:saleing/screens/add_account/add_account_bloc.dart';
import 'package:saleing/widgets/loading.dart';

class AddAccountScreen extends StatefulWidget {
  const AddAccountScreen({Key? key}) : super(key: key);

  @override
  State<AddAccountScreen> createState() => _AddAccountScreenState();
}

class _AddAccountScreenState extends State<AddAccountScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  @override
  void dispose() {
    _nameController.clear();
    _addressController.clear();
    _emailController.clear();
    _passwordController.clear();
    super.dispose();
  }

  var formKey = GlobalKey<FormState>();
  List<String> userTypes = ["Company Worker", "Driver"];
  String dropdownValue = "Company Worker";
  late LoadingDialog loadingDialog ;
   AddAccountBloc addAccountBloc  = AddAccountBloc();
  @override
  void initState() {
    dropdownValue = userTypes[0];
    loadingDialog = LoadingDialog(context);
    loadingDialog.initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AddAccountBloc , RequestState>(
        bloc: addAccountBloc,
        listener: (context, state) async{
          await loadingDialog.hide();
         if(state.state == BlocState.success){
           showDialog(context: context, builder: (c){
             return SuccessDialog("Add Successfully" , (){
               _passwordController.clear();
               _emailController.clear();
               _phoneNumberController.clear();
               _nameController.clear();
               _addressController.clear();
               Navigator.pop(context);
             });
           });
         }else if(state.state == BlocState.error){
           showDialog(context: context, builder: (c){
             return ErrorDialog(state.error!);
           });
         }
          },
        child: SizedBox(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16.0, vertical: 10),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Employee Name ",
                      style: TextStyle(color: secondColor, fontSize: 16),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        hintText: "Name",
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                              color: Colors.grey.shade400),
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
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Text(
                      "Employee email",
                      style: TextStyle(color: secondColor, fontSize: 16),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          hintText: "Email",
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                                color: Colors.grey.shade400),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: secondColor),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                                color: Colors.red),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                                color: Colors.red),
                          ),
                        ),
                        validator: (String? text) {
                          if (RegExp(
                              r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                              .hasMatch(text!)) {
                            return null;
                          } else {
                            return "Email is not valid";
                          }
                        }),
                    const SizedBox(
                      height: 16,
                    ),
                    Text(
                      "Employee Password",
                      style: TextStyle(color: secondColor, fontSize: 16),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        hintText: "Password",
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                              color: Colors.grey.shade400),
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
                        if (text!.length >= 6) {
                          return null;
                        }
                        return "Password is not valid";
                      },
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Text(
                      "Employee Address",
                      style: TextStyle(color: secondColor, fontSize: 16),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    TextFormField(
                      controller: _addressController,
                      decoration: InputDecoration(
                        hintText: "Address",
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                              color: Colors.grey.shade400),
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
                        if (text!.length >= 4) {
                          return null;
                        }
                        return "address is not valid";
                      },
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Text(
                      "Employee phone number",
                      style: TextStyle(color: secondColor, fontSize: 16),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    TextFormField(
                      controller: _phoneNumberController,
                      decoration: InputDecoration(
                        hintText: "phone number",
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                              color: Colors.grey.shade400),
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
                        if (text!.length == 11) {
                          return null;
                        }
                        return "Phone number is not valid";
                      },
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Text(
                      "Employee Job",
                      style: TextStyle(color: secondColor, fontSize: 16),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    DropdownButton<String>(
                      isExpanded: true,
                      value: dropdownValue,
                      icon: const Icon(Icons.arrow_drop_down),
                      iconSize: 24,
                      elevation: 16,
                      style: TextStyle(color: secondColor),
                      underline: Container(
                        height: 2,
                        color: secondColor,
                      ),
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
                    const SizedBox(height: 30,),
                    _buildButton(() async {
                      if (formKey.currentState!.validate()) {
                        await loadingDialog.show();
                        addAccountBloc.addAccount(UserModel(
                            name: _nameController.text,
                            email: _emailController.text,
                            password: _passwordController.text,
                            phoneNumber: _phoneNumberController.text,
                            address: _addressController.text,
                            userType: dropdownValue == "Driver" ? 3 : 2));
                      }
                    }
                    )
                  ],
                ),
              ),
            ),
          )),
      ),
    );
  }



  Widget _buildButton(void Function() onPressed) {
    return GestureDetector(
      onTap: (){onPressed();},
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32),
              color: secondColor,
            ),
            child: const Text(
              "Add Employee",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
