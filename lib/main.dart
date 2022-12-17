import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';
import 'package:saleing/SharedPref.dart';
import 'package:saleing/colors.dart';
import 'package:saleing/firebase_service.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:saleing/otp_service/otp_manager.dart';
import 'package:saleing/screens/home_screen.dart';
import 'package:saleing/screens/introduction_animation/introduction_animation_screen.dart';
import 'package:saleing/styles.dart';
import 'screens/register_screen.dart';
import 'dialogs/dialogs.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  String? userId = await SharedPref.getUserId();
  if(userId!= null && userId.isNotEmpty){
    runApp( const MaterialApp(home: HomeScreen(),));
  }else{
  runApp( const MaterialApp(home: MyApp(),));
}
}
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin{
  late AnimationController _animationController ;

 @override
  void initState() {
    _animationController =
   AnimationController(vsync: this, duration: const Duration(seconds: 8));
   _animationController.animateTo(0.0);
   super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return const IntroductionAnimationScreen();
  }
}


class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  BehaviorSubject<String> rxOtpError = BehaviorSubject();
   late ProgressDialog pr ;
  @override
   initState(){
    pr = ProgressDialog(context);
    rxOtpError.sink.add("");
    pr.style(
        message: 'Logging...',
        borderRadius: 10.0,
        backgroundColor: Colors.white,
        progressWidget: const CircularProgressIndicator(color:Color(0xff20222D) ,),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        progress: 0.0,
        maxProgress: 100.0,
        progressTextStyle: const TextStyle(
            color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
        messageTextStyle: const TextStyle(
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
          children:  [
            _buildLoginShape(width),
            const SizedBox(height: 36,),
             Padding(
              padding:  const EdgeInsets.symmetric(horizontal: 20 , ),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                     Text("Welcome \nBack!" , style: TextStyle(color: secondColor , fontSize: 36 , fontWeight: FontWeight.w500 , letterSpacing: 4),),
                    const SizedBox(height: 36,),
                    _buildTextField("Email" ,emailController , Icons.person , (String? text){

                         if (RegExp(
                            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                            .hasMatch(text!)){
                           return null;
                         }else{
                           return "Email is not valid";
                         }

                    }),
                    const SizedBox(height: 32,),
                    _buildTextField("Password" ,passwordController , Icons.key ,(String? text ) {
                      if(text!.length > 6){
                        return null;
                      }
                      return "Password is not valid";
                    }),
                    const SizedBox(height: 100,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children:  [
                        GestureDetector(
                          child:  Text("Sign Up" ,
                            style: TextStyle(color: secondColor , fontSize: 22 , fontWeight: FontWeight.bold, decoration: TextDecoration.underline),

                          ),
                          onTap: (){
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (c){
                              return const RegisterScreen();
                            }));
                          },
                        ),

                        GestureDetector(
                          onTap: ()async{
                              if(formKey.currentState!.validate()){
                                await pr.show();
                                dynamic isLoggedIn = await FirebaseService.loginOnFirebase(emailController.text, passwordController.text);
                                if(isLoggedIn is bool && isLoggedIn){
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (c){
                                    return const HomeScreen();
                                  }));
                                }else {
                                  pr.hide();
                                  showDialog(context: context, builder: (c){
                                    return ErrorDialog(isLoggedIn.toString());
                                  });
                                }

                              }
                          },
                          child: Container(
                            width: 130 , height: 65,
                            decoration: BoxDecoration(
                              color: secondColor,
                              borderRadius: BorderRadius.circular(64)
                            ),
                            child: const Icon(Icons.arrow_forward , color: Colors.white,size: 30,),

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

  _buildLoginShape (double width){
    return Container(
      height: 230,
      width: width -20,
      decoration:  BoxDecoration(
        color: secondColor,
        borderRadius:const BorderRadius.only(bottomRight: Radius.circular(650), bottomLeft: Radius.circular(320)
      ),
    )
    );
  }
  _buildTextField (String hint , TextEditingController controller ,IconData icon ,String? onValidator (String? text) ){
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: bgColor,
            offset: const Offset(0, 2),
            blurRadius: 2,
            spreadRadius: 4
          )
        ]
      ),
      child: Theme(

        data: ThemeData().copyWith(
          cursorColor: secondColor,
          colorScheme: ThemeData().colorScheme.copyWith(
            primary: secondColor,
          ),

        ),
        child: TextFormField(
          controller: controller,
          style:  TextStyle(color:secondColor),
          decoration: InputDecoration(
            hintText: hint ,
            hintStyle:  TextStyle(color: greyColor),
            suffixIcon: Icon(icon , color: secondColor,),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(32),
              borderSide:  BorderSide(color:secondColor ,)
            ),
            enabledBorder:OutlineInputBorder(
                borderRadius: BorderRadius.circular(32),
                borderSide: BorderSide(color:greyColor)
            ),
            errorBorder:OutlineInputBorder(
                borderRadius: BorderRadius.circular(32),
                borderSide:const BorderSide(color:Colors.red,)
            ),
            focusedErrorBorder:OutlineInputBorder(
                borderRadius: BorderRadius.circular(32),
                borderSide:const BorderSide(color:Colors.red,)
            ),

          ),
          validator: onValidator,
        ),
      ),
    );
  }

  void showOTPDialog(context) {
    showDialog(
        barrierDismissible:false,
        context: context, builder: (c){
      return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)
          ),
        content: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10 , vertical: 10 ),
          width: MediaQuery.of(context).size.width,
          height: 230,
          decoration:const BoxDecoration(color: Colors.white,

          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Enter Your OTP ", style: boldTextStyle,),
                ],
              ),
              const SizedBox(height: 8,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(" There is an otp sent to your email  ",overflow: TextOverflow.ellipsis, style: normalTextStyle.copyWith(color: Colors.grey.shade500, fontSize: 14),),
                ],
              ),
              const SizedBox(height: 14,),
              StreamBuilder<String>(
                stream: rxOtpError.stream,
                builder: (context, data) {
                  return TextFormField(controller: otpController,decoration: InputDecoration(errorText: data.hasData && data.data!.isNotEmpty ? data.data : null),);
                }
              ),
              const SizedBox(height: 20,),
              RaisedButton(
                color: secondColor,
                onPressed: (){
                bool verified = OtpManager.verify(emailController.text, otpController.text);
                if(verified) {
                  Navigator.pop(context);
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (c){
                    return const HomeScreen();
                  }));
                } else {
                  rxOtpError.sink.add("Otp is not verified");
                }
              }, child: Text("Verify", style: boldTextStyle.copyWith(color: mainColor),),)

            ],
          ),
        ),
      );
    });
  }

}

