import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saleing/firebase_service.dart';
import 'package:saleing/model/User.dart';
enum BlocState {
  success , error , initialize
}
class RequestState{
  BlocState state ;
  String? error ;

  RequestState(this.state);
  RequestState.error(this.state, this.error);
  RequestState.success(this.state);
}
class AddAccountBloc extends Cubit<RequestState>{

  AddAccountBloc():super(RequestState(BlocState.initialize));

  addAccount (UserModel model)async{
    try {
      await FirebaseService.registerOnFirebase(model);
    }catch(e){
      emit(RequestState.error(BlocState.error,e.toString()));
    }
    emit(RequestState.success(BlocState.success));

  }

}
