
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/subjects.dart';
import 'package:saleing/colors.dart';
import 'package:saleing/firebase_service.dart';
import 'package:saleing/model/User.dart';
import 'package:saleing/model/complain.dart';
import 'package:saleing/screens/complains/complain_bloc.dart';
import 'package:saleing/styles.dart';
import 'package:saleing/widgets/loading.dart';

class ComplainsScreen extends StatefulWidget {
  const ComplainsScreen({Key? key}) : super(key: key);

  @override
  State<ComplainsScreen> createState() => _ComplainsScreenState();
}

class _ComplainsScreenState extends State<ComplainsScreen> {
  BehaviorSubject<List<Complain>> rxComplains = BehaviorSubject();
  ComplainBloc complainBloc =ComplainBloc ();
  BehaviorSubject<List<UserModel>> rxSuggestions =BehaviorSubject<List<UserModel>>();
  late LoadingDialog loadingDialog  ;

  @override
  void initState() {
    loadingDialog = LoadingDialog(context);
    loadingDialog.initialize();
    complainBloc.getComplains();
    getUsers();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12 , vertical: 10 ),
        child: BlocBuilder<ComplainBloc , ComplainState>(
          bloc: complainBloc,
          builder: (context, snapshot) {
            if( snapshot is ListingComplainState && snapshot.complains.isNotEmpty)
            {return ListView.builder(
                itemCount: snapshot.complains.length ,
                itemBuilder: (c , index){
                  return   buildComplainItem(context, snapshot.complains , index);
                });}
            else {
              return  SizedBox(height: MediaQuery.of(context).size.height * .8,
              child: const Center(child: Text("There is no data"),),
              );
            }
          }
        ),
      ),
    );
  }
  Container buildComplainItem(BuildContext context, List<Complain> states, int index) {
    return Container(
      width: MediaQuery.of(context).size.width,

      padding: const EdgeInsets.symmetric(horizontal: 2 , vertical: 10 ),
      margin: const EdgeInsets.symmetric( vertical: 10 ),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),

      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 7,
            child: Row(
              children: [
                buildCircleShape(states[index].photo),
                const SizedBox(width: 10,),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:  [
                      Text( states[index].companyName.toString(),overflow: TextOverflow.ellipsis,maxLines: 1, style: boldTextStyle.copyWith (color: secondColor, fontSize: 18),),
                      const SizedBox(height: 8,),
                      Text( states[index].email.toString(),overflow: TextOverflow.ellipsis,maxLines: 1, style: semiBoldTextStyle.copyWith (color: secondColor, fontSize: 18),),
                      const SizedBox(height: 8,),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(child: Text(states[index].desc.trim()  , maxLines: 3, style: TextStyle (color: greyColor, fontSize: 16),)),
                        ],
                      ),

                    ],

                  ),
                ),
              ],
            ),
          ),

          Expanded(
            flex: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text( states[index].status, style: boldTextStyle.copyWith (color: mainColor, fontSize: 18),),
                  ],
                ),
                const SizedBox(height: 10,),
                states[index].status == "Pending" ?
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    BlocListener<ComplainBloc ,ComplainState>(
                      bloc: complainBloc,
                      listener: (context, snapshot) {
                        complainBloc.getComplains();
                         loadingDialog.hide();
                      },
                      child: CircleButton((){
                      loadingDialog.show();
                      complainBloc.acceptComplain(states[index].complainId!);
                    }  ,Icons.check, Colors.green,),
                    ),
                    CircleButton((){
                      loadingDialog.show();
                      complainBloc.rejectComplain(states[index].complainId!);
                    }  ,Icons.close, Colors.red,),
                    StreamBuilder<List<UserModel>>(
                      stream: rxSuggestions.stream,
                      builder: (context, snapshot) {
                        return CircleButton((){
                          loadingDialog.show();
                          showDialog(context: context, builder: (context)=> UsersDialog(snapshot.data??[] ,
                                  (String userId , String username){
                            Navigator.pop(context);
                            complainBloc.assignComplain(states[index].complainId!,userId,username);
                          }));

                        }  ,Icons.assignment_return, secondColor,);
                      }
                    )
                  ],
                ) : Container()
              ],
            ),
          )

        ],
      ),
    );
  }
  void getUsers() async{
    rxSuggestions.sink.add(await FirebaseService.getUsers());
  }
  buildCircleShape  (String? photo) {
    ImageProvider image ;
    if(photo != null ) {
      image = NetworkImage(photo);
    } else {
      image =  const AssetImage("assets/logo.jpg");
    }
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          border: Border.all(color: greyColor),
          image:  DecorationImage(
              image: image
          )
      ),
    );
  }

}

class UsersDialog extends StatelessWidget {
  final List<UserModel> users ;
  final Function(String a ,String b) onItemPressed ;

  const UsersDialog(this.users,this.onItemPressed,{Key? key}) : super(key: key);
  buildCircleShape  () {
    ImageProvider image ;
      image =  const AssetImage("assets/logo.jpg");

    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          border: Border.all(color: greyColor),
          image:  DecorationImage(
              image: image
          )
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: MediaQuery.of(context).size.width * .8,
        height: MediaQuery.of(context).size.height * .6,
        decoration:  BoxDecoration(
          color: bgColor
        ),
        child: ListView(
          children:[
            const SizedBox(height: 20,),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Choose user to assign " , style: boldTextStyle,),
              ],
            ),
            const SizedBox(height: 10,),
            ListView(
              shrinkWrap: true,
              children: users.map((e) => GestureDetector(
                onTap: (){
                  onItemPressed( e.id! , e.name );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  child: Row(
                    children: [
                      buildCircleShape(),
                      const SizedBox(width: 8,),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4,),
                            Text(e.name, style: semiBoldTextStyle,),
                            const SizedBox(height: 4,),
                            Text(e.email,overflow: TextOverflow.ellipsis,maxLines: 1, style: normalTextStyle,),
                            const SizedBox(height: 4,),
                            const Divider(height: 1,),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )).toList(),
            ),
          ]
        ),
      ),
    );
  }
}

class CircleButton extends StatelessWidget {
  final VoidCallback onPressed ;
  final Color borderColor ;
  final IconData iconData;
   const CircleButton( this.onPressed, this.iconData, this.borderColor, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        onPressed();
      },
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: borderColor)
        ),
        child: Icon(iconData, size: 20,color: borderColor,),
      ),
    );
  }
}
