import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo/core/controller/home_controller.dart';
import 'package:todo/ui/widgets/add_task_dialog.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  void _showDialog(BuildContext cntx) {
    showDialog(
      context: cntx,
      builder: (context) {
        return AddTaskDialog();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<HomeController>();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('All Tasks'),
        actions: [
          // Manual sync button
          IconButton(
            icon: Icon(Icons.sync),
            onPressed: () {
              ctrl.syncTasks();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Obx(() {
          // Show loading indicator
          if (ctrl.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          // Show empty state
          if (ctrl.tasks.isEmpty) {
            return const Center(
              child: Text(
                'No Tasks Found\nAdd your first task!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          // Show task list
          return ListView.builder(
            itemCount: ctrl.tasks.length,
            itemBuilder: (ctx, idx) {
              final task = ctrl.tasks[idx];
              final isPending = task.syncStatus == 'pending';

              return Card(
                margin: EdgeInsets.symmetric(vertical: 4),
                child: ListTile(
                  title: Text(task.title ?? 'No Title'),
                  subtitle: Text(
                    isPending ? 'Waiting to sync...' : 'Synced',
                    style: TextStyle(
                      color: isPending ? Colors.orange : Colors.green,
                      fontSize: 12,
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Sync status icon
                      Icon(
                        isPending ? Icons.cloud_upload : Icons.cloud_done,
                        color: isPending ? Colors.orange : Colors.green,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }),
      ),
      floatingActionButton: ElevatedButton.icon(
        label: Text('Add Task'),
        onPressed: () {
          _showDialog(context);
        },
        icon: Icon(Icons.add),
      ),
    );
  }
}
