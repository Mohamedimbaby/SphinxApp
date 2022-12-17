class UserModel {
  String name ;
  String email ;
  String password;
  String phoneNumber ;
  String address ;
  String? id ;
  int userType ;

  UserModel({required this.name,required this.email,required this.password,
    required this.phoneNumber,
    required this.userType,
    required this.address,
    this.id});

  factory UserModel.getFromMap(Map<String , dynamic> map){

     return UserModel(name: map["name"], email: map["email"], password: map["password"], phoneNumber: map["phone"], userType: map["userType"], id: map["id"],
         address: map["address"] ?? "");
  }
}