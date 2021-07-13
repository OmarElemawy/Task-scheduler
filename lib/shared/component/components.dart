import 'package:flutter/material.dart';
import 'package:untitled1/shared/cubit/cubit.dart';

Widget defaultFormField({
   double borderRadius=20,
   required Icon prefix,
   required String label,
   required TextEditingController controller,
   required TextInputType type,
   onSubmit,
   onChanged,
   validator,
   onTap,
   suffix
        })=>
    TextFormField
      (
        decoration: InputDecoration(
           border: OutlineInputBorder(
           borderRadius: BorderRadius.circular(borderRadius),
             ),
          prefixIcon: prefix,
          suffixIcon: suffix,
          labelText: label,
        ),
      controller: controller,
      keyboardType: type,
      onFieldSubmitted: onSubmit,
      onChanged:onChanged,
      validator: validator,
      onTap: onTap ,
    );
  Widget itemOfTasks(tasks,context) {
    return Dismissible(
      onDismissed: (direction)
      {
        DatabaseCubit.get(context).deleteDate(id: tasks['id']);
      },
      key:Key(tasks['id'].toString()),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(children: [
          CircleAvatar(child:
          Center(child:
          Text(tasks["time"], style: const TextStyle(color: Colors.white),)),
            radius: 40, backgroundColor: Colors.blue,),
          const SizedBox(width: 20,),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(tasks["title"], style: const TextStyle(color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),),

                Text(tasks["date"],
                  style: const TextStyle(color: Colors.grey, fontSize: 13),),
              ],
            ),
          ),
          const SizedBox(width: 20,),
          IconButton(onPressed: (){
            DatabaseCubit.get(context).upDate(state: "Don", id:tasks['id']);
          },  icon: const Icon(Icons.check_box,color: Colors.blue,)),
          IconButton(onPressed: (){
            DatabaseCubit.get(context).upDate(state: "archive", id:tasks['id']);
          }, icon: const Icon(Icons.archive,color: Colors.black54,)),
        ],
        ),
      ),
    );
  }

  Widget listOfTasks (
{
  required task
}
)
  {
    return task.isNotEmpty ? Center(
      child: ListView.separated(
          itemBuilder: (context, index) => itemOfTasks(task[index],context),
          separatorBuilder: (context, index) =>
              Container(color: Colors.grey, child:
              const SizedBox(height: 2, width: double.infinity,)),
          itemCount:task.length),
    ):
    Center(child:
    Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const[
        Icon(Icons.view_headline_sharp,color: Colors.grey,size: 100,),
        Text("No tasks yet , please add some tasks",style: TextStyle(color: Colors.black87,fontSize: 20),)
      ],
    ),);
  }
