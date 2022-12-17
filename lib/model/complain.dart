class Complain {
  String customerId , customerName , status ,
        desc , assignedToId , assignedToName ,
      companyName , email , address , position ,
      phoneNumber , invoiceNumber , loadNumber ,
      totalNumOfPacks ,
      quantityNumOfUsedPacks ,
      glassType ,
      defectedNumOfPacks ,
      submittedSupportiveProves ,
      claimCategory ;
  String? photo ,complainId;


  Complain({
    required this.customerId,
    required this.claimCategory,
    required this.customerName,
    required this.status,
    required this.desc,
    required this.assignedToId,
    required this.assignedToName,
    required  this.companyName,
    required this.email,
    required this.address,
    required this.position,
    required this.phoneNumber,
    required  this.invoiceNumber,
    required this.loadNumber,
    required this.totalNumOfPacks,
    required  this.quantityNumOfUsedPacks,
    required  this.submittedSupportiveProves,
    required  this.glassType,
    this.photo,
    this.complainId,
    required  this.defectedNumOfPacks});

  factory Complain.fromJson ( Map<String , dynamic> result ){
    return Complain(
        customerId: result["customerId"] ?? "",
        glassType: result["glassType"] ?? "",
        quantityNumOfUsedPacks: result["quantityNumOfUsedPacks"] ?? "",
        totalNumOfPacks: result["totalNumOfPacks"]?? "",
        loadNumber: result["loadNumber"]?? "",
        invoiceNumber: result["invoiceNumber"]?? "",
        position: result["position"]?? "",
        companyName: result["companyName"]?? "",
        address: result["address"]?? "",
        email: result["email"]?? "",
        complainId: result["complainId"]?? "",
        photo: result["photo"]?? "",
        phoneNumber: result["phoneNumber"]?? "",
        customerName: result["customerName"]?? "",
        status:  result["status"]?? "",
        desc:  result["desc"]?? "",
        assignedToId:  result["assignedToId"]?? "",
        claimCategory:  result["claim_category"]?? "",
        submittedSupportiveProves:  result["submitted_supportive_proves"]?? "",
        assignedToName:  result["assignedToName"]?? "",
        defectedNumOfPacks: result["defectedNumOfPacks"]?? "",

    );
  }
  toJson (){
    return {
     "customerId" :customerId,
     "glassType" :glassType,
     "quantityNumOfUsedPacks" :quantityNumOfUsedPacks,
     "defectedNumOfPacks" :defectedNumOfPacks,
     "customerName" :customerName,
     "totalNumOfPacks" :totalNumOfPacks,
     "loadNumber" :loadNumber,
     "invoiceNumber" :invoiceNumber,
     "address" :address,
     "status" :status,
     "companyName" :companyName,
     "email" :email,
     "photo" :photo,
     "claim_category" :claimCategory,
     "submitted_supportive_proves" :submittedSupportiveProves,
     "desc" :desc,
     "assignedToId" :assignedToId,
     "position" :position,
     "assignedToName" :assignedToName,
    };
  }
}