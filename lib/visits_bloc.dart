import 'package:rxdart/subjects.dart';
import 'package:saleing/firebase_service.dart';
import 'package:saleing/model/item.dart';

class VisitBloc {
  BehaviorSubject<List<Visit>?> rxVisits = BehaviorSubject();

  getVisits ()async{
    List<Visit>? list = await FirebaseService.getVisits();
    rxVisits.sink.add(list);
  }
}