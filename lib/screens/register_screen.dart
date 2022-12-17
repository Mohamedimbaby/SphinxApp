import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:saleing/colors.dart';
import 'package:saleing/dialogs/dialogs.dart';
import 'package:saleing/firebase_service.dart';
import 'package:saleing/model/User.dart';
import '../main.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  var formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController userPhoneNumberController = TextEditingController();
  late ProgressDialog pr ;

  @override
  void initState() {
    pr = ProgressDialog(context);
    pr.style(
        message: 'Logging...',
        borderRadius: 10.0,
        backgroundColor: Colors.white,
        progressWidget: CircularProgressIndicator(color:Color(0xff20222D) ,),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        progress: 0.0,
        maxProgress: 100.0,
        progressTextStyle: TextStyle(
            color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600)
    );
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: bgColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLoginShape(width),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                     Text(
                      "Welcome \nBack!",
                      style: TextStyle(
                          color: secondColor,
                          fontSize: 36,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 4),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    _buildTextField("Name", nameController, Icons.info_outline,
                        (String? text) {
                      return null;
                    }),
                    const SizedBox(
                      height: 20,
                    ),
                    _buildTextField("Email", emailController, Icons.person,
                        (String? text) {
                      if (RegExp(
                              r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                          .hasMatch(text!)) {
                        return null;
                      } else {
                        return "Email is not valid";
                      }
                    }),
                    const SizedBox(
                      height: 20,
                    ),
                    _buildTextField("Password", passwordController, Icons.key,
                        (String? text) {
                      if (text!.length > 6) {
                        return null;
                      }
                      return "Password is not valid";
                    }),
                    const SizedBox(
                      height: 20,
                    ),
                    _buildTextField("Phone Number", userPhoneNumberController,
                        Icons.phone_android, (String? text) {
                      if (text!.length == 11) {
                        return null;
                      }
                      return "Phone number is not valid";
                    }),
                    const SizedBox(
                      height: 20,
                    ),
                    _buildTextField("Address", addressController,
                        Icons.pin_drop, (String? text) {
                      return null;
                    }),
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(context,
                                MaterialPageRoute(builder: (c) {
                              return LoginScreen();
                            }));
                          },
                          child:  Text(
                            "Sign In",
                            style:  TextStyle(
                                color: secondColor,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline),
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            if (formKey.currentState!.validate()) {
                              pr.show();
                           String? isRegistered =    await FirebaseService.registerOnFirebase(
                                UserModel(name: nameController.text, email: emailController.text, password: passwordController.text, phoneNumber: userPhoneNumberController.text,userType: 4,address:addressController.text ));
                              pr.hide();
                           if (isRegistered == null){
                             showDialog(
                                 barrierDismissible:false,
                                 context: context,

                                 builder: (context)=> SuccessDialog("User has been registered successfully", (){
                               Navigator.pop(context);
                               Navigator.pushReplacement(context,
                                   MaterialPageRoute(builder: (c) {
                                     return LoginScreen();
                                   }));
                             }));
                           }else {
                             showDialog(context: context, builder: (context)=> ErrorDialog(isRegistered));
                           }
                            }
                          },
                          child: Container(
                            width: 130,
                            height: 65,
                            decoration: BoxDecoration(
                                color:  secondColor,
                                borderRadius: BorderRadius.circular(64)),
                            child:  const Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildLoginShape(double width) {
    return Container(
        height: 150,
        width: width - 20,
        decoration:  BoxDecoration(
          color: secondColor,
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(650),
              bottomLeft: Radius.circular(320)),
        ));
  }

  _buildTextField(String hint, TextEditingController controller, IconData icon,
      String? onValidator(String? text)) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          color: Colors.white,

      ),
      child: Theme(
        data: ThemeData().copyWith(
          cursorColor: secondColor,
          colorScheme: ThemeData().colorScheme.copyWith(
                primary:  secondColor,
              ),
        ),
        child: TextFormField(
          controller: controller,
          style:  TextStyle(color: secondColor),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle:  TextStyle(color: secondColor),
            suffixIcon: Icon(
              icon,
              color: secondColor,
            ),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(32),
                borderSide: BorderSide(
                  color: secondColor,
                )),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(32),
                borderSide: BorderSide(
                  color: secondColor,
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
          validator: onValidator,
        ),
      ),
    );
  }
}
