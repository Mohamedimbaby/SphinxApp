class Visit {
  String customerId ;
  String customerName ;
  String customerEmail;
  String visitType;
  String date ;
  String time ;
  String workerName ;
  String workerId ;
  String address ;

  Visit(this.customerId, this.customerName, this.customerEmail, this.visitType,
      this.date,
      this.time,
      this.workerName,
      this.address,
      this.workerId);
  factory Visit.fromMap (Map <String ,dynamic> map){
    return Visit(map["customerId"], map["customerName"], map["customerEmail"], map["visitType"], map["date"], map["time"],
        map["workerName"],
        map["address"],
        map["workerId"]);

  }
}