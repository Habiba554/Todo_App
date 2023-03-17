import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/shared/cubit.dart';
import 'package:todo/shared/states.dart';
import 'package:intl/intl.dart';


class HomaLayout extends StatelessWidget {
  HomaLayout({super.key});
  final  text=TextEditingController();
  final time=TextEditingController();
  final date=TextEditingController();
  final GlobalKey<FormState> formkey=GlobalKey<FormState>();



  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context)=>AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit,AppStates>(
        listener:(BuildContext context,AppStates state){
          if(state is AppInsertToDataBaseState)
            {
              Navigator.pop(context);
            }
        } ,
        builder: (BuildContext context,AppStates state)
        {
          return Scaffold(
            backgroundColor: const Color.fromARGB(92, 37, 34, 34),
            key:  AppCubit.get(context).key,
            appBar: AppBar(title: Text(AppCubit.get(context).app[AppCubit.get(context).currind],),backgroundColor: const Color.fromARGB(202, 10, 0, 0),
              centerTitle: true,),
            floatingActionButton: FloatingActionButton(onPressed: ()
            {
              if(AppCubit.get(context).flag)
              {
                if(formkey.currentState!.validate())
                  {
                    AppCubit.get(context).insertToDatabase(title: text.text, time: time.text,date:  date.text);
                  }

              }
              else
              {

                AppCubit.get(context).gets()!.showBottomSheet((context) => Container(
                  height: 200,
                  width: double.infinity,
                  color:const Color.fromARGB(202, 10, 0, 0) ,
                  child: SingleChildScrollView(
                    child: Form(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      key: formkey,
                      child: Column(
                        mainAxisSize:MainAxisSize.min,
                        children: [
                          TextFormField(
                            controller:  text,
                            style: TextStyle(color:Colors.grey[200]),
                            decoration: InputDecoration(
                              label: Text('Task Title',style: TextStyle(color: Colors.grey[200]),),
                              prefixIcon:Icon(Icons.title,color:Colors.grey[200] ,
                              ),

                            )
                            ,keyboardType: TextInputType.text,
                            validator: (String?value)
                            {
                              if(value!.isEmpty)
                              {
                                return "title must not empty";
                              }
                              return null;
                            },

                          ),
                          const SizedBox(height: 15.0,),
                          TextFormField(
                            style: TextStyle(color:Colors.grey[200]),
                            controller: time,
                            onTap: (){
                              showTimePicker(context: context, initialTime: TimeOfDay.now(),).then((value)
                              {
                                time.text=value!.format(context);
                              });
                            },
                            decoration: InputDecoration(
                              label: Text('Time Title',style: TextStyle(color: Colors.grey[200]),),
                              prefixIcon:Icon(Icons.watch_later,color:Colors.grey[200] ,
                              ),

                            )
                            ,keyboardType: TextInputType.datetime,
                            validator: (value)
                            {
                              if(value!.isEmpty)
                              {
                                return "time must not empty";
                              }
                              return null;
                            },

                          ),
                          const SizedBox(height: 15.0,),
                          TextFormField(
                            style: TextStyle(color:Colors.grey[200]),
                            controller: date,
                            onTap: (){
                              showDatePicker(context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime.parse("2030-05-01")).then((value)
                              {
                                date.text=DateFormat.yMMMd().format(value!);
                              });
                            },
                            decoration: InputDecoration(
                              label: Text('Time Title',style: TextStyle(color: Colors.grey[200]),),
                              prefixIcon:Icon(Icons.calendar_month_outlined,color:Colors.grey[200] ,
                              ),

                            )
                            ,keyboardType: TextInputType.datetime,
                            validator: (value)
                            {
                              if(value!.isEmpty)
                              {
                                return "time must not empty";
                              }
                              return null;
                            },

                          )
                        ],),
                    ),
                  ),

                )).closed.then((value)
                {

                  AppCubit.get(context).flag=false;
                  AppCubit.get(context).changebottomsheetState(isShow: false, Icon: Icons.edit);
                });
                AppCubit.get(context).flag=true;
                AppCubit.get(context).changebottomsheetState(isShow: true, Icon: Icons.add);
              }
            },backgroundColor: const Color.fromARGB(202, 10, 0, 0) ,
              child: Icon(AppCubit.get(context).icon,color: Colors.orange,),) ,
            bottomNavigationBar: BottomNavigationBar(
              backgroundColor: const Color.fromARGB(202, 10, 0, 0),
              unselectedItemColor: Colors.white,
              currentIndex: AppCubit.get(context).currind,
              selectedItemColor: Colors.orange,
              elevation: 0.0,
              onTap: (index)
              {
                AppCubit.get(context).changeindex(index);

              },
              items:
              const [
                BottomNavigationBarItem(icon: Icon(Icons.menu,),label: 'Tasks',),
                BottomNavigationBarItem(icon: Icon(Icons.check_circle_outline,),label: 'Done',),
                BottomNavigationBarItem(icon: Icon(Icons.archive_outlined),label: 'Archived'),

              ],),
            body: AppCubit.get(context).screens[AppCubit.get(context).currind]
          );
        },

      ),
    );
  }
}



