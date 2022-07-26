import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:to_do/db/db_helper.dart';
import 'package:to_do/ui/widgets/components/components.dart';
import '../models/task.dart';

class TaskController extends GetxController{
  //use obs to transform list to stream list to listen to changes in the list
  final RxList taskList=<Task>[].obs;

    getTasks() async{
     final List<Map<String,dynamic>> task=await DBHelper.query();
     taskList.assignAll(task.map((data) => Task.fromMap(data)).toList());
    }
    addTask(Task task)async{
      taskList.add(task);
     return await  DBHelper.insertTask(task);

    }
    deleteTask(int id)async{
      taskList.removeWhere((task)=>task.id==id);
     await DBHelper.deleteTask(id).then((value) {
       showToast(text:'successfully delete', state:ToastStates.SUCCESS);
        print('success delete task');
      }).catchError((error){
        print(error.toString());
      });
      getTasks();
    }
    deleteAllTasks()async{
     await DBHelper.deleteAllTask().then((value) {
       taskList.clear();
        print('success delete all tasks ');
       showToast(text:'successfully delete', state:ToastStates.SUCCESS);
     }).catchError((error){
       print(error.toString());
     });

    }

    updateISCompletedMark(int id)async{
     await DBHelper.updateTask(id);
      getTasks();
  }



  }

