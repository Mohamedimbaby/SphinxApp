import 'package:flutter/material.dart';
class ErrorDialog extends StatelessWidget {
  String error ;
   ErrorDialog(this.error , {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Dialog(
      child: Container(
        width: width * .6,
        height: height * .22,
        padding: const EdgeInsets.symmetric(horizontal: 20 , vertical: 10 ),
        alignment: Alignment.center,
        child: Column(
         children: [
           const SizedBox(height: 10,),
           Row(
             mainAxisAlignment: MainAxisAlignment.start,
             children: const [
               Text("Alert" , style: TextStyle(fontWeight:FontWeight.bold, fontSize: 18),),
             ],
           ),
           const SizedBox(height: 15,),
           Text("There is some Problem $error"),
         ],
        )
      ),
    );
  }
}
class SuccessDialog extends StatelessWidget {
  String message ;
  void Function()? callback ;
  SuccessDialog(this.message ,this.callback, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Dialog(
      child: Container(
        width: width * .6,
        height: height * .27,
        padding: const EdgeInsets.symmetric(horizontal: 20 , vertical: 10 ),
        alignment: Alignment.center,
        child: Column(
         children: [
           const SizedBox(height: 10,),
           Container(
               width: 40,height: 40,
               decoration: const BoxDecoration(
                   shape: BoxShape.circle,
                   color: Colors.green
               ),
               alignment: Alignment.center,
               child  : const Icon(Icons.check_circle_rounded , color: Colors.white,)),
           Padding(
             padding: const EdgeInsets.only(top: 8.0),
             child: Row(
               mainAxisAlignment: MainAxisAlignment.center,
               children: const [
                  Text("Success" , style: TextStyle(fontWeight:FontWeight.bold, fontSize: 18),),
               ],
             ),
           ),
           const SizedBox(height: 15,),
            Text(message),
           const SizedBox(height: 30,),
           GestureDetector(
             onTap: callback,
             child: Container(
                 width: 90,height: 35,
                 decoration:  BoxDecoration(
                     color: Colors.green,
                   borderRadius: BorderRadius.circular(17)
                 ),
                 alignment: Alignment.center,
                 child  : const Text("Ok" , style: TextStyle(color: Colors.white,))),
           ),
         ],
        )
      ),
    );
  }
}
