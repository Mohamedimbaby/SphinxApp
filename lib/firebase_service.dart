import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:saleing/SharedPref.dart';
import 'package:saleing/model/User.dart';
import 'package:saleing/model/complain.dart';
import 'package:saleing/model/item.dart';
import 'package:saleing/model/order.dart';

class FirebaseService  {

  static Future<dynamic> loginOnFirebase (String email , String password)async{
    try{
    UserCredential userCredential =  await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
    if(userCredential.user != null ) {
      SharedPref.saveUserId(userCredential.user!.uid);
      await getUser(userCredential.user!.uid);

      return true;
    }
    return false ;

    }catch (e){
      print(e.toString());
      return e.toString() ;

    }
  }
  static Future<dynamic> logout ()async{
    try{
      await FirebaseAuth.instance.signOut();
    SharedPref.clearSharedPref();
    return false ;

    }catch (e){
      print(e.toString());
      return e.toString() ;

    }
  }
  static Future<String?> registerOnFirebase (UserModel user)async{
    try{
    UserCredential userCredential =  await FirebaseAuth.instance.createUserWithEmailAndPassword(email: user.email, password: user.password , );
    if(userCredential.user != null ) {
      SharedPref.saveUserId(userCredential.user!.uid);
      user.id = userCredential.user!.uid ;
        await saveUser(user);
    }
    return null;
    }catch (e){
      return e.toString() ;
    }
  }
  static Future<bool> saveUser(UserModel user) async{
    try{
    await FirebaseFirestore.instance.collection("users").add({
      "name":user.name,
      "id":user.id,
      "phone":user.phoneNumber,
      "email":user.email,
      "password":user.password,
      "userType":user.userType,
      "address":user.address,
    });
    return true ;
  }
  catch(e){
      return false ;
  }
  }
  static Future<bool> addComplain(List<XFile> images ,Complain complain) async{
    try{
    DocumentReference documentReference = await FirebaseFirestore.instance.collection("complains").add(complain.toJson());
    await documentReference.update({
      "complainId" : documentReference.id
    });
    await uploadImages(images ,documentReference.id);
    return true ;
  }
  catch(e){
      return false ;
  }
  }
  static List<File> imageFiles  =[];
  static covertAssetIntoFile(List<XFile> images) async{
    for(XFile image in images){
      imageFiles.add(File(image.path));
    }
  }
  static uploadImages(List<XFile> images,String fieldId)async{
    if(images.isNotEmpty) {
      imageFiles.clear();
      await covertAssetIntoFile(images);
      for(var file in imageFiles) {
        await FirebaseStorage.instance.ref().child(
            "images/$fieldId/${file.hashCode}").putFile(file).then((p0) async{
          String url = await p0.ref.getDownloadURL();
          await FirebaseFirestore.instance.collection("complains").doc(fieldId)
              .update(
              {
                "photo":url
              });
        });
      }
    }
  }
static Future<UserModel?> getUser(String id) async{
    try{
    QuerySnapshot user = await FirebaseFirestore.instance.collection("users").where("id",isEqualTo: id).get();
    if(user.docs.isNotEmpty){
      await SharedPref.saveUserName(user.docs.first["name"]);
      await SharedPref.saveUserType(user.docs.first["userType"]);
      print(user.docs.first["userType"]);
      return UserModel.getFromMap(user.docs.first as Map<String , dynamic>);
    }
  }
  catch(e){
      return null;
  }
    return null;
  }
static Future<UserModel?> getUserInfo(String id) async{
    try{
    QuerySnapshot user = await FirebaseFirestore.instance.collection("users").where("id",isEqualTo: id).get();
    if(user.docs.isNotEmpty){
      return UserModel.getFromMap(user.docs.first.data() as Map<String , dynamic>);
    }
  }
  catch(e){
      return null;
  }
    return null;
  }
static Future<List<Visit>?> getVisits() async{
    List<Visit> myVisits = [];
    try{
    QuerySnapshot visits = await FirebaseFirestore.instance.collection("visits").get();
    if(visits.docs.isNotEmpty){
      for(var i in visits.docs){
        myVisits.add(Visit.fromMap(i.data() as Map<String , dynamic>));
      }
      }
    return myVisits;
  }
  catch(e){
      return null;
  }
  }
static Future<List<Complain>> getComplains() async{
    List<Complain> myComplains = [];
    try{
    QuerySnapshot visits = await FirebaseFirestore.instance.collection("complains").get();
    if(visits.docs.isNotEmpty){
      for(var i in visits.docs){
        myComplains.add(Complain.fromJson(i.data() as Map<String , dynamic>));
      }
      }
    return myComplains;
  }
  catch(e){
      return [];
  }
  }
static Future<List<Visit>> getVisitsForUser( String id ) async{
    List<Visit> myVisits = [];
    try{
    QuerySnapshot visits = await FirebaseFirestore.instance.collection("visits").where("workerId", isEqualTo: id).get();
    if(visits.docs.isNotEmpty){
      for(var i in visits.docs){
        myVisits.add(Visit.fromMap(i.data() as Map<String , dynamic>));
      }
      }
    return myVisits;
  }
  catch(e){
      return [];
  }
  }
static Future<List<UserModel>> getUsersSuggestions(String keyword) async{
  List<UserModel>? users = await getUsers();
  if(users.isNotEmpty){
   return users.where((element) => element.name.toLowerCase().contains(keyword.toLowerCase())).toList();
  }
   return [];
  }
static Future<List<UserModel>> getUsers() async{
    List<UserModel> users = [];
    try{
    QuerySnapshot usersSnapshot = await FirebaseFirestore.instance.collection("users").get();
    if(usersSnapshot.docs.isNotEmpty){
      for(var i in usersSnapshot.docs){
         users.add(UserModel.getFromMap(i.data() as Map<String , dynamic>));
      }
      }
    return users;
  }
  catch(e){
      return [];
  }
  }
static Future<int?> getMaximumVistsPerDay() async{
    try{
    QuerySnapshot maximum = await FirebaseFirestore.instance.collection("maximumVisits").get();
    if(maximum.docs.isNotEmpty){
     return (maximum.docs.first.data() as Map )["maximumVisits"];
      }
  }
  catch(e){
      return null;
  }
    return null;
  }

