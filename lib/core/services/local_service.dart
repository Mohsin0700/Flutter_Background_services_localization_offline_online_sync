import 'package:hive_ce/hive.dart';
import 'package:todo/core/models/task_model.dart';

class LocalService {
  Future<List<TaskModel>> getTasks() async {
    // Implementation for fetching tasks from local storage
    var tasksBox = await Hive.openBox('tasks');
    return tasksBox.values.cast<TaskModel>().toList();
  }

  Future<bool> saveTaskListLocally(List<TaskModel> tasks) async {
    try {
      var tasksBox = await Hive.openBox('tasks');
      await tasksBox.clear();
      for (var task in tasks) {
        await tasksBox.add(task);
      }
      return true;
    } catch (e) {
      print('Error saving tasks locally: $e');
      return false;
    }
  }
}
