import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled1/shared/component/components.dart';
import 'package:untitled1/shared/cubit/cubit.dart';
import 'package:untitled1/shared/cubit/states.dart';

class New extends StatelessWidget {
  const New({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DatabaseCubit,DatabaseState>(
      builder: (BuildContext context,DatabaseState state) {
        var task = DatabaseCubit.get(context).newTasks;
        return listOfTasks(task: task);
      },
      listener: (BuildContext context,DatabaseState state) {},
    );
  }
}
