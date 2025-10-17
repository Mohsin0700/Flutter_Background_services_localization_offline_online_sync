import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo/core/controller/home_controller.dart';

class AddTaskDialog extends StatelessWidget {
  const AddTaskDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final homeController = Get.find<HomeController>();
    return AlertDialog(
      title: const Text('Add New Task'),
      content: TextField(
        controller: homeController.taskController,
        decoration: const InputDecoration(hintText: 'Task Title'),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () async {
            bool res = await homeController.addTask();
            if (res) {
              Get.snackbar(
                'Success',
                'Task added successfully',
                backgroundColor: Colors.green,
                colorText: Colors.white,
              );
            } else {
              Get.snackbar(
                'Error',
                'Failed to add task',
                backgroundColor: Colors.red,
                colorText: Colors.white,
              );
            }
          },
          child: const Text('Add Task'),
        ),
      ],
    );
  }
}