  static placeOrder(Order order) async{

    try{
     var document =  await FirebaseFirestore.instance.collection("orders").add(order.toJson());
      await document.update({
        "OrderId" : document.id
      });
      return true ;
    }
    catch(e){
      return false ;
    }
  }

  static Future<List<Order>> getOrders() async{
    List<Order> myOrders = [];
    String? id  =  await SharedPref.getUserId();
    try{
      QuerySnapshot visits = await FirebaseFirestore.instance.collection("orders").where("userId",isEqualTo: id!).get();
      if(visits.docs.isNotEmpty){
        for(var i in visits.docs){
          myOrders.add(Order.fromJson(i.data() as Map<String , dynamic>));
        }
      }
      return myOrders;
    }
    catch(e){
      print(e);
      return [];
    }
  }
  static Future<List<Order>> getAllOrders() async{
    List<Order> myOrders = [];
    try{
      QuerySnapshot orders = await FirebaseFirestore.instance.collection("orders").get();
      if(orders.docs.isNotEmpty){
        for(var i in orders.docs){
          myOrders.add(Order.fromJson(i.data() as Map<String , dynamic>));
        }
      }
      return myOrders;
    }
    catch(e){
      print(e);
      return [];
    }
  }

  static acceptComplain(String complainId)async {
    try{
       await FirebaseFirestore.instance.collection("complains").doc(complainId).update(
          {
            "status" : "Accepted"
          });
      return true ;
    }
    catch(e){
      return false ;
    }

  }
  static rejectComplain(String complainId)async {
    try{
       await FirebaseFirestore.instance.collection("complains").doc(complainId).update(
          {
            "status" : "Rejected"
          });
      return true ;
    }
    catch(e){
      return false ;
    }

  }
  static assignComplain(String complainId , String userId , String username )async {
    try{
       await FirebaseFirestore.instance.collection("complains").doc(complainId).update(
          {
            "status" : "Assigned" ,
            "assignedToId":userId,
            "assignedToName": username
          });
      return true ;
    }
    catch(e){
      return false ;
    }

  }

}