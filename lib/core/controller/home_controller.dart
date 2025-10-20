import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo/core/models/task_model.dart';
import 'package:todo/core/repos/task_repo.dart';

class HomeController extends GetxController {
  final TaskRepo taskRepo = TaskRepoImpl();
  final TextEditingController _taskController = TextEditingController();
  get taskController => _taskController;
  RxList<TaskModel> tasks = <TaskModel>[].obs;

  Future<List<TaskModel>> getTasks() async {
    // var taskBox = await Hive.openBox('tasks');
    tasks.value = await taskRepo.getTasks();
    return tasks;
  }

  Future<bool> addTask() async {
    bool res = await taskRepo.addTask(title: _taskController.text);
    _taskController.clear();
    if (res) {
      Get.back();
      getTasks();
      update();
    }
    return res;
  }
}
