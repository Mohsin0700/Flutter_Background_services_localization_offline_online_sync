import 'package:hive_ce/hive.dart';
import 'package:todo/core/models/task_model.dart';

class LocalService {
  static const String _boxName = 'tasks';

  // Get all tasks from Hive
  Future<List<TaskModel>> getTasks() async {
    var tasksBox = await Hive.openBox(_boxName);
    List<TaskModel> tasks = [];

    for (var key in tasksBox.keys) {
      var taskData = tasksBox.get(key);
      if (taskData is Map) {
        tasks.add(TaskModel.fromLocalJson(Map<String, dynamic>.from(taskData)));
      }
    }

    return tasks;
  }

  // Save single task to Hive
  Future<bool> saveTask(TaskModel task) async {
    try {
      var tasksBox = await Hive.openBox(_boxName);
      await tasksBox.put(task.localId, task.toLocalJson());
      return true;
    } catch (e) {
      print('Error saving task locally: $e');
      return false;
    }
  }

  // Get all PENDING tasks (not synced yet)
  Future<List<TaskModel>> getPendingTasks() async {
    var allTasks = await getTasks();
    return allTasks.where((task) => task.syncStatus == 'pending').toList();
  }

  // Update task sync status
  Future<bool> updateTaskSyncStatus(
    String localId,
    String newStatus, {
    String? serverId,
  }) async {
    try {
      var tasksBox = await Hive.openBox(_boxName);
      var taskData = tasksBox.get(localId);

      if (taskData != null && taskData is Map) {
        var task = TaskModel.fromLocalJson(Map<String, dynamic>.from(taskData));
        task.syncStatus = newStatus;
        if (serverId != null) {
          task.sId = serverId;
        }
        await tasksBox.put(localId, task.toLocalJson());
        return true;
      }
      return false;
    } catch (e) {
      print('Error updating sync status: $e');
      return false;
    }
  }

  // Save multiple tasks (for sync from server)
  Future<bool> saveTaskListLocally(List<TaskModel> tasks) async {
    try {
      var tasksBox = await Hive.openBox(_boxName);
      for (var task in tasks) {
        await tasksBox.put(task.localId, task.toLocalJson());
      }
      return true;
    } catch (e) {
      print('Error saving tasks locally: $e');
      return false;
    }
  }

  // Clear all tasks
  Future<bool> clearAllTasks() async {
    try {
      var tasksBox = await Hive.openBox(_boxName);
      await tasksBox.clear();
      return true;
    } catch (e) {
      print('Error clearing tasks: $e');
      return false;
    }
  }
}
