
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:untitled1/modules/archived_task/archived.dart';
import 'package:untitled1/modules/don_task/don.dart';
import 'package:untitled1/modules/new_task/new.dart';
import 'package:untitled1/shared/cubit/states.dart';

class DatabaseCubit extends Cubit<DatabaseState>{
  DatabaseCubit() : super(InitialState());
  static DatabaseCubit get(context) => BlocProvider.of(context);
  late Database database;
  List<Map> tasks =[];
  List<Map> newTasks =[];
  List<Map> donTasks =[];
  List<Map> archiveTasks =[];
  bool isBottomSheet = false;
  List<String> title = [
    "NewTasks",
    "DonTasks",
    "Archived",
  ];
  int onTapBottom = 0;
  List<Widget> listBody = [
    const New(),
    const Don(),
    const Archived(),
  ];
  void ChangeBottomNavBarIndex(int index)
  {
    onTapBottom=index;
    emit(ChangeBottomNavBarState());
  }
  void createDataBase()
  {
     openDatabase(
        'todo.db',
        version: 2,
        onCreate: (database, version) {
          print("Create DataBase");
          database.execute(
              'CREATE TABLE tasks (id INTEGER PRIMARY KEY,title TEXT,date TEXT,time TEXT,status TEXT)')
              .then((value) {
            print("Create Table");
          }).catchError((error) {
            print('Error is${error.toString()}');
          });
        },
        onOpen: (database) {
          getDataFromDatabase(database);
        }
    ).then((value)
     {
       database=value;
       emit(CreateDatabaseState());
     });
  }
  void getDataFromDatabase(database)
  {
    newTasks=[];
    donTasks=[];
    archiveTasks=[];

     database.rawQuery('SELECT * FROM tasks').then(
             (value)  {
       tasks=value;
       tasks.forEach((element) {
             if(element['status']=='new') {
               newTasks.add(element);
             }
             else if(element['status']=='Don') {
               donTasks.add(element);
             }else{
               archiveTasks.add(element);
             }
       });
       emit(GetDatabaseState());
     });
  }
  Future insertToDatabase({required String title,required String time,required String date})async
  {
     return await database.transaction((txn) {
    return   txn.rawInsert('INSERT INTO tasks( title, date, time, status) VALUES("$title","$date","$time","new")').
      then((value) {
       print("$value insert Don");
       emit(InsertDatabaseState());
         getDataFromDatabase(database);

      }).catchError((error){
        print(error.toString());
      });
   });
  }

  void changeBottomSheetState(value)
  {
     isBottomSheet=value;
     emit(ChangeBottomSheetState());
  }
  void upDate({required String state,required int id})
  {
    database.rawUpdate(
        'UPDATE tasks SET  status = ? WHERE id = ?',
         [ "$state" , id ]).then((value)
    {
         emit(UbDateDataBaseState());
         getDataFromDatabase(database);
    }
    ).then((value) {
      print(value);
    });

  }
  void deleteDate({required int id})
  {
    database.rawDelete(
        'DELETE FROM tasks WHERE id = ?',
        [ '$id' ]).then((value)
    {
      emit(DeleteDataBaseState());
      getDataFromDatabase(database);
    }
    ).then((value) {
      print(value);
    });

  }
}


