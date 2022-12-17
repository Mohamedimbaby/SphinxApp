import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:saleing/firebase_service.dart';
import 'package:saleing/model/complain.dart';
import 'package:saleing/screens/add_account/add_account_bloc.dart';

class ComplainBloc extends Cubit<ComplainState>{
ComplainBloc():super(ComplainState());
    getComplains ()async{
      try
      {
       List<Complain>  result = await FirebaseService.getComplains();
       emit(ListingComplainState(result));
      }
    catch(e){
            emit(ListingComplainState([]));
        }
      }
    addComplain(List<XFile> images ,Complain complain)async{
      try
       {
         await FirebaseService.addComplain(images , complain);
         emit(AddComplainSuccess(BlocState.success));
       }
        catch(e){
          emit(AddComplainSuccess(BlocState.error));
       }
    }
    acceptComplain(String complainId)async{
      try
       {
         await FirebaseService.acceptComplain(complainId);
         emit(AddComplainSuccess(BlocState.success));
       }
        catch(e){
          emit(AddComplainSuccess(BlocState.error));
       }
    }
    rejectComplain(String complainId)async{
      try
       {
         await FirebaseService.rejectComplain(complainId);
         emit(AddComplainSuccess(BlocState.success));
       }
        catch(e){
          emit(AddComplainSuccess(BlocState.error));
       }
    }
    assignComplain(String complainId , String userId , String username  )async{
      try
       {
         await FirebaseService.assignComplain(complainId,userId, username);
         emit(AddComplainSuccess(BlocState.success));
       }
        catch(e){
          emit(AddComplainSuccess(BlocState.error));
       }
    }
  }

class ComplainState {
}

  class ListingComplainState extends ComplainState{
  List<Complain> complains ;

  ListingComplainState(this.complains);

  }
  class AddComplainSuccess extends ComplainState{
    BlocState state;
    AddComplainSuccess(this.state) ;
  } class AddComplainError extends ComplainState{
    String error;
    AddComplainError(this.error) ;
  }
  class ErrorComplainSuccess{
    ErrorComplainSuccess();
  }