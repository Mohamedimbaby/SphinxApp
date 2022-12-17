import 'package:flutter/material.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';

class LoadingDialog{
  BuildContext context ;
  late ProgressDialog pr;
  LoadingDialog(this.context);
  initialize (){
     pr = ProgressDialog(context);
  }
  show()async{
   await pr.show();
  }
  hide()async{
   await pr.hide();
  }
  style(String text){
    pr.style(
        message: text,
        borderRadius: 10.0,
        backgroundColor: Colors.white,
        progressWidget: CircularProgressIndicator(color:Color(0xff20222D) ,),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        progress: 0.0,
        maxProgress: 100.0,
        progressTextStyle: const TextStyle(
            color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
        messageTextStyle: const TextStyle(
            color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600)
    );
  }


}