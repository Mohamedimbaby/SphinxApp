import 'dart:convert';

import 'package:saleing/model/order.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {

 static saveUserId (String userId)async{
    SharedPreferences instance =await SharedPreferences.getInstance();
   await instance.setString("UserId", userId);
  }static saveUserName (String username)async{
    SharedPreferences instance =await SharedPreferences.getInstance();
   await instance.setString("user_name", username);
  }
  static saveUserType (int userType)async{
    SharedPreferences instance =await SharedPreferences.getInstance();
   await instance.setInt("user_type", userType);
  }
 static Future<String?> getUserId ()async{
    SharedPreferences instance =await SharedPreferences.getInstance();
   return instance.getString("UserId");
  }
  static Future<int?> getUserType ()async{
    SharedPreferences instance =await SharedPreferences.getInstance();
   return instance.getInt("user_type");
  }
  static Future<int?> clearSharedPref ()async{
    SharedPreferences instance =await SharedPreferences.getInstance();
   await instance.clear();
  }

  static Future<void> addToCart(Item order) async{
   SharedPreferences instance = await SharedPreferences.getInstance();
   List<Item> list = await getCartItems();
   list.add(order);
   final Map<String, dynamic> data = {};
     data['data'] = list.map((v) => v.toJson()).toList();
   await instance.setString("cart", jsonEncode(data));
  }
  static Future<List<Item>> getCartItems() async{
   SharedPreferences instance = await SharedPreferences.getInstance();
   String? json =  instance.getString("cart");
       if(json != null) {
         var jsonDecoded = jsonDecode(json);
         if (jsonDecoded['data'] != null) {
           List<Item> orders = [];
           jsonDecoded['data'].forEach((v) {
             orders.add( Item.fromJson(v));
           });
           return orders;
         }
       }
   return [];

  }

  static void clearCart() async{
    SharedPreferences instance = await SharedPreferences.getInstance();
    await instance.setString("cart", jsonEncode({}));

  }


}