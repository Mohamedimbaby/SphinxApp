import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rxdart/subjects.dart';
import 'package:saleing/SharedPref.dart';
import 'package:saleing/colors.dart';
import 'package:saleing/dialogs/dialogs.dart';
import 'package:saleing/firebase_service.dart';
import 'package:saleing/model/User.dart';
import 'package:saleing/model/complain.dart';
import 'package:saleing/screens/add_account/add_account_bloc.dart';
import 'package:saleing/screens/complains/complain_bloc.dart';
import 'package:saleing/styles.dart';
import 'package:saleing/widgets/loading.dart';

class AddComplainScreen extends StatefulWidget {
  const AddComplainScreen({Key? key}) : super(key: key);

  @override
  State<AddComplainScreen> createState() => _AddComplainScreenState();
}

class _AddComplainScreenState extends State<AddComplainScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _positionController = TextEditingController();
  final TextEditingController _invoiceController = TextEditingController();
  final TextEditingController _loadController = TextEditingController();
  final TextEditingController _totalNumController = TextEditingController();
  final TextEditingController _quantityNumController = TextEditingController();
  final TextEditingController _defectedNumController = TextEditingController();
  final TextEditingController _glassTypeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _complainantController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  @override
  void dispose() {
    _nameController.clear();
    _addressController.clear();
    _emailController.clear();
    _complainantController.clear();
    super.dispose();
  }

  var formKey = GlobalKey<FormState>();
  List<String> userTypes = ["Company Worker", "Driver"];
  String dropdownValue = "Company Worker";
  late LoadingDialog loadingDialog;

  ComplainBloc addComplainBloc = ComplainBloc();

  @override
  void initState() {
    dropdownValue = userTypes[0];
    loadingDialog = LoadingDialog(context);
    loadingDialog.initialize();
    categoryClaim.sink.add(0);
    supportiveClaim.sink.add(0);
    imagesNumRx.sink.add(0);
    loadingDialog.style("Add Complain");

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ComplainBloc, ComplainState>(
        bloc: addComplainBloc,
        listener: (context, state) async {
          await loadingDialog.hide();
          if (state is AddComplainSuccess && state.state == BlocState.success) {
            showDialog(
                context: context,
                builder: (c) {
                  return SuccessDialog("Add Successfully", () {
                    _resetControllers();
                    Navigator.pop(context);
                  });
                });
          } else if (state is AddComplainError) {
            showDialog(
                context: context,
                builder: (c) {
                  return ErrorDialog(state.error);
                });
          }
        },
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Customer Details",
                      style: boldTextStyle,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    _buildAddComplainForm(),
                    const SizedBox(
                      height: 16,
                    ),
                    GestureDetector(
                      onTap: () {
                        loadImages();
                      },
                      child: StreamBuilder<int>(
                          stream: imagesNumRx.stream,
                          builder: (context, snapshot) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Attach photo / ارفاق صور",
                                  style: boldTextStyle,
                                ),
                                StreamBuilder<int>(
                                  stream: imagesNumRx.stream ,
                                  builder: (context, snapshot) {
                                    return Row(
                                      children: [
                                        Text(
                                          "${imagesNumRx.hasValue ? imagesNumRx.value : 0}",
                                          style: boldTextStyle,
                                        ),
                                        Icon(
                                          Icons.image_outlined,
                                          color: secondColor,
                                        ),
                                      ],
                                    );
                                  }
                                ),
                              ],
                            );
                          }),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    _buildButton(() async {
                      if (formKey.currentState!.validate() &&
                          categoryClaim.hasValue &&
                          supportiveClaim.hasValue) {
                        await loadingDialog.show();
                        String? userId = await SharedPref.getUserId();
                        UserModel? user =
                            await FirebaseService.getUserInfo(userId!);
                        await addComplainBloc.addComplain(
                            images,
                            Complain(
                                customerId: userId,
                                customerName: user!.name,
                                status: "Pending",
                                claimCategory:
                                    categoryClaimList[categoryClaim.value]
                                        .itemDesc,
                                submittedSupportiveProves:
                                    supportiveClaimList[supportiveClaim.value]
                                        .itemDesc,
                                desc: _descController.text,
                                assignedToId: "",
                                assignedToName: "",
                                companyName: _nameController.text,
                                email: _emailController.text,
                                address: _addressController.text,
                                position: _positionController.text,
                                phoneNumber: _phoneNumberController.text,
                                invoiceNumber: _invoiceController.text,
                                loadNumber: _loadController.text,
                                totalNumOfPacks: _totalNumController.text,
                                quantityNumOfUsedPacks:
                                    _quantityNumController.text,
                                glassType: _glassTypeController.text,
                                defectedNumOfPacks:
                                    _defectedNumController.text));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Fill complain form")));
                      }
                    })
                  ],
                ),
              ),
            ),
          ),
        ),
      );
  }

  _buildAddComplainForm() {
    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          color: Colors.grey.shade400,
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Company Name",
            style: boldTextStyle.copyWith(fontSize: 12),
          ),
        ),
        const SizedBox(height: 10,),
        TextFormField(
          controller: _nameController,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide:  BorderSide(color: Colors.grey.shade400),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: secondColor),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red),
            ),
          ),
          validator: (String? text) {
            return text!.isNotEmpty ? null : "Enter company name";
          },
        ),
        const SizedBox(height: 10,),
        Container(
          alignment: Alignment.center,
          color: Colors.grey.shade400,
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "address / country العنوان / البلد",
            style: boldTextStyle.copyWith(fontSize: 12),
          ),
        ),
        const SizedBox(height: 10,),
        TextFormField(
          controller: _addressController,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide:  BorderSide(color: Colors.grey.shade400),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: secondColor),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red),
            ),
          ),
          validator: (String? text) {
            return text!.isNotEmpty ? null : "Enter company name";
          },
        ),
        const SizedBox(height: 10,),
        Container(
          alignment: Alignment.center,
          color: Colors.grey.shade400,
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Complainant / المشتكي",
            style: boldTextStyle.copyWith(fontSize: 12),
          ),
        ),
        const SizedBox(height: 10,),
        TextFormField(
          controller: _complainantController,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide:  BorderSide(color: Colors.grey.shade400),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: secondColor),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red),
            ),
          ),
          validator: (String? text) {
            return text!.isNotEmpty ? null : "Enter company name";
          },
        ),
        const SizedBox(height: 10,),
        Container(
          alignment: Alignment.center,
          color: Colors.grey.shade400,
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Position / المنصب",
            style: boldTextStyle.copyWith(fontSize: 12),
          ),
        ),
        const SizedBox(height: 10,),
        TextFormField(
          controller: _positionController,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide:  BorderSide(color: Colors.grey.shade400),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: secondColor),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red),
            ),
          ),
          validator: (String? text) {
            return text!.isNotEmpty ? null : "Enter company name";
          },
        ),
        const SizedBox(height: 10,),
        Container(
          alignment: Alignment.center,
          color: Colors.grey.shade400,
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Email / الحساب",
            style: boldTextStyle.copyWith(fontSize: 12),
          ),
        ),
        const SizedBox(height: 10,),
        TextFormField(
          controller: _emailController,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide:  BorderSide(color: Colors.grey.shade400),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: secondColor),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red),
            ),
          ),
          validator: (String? text) {
            return text!.isNotEmpty ? null : "Enter company name";
          },
        ),
        const SizedBox(height: 10,),
        Container(
          alignment: Alignment.center,
          color: Colors.grey.shade400,
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Phone / الهاتف",
            style: boldTextStyle.copyWith(fontSize: 12),
          ),
        ),
        const SizedBox(height: 10,),
        TextFormField(
          controller: _phoneNumberController,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide:  BorderSide(color: Colors.grey.shade400),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: secondColor),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red),
            ),
          ),
          validator: (String? text) {
            return text!.isNotEmpty ? null : "Enter company name";
          },
        ),
        const SizedBox(
          height: 16,
        ),
        Text(
          "Details of supplied good / تفاصيل البضائع",
          style: boldTextStyle,
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          alignment: Alignment.center,
          color: Colors.grey.shade400,
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Invoice number/ رقم الفاتره",
            style: boldTextStyle.copyWith(fontSize: 12),
          ),
        ),
        const SizedBox(height: 10,),
        TextFormField(
          controller: _invoiceController,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide:  BorderSide(color: Colors.grey.shade400),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: secondColor),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red),
            ),
          ),
          validator: (String? text) {
            return text!.isNotEmpty ? null : "Enter company name";
          },
        ),
        const SizedBox(height: 10,),

        Container(
          alignment: Alignment.center,
          color: Colors.grey.shade400,
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Total No of Packs / عدد العبوات",
            style: boldTextStyle.copyWith(fontSize: 12),
          ),
        ),
        const SizedBox(height: 10,),
        TextFormField(
          controller: _totalNumController,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide:  BorderSide(color: Colors.grey.shade400),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: secondColor),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red),
            ),
          ),
          validator: (String? text) {
            return text!.isNotEmpty ? null : "Enter company name";
          },
        ),
        const SizedBox(height: 10,),
        Container(
          alignment: Alignment.center,
          color: Colors.grey.shade400,
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Load number /رقم التحميل ",
            style: boldTextStyle.copyWith(fontSize: 12),
          ),
        ),
        const SizedBox(height: 10,),

        TextFormField(
          controller: _loadController,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide:  BorderSide(color: Colors.grey.shade400),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: secondColor),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red),
            ),
          ),
          validator: (String? text) {
            return text!.isNotEmpty ? null : "Enter company name";
          },
        ),
        const SizedBox(height: 10,),
        Container(
          alignment: Alignment.center,
          color: Colors.grey.shade400,
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Quantity of used packs / الكميه",
            style: boldTextStyle.copyWith(fontSize: 12),
          ),
        ),
        TextFormField(
          controller: _quantityNumController,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide:  BorderSide(color: Colors.grey.shade400),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: secondColor),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red),
            ),
          ),
          validator: (String? text) {
            return text!.isNotEmpty ? null : "Enter company name";
          },
        ),
        const SizedBox(height: 10,),
        Container(
          alignment: Alignment.center,
          color: Colors.grey.shade400,
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Glass type (SKU) / نوع الزجاج",
            style: boldTextStyle.copyWith(fontSize: 12),
          ),
        ),
        const SizedBox(height: 10,),
        TextFormField(
          controller: _glassTypeController,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide:  BorderSide(color: Colors.grey.shade400),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: secondColor),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red),
            ),
          ),
          validator: (String? text) {
            return text!.isNotEmpty ? null : "Enter company name";
          },
        ),
        const SizedBox(height: 10,),
        Container(
          alignment: Alignment.center,
          color: Colors.grey.shade400,
          padding: const EdgeInsets.all(8),
          child: Text(
            "No of defected packs / عدد العبوات المعيوبه",
            style: boldTextStyle.copyWith(fontSize: 12),
          ),
        ),
        const SizedBox(height: 10,),
        TextFormField(
          controller: _defectedNumController,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide:  BorderSide(color: Colors.grey.shade400),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: secondColor),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red),
            ),
          ),
          validator: (String? text) {
            return text!.isNotEmpty ? null : "Enter company name";
          },
        ),
        const SizedBox(
          height: 16,
        ),
        Text("Complaint Description", style: boldTextStyle),
        const SizedBox(
          height: 4,
        ),
        TextFormField(
          controller: _descController,
          maxLines: 4,
          decoration: InputDecoration(
            hintText: "Description",
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: secondColor),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red),
            ),
          ),
          validator: (String? text) {
            return text!.isNotEmpty ? null : "Enter company name";
          },
        ),
        const SizedBox(
          height: 16,
        ),
        Text(
          "Choose your claim Category and submitted supportive proves",
          style: boldTextStyle,
        ),
        const SizedBox(
          height: 16,
        ),
        Container(
          alignment: Alignment.center,
          color: Colors.grey.shade400,
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Claim category",
            style: boldTextStyle.copyWith(fontSize: 12),
          ),
        ),
        const SizedBox(height: 10,),
        Wrap(
          alignment: WrapAlignment.start,
          spacing: 12,
          children: categoryClaimList
              .map((CheckboxItem e) => StreamBuilder<int>(
                  stream: categoryClaim.stream,
                  builder: (context, snapshot) {
                    return buildCheckboxItem(e, categoryClaimList.indexOf(e),
                        categoryClaim.hasValue ? categoryClaim.value : 0);
                  }))
              .toList(),
        ),
        Container(
          alignment: Alignment.center,
          color: Colors.grey.shade400,
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Submitted supportive proves",
            style: boldTextStyle.copyWith(fontSize: 12),
          ),
        ),
        Wrap(
          alignment: WrapAlignment.start,
          spacing: 10,
          children: supportiveClaimList
              .map((e) => StreamBuilder<int>(
                  stream: supportiveClaim.stream,
                  builder: (context, snapshot) {
                    return buildSupportiveCheckboxItem(
                        e,
                        supportiveClaimList.indexOf(e),
                        supportiveClaim.hasValue
                            ? supportiveClaim.value
                            : 0);
                  }))
              .toList(),
        ),
      ],
    );
  }

  List<XFile> images = [];

  void loadImages() async {
    ImagePicker picker = ImagePicker();
    images = await picker.pickMultiImage(requestFullMetadata: false);
    print(images.length.toString() + "dasdasdasd");
    imagesNumRx.sink.add(images.length);
  }

  void _resetControllers() {
    _complainantController.clear();
    _positionController.clear();
    _phoneNumberController.clear();
    _nameController.clear();
    _addressController.clear();
    _totalNumController.clear();
    _quantityNumController.clear();
    _defectedNumController.clear();
    _glassTypeController.clear();
    _loadController.clear();
    _invoiceController.clear();
    _descController.clear();
    _emailController.clear();
    categoryClaim.sink.add(0);
    supportiveClaim.sink.add(0);
  }

  List<CheckboxItem> categoryClaimList = [
    CheckboxItem(false, "Quality"),
    CheckboxItem(false, "Breakage"),
    CheckboxItem(false, "Missing Sheet"),
    CheckboxItem(false, "Others"),
  ];
  List<CheckboxItem> supportiveClaimList = [
    CheckboxItem(false, "photos"),
    CheckboxItem(false, "samples"),
    CheckboxItem(false, "Supporting Documents"),
    CheckboxItem(false, "Others"),
  ];
  BehaviorSubject<int> categoryClaim = BehaviorSubject();
  BehaviorSubject<int> imagesNumRx = BehaviorSubject();
  BehaviorSubject<int> supportiveClaim = BehaviorSubject();

  Widget buildCheckboxItem(CheckboxItem item, int index, int selected) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: const BoxDecoration(color: Color(0xffEAF1DE)),
      child: Row(
        children: [
          Checkbox(
              value: selected == index,
              onChanged: (newValue) {
                categoryClaim.sink.add(categoryClaimList.indexOf(item));
              }),
          Text(
            item.itemDesc,
            style: normalTextStyle.copyWith(fontSize: 12),
          )
        ],
      ),
    );
  }

  Widget buildSupportiveCheckboxItem(
      CheckboxItem item, int index, int selected) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: const BoxDecoration(color: Color(0xffEAF1DE)),
      child: Row(
        children: [
          Checkbox(
              value: selected == index,
              onChanged: (newValue) {
                supportiveClaim.sink.add(supportiveClaimList.indexOf(item));
              }),
          Text(
            item.itemDesc,
            style: normalTextStyle.copyWith(fontSize: 12),
          )
        ],
      ),
    );
  }

  Widget _buildButton(void Function() onPressed) {
    return GestureDetector(
      onTap: () {
        onPressed();
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32),
              color: secondColor,
            ),
            child: Text(
              "Submit Complain",
              style: boldTextStyle.copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class CheckboxItem {
  bool isChecked;

  String itemDesc;

  CheckboxItem(this.isChecked, this.itemDesc);
}
