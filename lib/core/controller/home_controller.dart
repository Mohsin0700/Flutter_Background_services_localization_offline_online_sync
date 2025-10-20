import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo/core/models/task_model.dart';
import 'package:todo/core/repos/task_repo.dart';

class HomeController extends GetxController {
  final TaskRepo taskRepo = TaskRepoImpl();
  final TextEditingController _taskController = TextEditingController();
  get taskController => _taskController;

  RxList<TaskModel> tasks = <TaskModel>[].obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    getTasks(); // Load tasks when controller initializes
  }

  Future<List<TaskModel>> getTasks() async {
    isLoading.value = true;
    tasks.value = await taskRepo.getTasks();
    isLoading.value = false;
    return tasks;
  }

  Future<bool> addTask() async {
    if (_taskController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Task title cannot be empty',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    bool res = await taskRepo.addTask(title: _taskController.text.trim());
    _taskController.clear();

    if (res) {
      Get.back();
      await getTasks(); // Refresh task list
      update();
    }
    return res;
  }

  // Manual sync button (optional - for testing)
  Future<void> syncTasks() async {
    Get.snackbar(
      'Syncing',
      'Syncing pending tasks...',
      backgroundColor: Colors.blue,
      colorText: Colors.white,
      duration: Duration(seconds: 1),
    );

    await taskRepo.syncPendingTasks();
    await getTasks(); // Refresh after sync

    Get.snackbar(
      'Success',
      'Tasks synced successfully',
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  @override
  void onClose() {
    _taskController.dispose();
    super.onClose();
  }
}
