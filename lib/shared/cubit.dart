import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/shared/states.dart';
import 'package:flutter/material.dart';
import '../Modules/Archived_Tasks/archived_tasks.dart';
import '../Modules/Done_Tasks/done_tasks.dart';
import '../Modules/New_Tasks/new_tasks.dart';


class AppCubit extends Cubit<AppStates>
{
  List<Map> data=[];
  List<Map>  newTasks=[];
  List<Map> doneTasks=[];
  List<Map> archivedTasks=[];

  AppCubit():super(AppInitialState());
  static AppCubit get(context)=>BlocProvider.of(context);
  late int currind=0;
  List<Widget> screens=[NewTasks(),DoneTasks(),ArchiveTasks()];
  List<String> app=['New Tasks','Done Tasks','Archived Tasks'];
  bool flag=false;
  IconData icon=Icons.edit;
   void changeindex(int index)
  {
    currind=index;
    emit(AppChangeBottomNavBarState());
  }
   Database? database;
  void createDatabase()
  {

     openDatabase('todo.db',version: 1,
        onCreate: (database,version)
        {
          print('create database');
          database.execute('CREATE TABLE tasks (id INTEGER PRIMARY KEY,title TEXT,data TEXT,time TEXT,status TEXT)').then((value)
          {
            print('table created');
          }
          ).catchError((error)
          {
            print('Error when creating database ${error.toString()}');
          });
        },
        onOpen: (database)
        {
          getFromDatabase(database);
          print('open database');
        }
    ).then((value)
     {
       database=value;
       emit(AppCreateDataBaseState());
     });
  }
  insertToDatabase({required String title,
    required String time,
    required String date,}) async
  {


    await database?.transaction((txn)
    async{
      txn.rawInsert('INSERT INTO tasks(title,data,time,status) VALUES("$title","$time","$date","New")').then((value) {
        print('$value Inserted successfully');
        emit(AppInsertToDataBaseState());
        getFromDatabase(database);
      }).catchError((error){
        print('Error when inserting database ${error.toString()}');
      });
      return null;
    });
  }
  void getFromDatabase(database)
  {
    newTasks=[];
    doneTasks=[];
    archivedTasks=[];
    emit(AppGetDatabaseState());
     database.rawQuery('SELECT * FROM tasks').then((value) {
      data = value;
      //print(data);
      value.forEach((element)
      {
        if(element['status']=='New')
        {
          //newTasks=value;
          newTasks.add(element);
        }
        else if(element['status']=='Done')
        {
          doneTasks.add(element);
        }
        else
        {
          archivedTasks.add(element);
        }
      });
      emit(AppGetDatabaseState());
    });

  }

   void updateData({required String status,required int id})
   {
       database?.rawUpdate(
         'UPDATE tasks SET status = ? WHERE id = ?',
         [status, '$id']).then((value) {
           getFromDatabase(database);
           emit(AppUpdateStatus());

      }).catchError((error)
          {
            print('Error when updating database ${error.toString()}');
          }
      );

   }
  void changebottomsheetState({required bool isShow,required IconData Icon})
  {
     flag=isShow;
     icon=Icon;
     emit(AppChangeBottomSheetState());
  }
  var key=GlobalKey<ScaffoldState>();
  ScaffoldState? gets()
  {
   return key.currentState;
  }

}

