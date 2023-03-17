import 'package:flutter/material.dart';
import 'package:todo/shared/cubit.dart';

Widget BuildTaskItem(Map model,context)=>Padding(
  padding: const EdgeInsets.all(20.0),
  child: Row(
    children: [
      CircleAvatar(
        backgroundColor: Colors.orange,
        radius: 40,
        child: Container(
          alignment: Alignment.center,
            child: Text('${model['data']}',style: const TextStyle(color: Colors.black),)),


      ),
      const SizedBox(width: 20.0,),
      Expanded(
        child: Column(
         // mainAxisSize: MainAxisSize.min,
           // mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text('${model['title']}',style:const TextStyle(color: Colors.white) ,),
            Text('${model['time']}',style: TextStyle(color:Colors.grey[400]),)
          ],
        ),
      ),
      const SizedBox(width: 20.0,),
      IconButton(onPressed: ()
      {
        AppCubit.get(context).updateData(status: 'Done', id: model['id']);
      }, icon: const Icon(Icons.check_box_rounded,color: Colors.orange,)),
      IconButton(onPressed: (){
        AppCubit.get(context).updateData(status: 'Archived', id: model['id']);
      }, icon: const Icon(Icons.archive,color: Colors.orange,)),
    ],
  ),
);