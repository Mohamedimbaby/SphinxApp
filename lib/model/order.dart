enum QuantityUnits{
  packs , tons
}
class Item {
  String itemDescription , notes  , quantity , userName , userEmail , userPhone ,userAddress  , glassType ;
   QuantityUnits quantityUnits ;

  Item(this.itemDescription, this.notes, this.quantity , this.userName , this.userPhone , this.userEmail,this.userAddress,
      this.glassType,
      this.quantityUnits
      );
  factory Item.fromJson(Map<String , dynamic > json){
  return Item(
    json["itemDescription"],
    json["notes"],
    json["quantity"],
    json["userName"],
    json["userPhone"],
    json["userEmail"],
    json["userAddress"],
    json["glassType"],
    json["quantityUnits"] == "packs" ?  QuantityUnits.packs: QuantityUnits.tons,
  );
  }
  Map<String , dynamic> toJson (){
  return  {
  "itemDescription" : itemDescription,
  "notes" : notes,
  "quantity" : quantity,
  "userPhone" : userPhone,
  "userAddress" : userAddress,
  "userName" : userName,
  "userEmail" : userEmail,
  "glassType" : glassType,
  "quantityUnits" : quantityUnits.toString(),
  };
  }
}
class Order {
  List<Item> items ;
  String status ;
  String date ;
  int total ;
  String userId ;
  String? orderId ;
  Order(this.items, this.status,this.total,this.userId,this.date,{this.orderId});

  factory Order.fromJson(Map<String , dynamic > json){
    if (json['items'] != null) {
      List<Item> items = [];
      json['items'].forEach((v) {
        items.add( Item.fromJson(v));
      });
      return Order(
        items,
        json["status"],
        json["total"],
        json["userId"],
        json["date"],
        orderId: json["OrderId"]??"",
      );
    }
    return Order([],"",0,"","");
  }
  Map<String , dynamic> toJson (){
    final Map<String, dynamic> data = {};
    data['data'] = items.map((v) => v.toJson()).toList();
  return  {
    "items" : data['data'],
    "status":"pending",
    "total":total,
    "date":date,
    "userId":userId,
  };
  }
}