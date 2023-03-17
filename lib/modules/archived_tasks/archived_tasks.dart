import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../components/components.dart';
import '../../shared/cubit.dart';
import '../../shared/states.dart';
class ArchiveTasks extends StatelessWidget {
  const ArchiveTasks({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener:(context,state) {},
      builder:(context,state) {
        var tasks=AppCubit.get(context).archivedTasks;
        return ListView.separated(
            itemBuilder: (context,index)=> BuildTaskItem(tasks[index],context),
            separatorBuilder:(context,index)=>Container(width: double.infinity,height: 1.0,color: Colors.grey[300],),
            itemCount: tasks.length);
      },

    );
  }
}
