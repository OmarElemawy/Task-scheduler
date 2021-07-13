
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:untitled1/shared/component/components.dart';
import 'package:untitled1/shared/component/constants.dart';
import 'package:untitled1/shared/cubit/cubit.dart';
import 'package:untitled1/shared/cubit/states.dart';


class Home extends StatelessWidget {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();

  var titleController= TextEditingController() ;
  var timeController= TextEditingController() ;
  var dateController= TextEditingController() ;

  Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return BlocProvider(
      create: (BuildContext context) =>DatabaseCubit()..createDataBase(),
      child: BlocConsumer<DatabaseCubit,DatabaseState>(
        builder: (BuildContext context,DatabaseState state) {
          var cubit = DatabaseCubit.get(context);
         return  Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text(cubit.title[cubit.onTapBottom]),
            ),
            floatingActionButton:
            FloatingActionButton(
              onPressed: () {

                if (cubit.isBottomSheet) {
                  if(formKey.currentState!.validate()) {
                    cubit.insertToDatabase
                      (title: titleController.text, time: timeController.text, date: dateController.text).
                    then((value) {
                      scaffoldKey.currentState!.showSnackBar( const SnackBar(content: Text("Task Added"),
                        backgroundColor: Colors.blue,elevation: 30,duration: Duration(milliseconds: 400),));
                      titleController.text="";
                      timeController.text="";
                      dateController.text="";
                      cubit.changeBottomSheetState(false);
                    });

                  }
                }
                else {
                  scaffoldKey.currentState!.showBottomSheet(
                        (context) => addTaskBottomSheet(context),
                    elevation: 30,
                  ).closed.then((value){
                    cubit.changeBottomSheetState(false);

                  });
                  cubit.changeBottomSheetState(true);

                }
              },
              child: cubit.isBottomSheet ? const Icon(Icons.add) : const Icon(Icons.edit),
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex:cubit.onTapBottom,
              items: const[
                BottomNavigationBarItem(
                  icon: Icon(Icons.view_headline_sharp), label: "NewTasks",),
                BottomNavigationBarItem(
                    icon: Icon(Icons.done_all), label: "DonTasks"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.archive), label: "ArchivedTasks"),
              ],
              elevation: 20,
              onTap: (value) {
                cubit.ChangeBottomNavBarIndex(value);
              },
            ),
            body:  cubit.listBody[cubit.onTapBottom],
          );
        },
        listener: (BuildContext context,DatabaseState state)
        {
          if(state is InsertDatabaseState)
            {
              Navigator.pop(context);
            }
        },

      ),
    );
  }



  Widget addTaskBottomSheet(context)
  {
     return Container(
       color: Colors.white,
       padding: const EdgeInsets.all(20),
       child: Form(
         key: formKey,
         child: Column(
           mainAxisSize: MainAxisSize.min,
           children: [
             defaultFormField(
               type: TextInputType.text,
               prefix: const Icon(Icons.title),
               label: "Title Task",
               controller: titleController,
               validator: (value){
                 if(value!.isEmpty)
                 {
                   return 'Title must not be empty';
                 }
                 return null;
               }
             ),
             const SizedBox(height: 20,),
             defaultFormField(
                 type: TextInputType.text,
                 prefix: const Icon(Icons.watch_later_outlined),
                 label: "Time Task",
                 controller: timeController,
                 validator: (value){
                   if(value!.isEmpty)
                   {
                     return 'Time must not be empty';
                   }
                   return null;
                 },
               onTap: (){
                    showTimePicker(context: context, initialTime: TimeOfDay.now(),).
                    then((value) {
                     timeController.text =value!.format(context);

                   });
               }
             ),
             const SizedBox(height: 20,),
             defaultFormField(
                 type: TextInputType.text,
                 prefix: const Icon(Icons.watch_later_outlined),
                 label: "Date Task",
                 controller: dateController,
                 validator: (value){
                   if(value!.isEmpty)
                   {
                     return 'Date must not be empty';
                   }
                   return null;
                 },
                 onTap: (){
                   showDatePicker(context: context,
                       initialDate: DateTime.now(),
                       firstDate:DateTime.now() ,
                       lastDate: DateTime.utc(2090)).then((value) {
                        dateController.text=DateFormat.yMMMd().format(value!);
                   });
                 }
             )
           ],
         ),
       ),
     );
  }

}

