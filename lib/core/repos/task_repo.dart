import 'package:todo/core/models/task_model.dart';
import 'package:todo/core/services/network_service.dart';
import 'package:todo/core/services/local_service.dart';

abstract class TaskRepo {
  Future<List<TaskModel>> getTasks();
  Future<bool> addTask({required String title});
  Future<bool> syncPendingTasks();
}

class TaskRepoImpl implements TaskRepo {
  final NetworkService networkService = NetworkService();
  final LocalService localService = LocalService();

  TaskRepoImpl();

  @override
  Future<List<TaskModel>> getTasks() async {
    // STEP 1: Load from local FIRST (always works, even offline)
    List<TaskModel> localTasks = await localService.getTasks();
    print('Loaded ${localTasks.length} tasks from local storage');

    // STEP 2: Try to fetch from server (if online)
    try {
      bool isOnline = await NetworkService.checkConnection();

      if (isOnline) {
        final res = await networkService.getRequest(endPoint: 'tasks');
        List<TaskModel> serverTasks = (res as List)
            .map((e) => TaskModel.fromJson(e))
            .toList();

        print('Fetched ${serverTasks.length} tasks from server');

        // STEP 3: Save server tasks to local storage
        await localService.saveTaskListLocally(serverTasks);

        // STEP 4: Sync any pending local tasks
        await syncPendingTasks();

        // STEP 5: Return fresh data from local (now updated)
        return await localService.getTasks();
      }
    } catch (e) {
      print('Failed to fetch from server, using local data: $e');
    }

    // STEP 6: Return local tasks (if offline or server failed)
    return localTasks;
  }

  @override
  Future<bool> addTask({required String title}) async {
    try {
      // STEP 1: Create task with local ID
      TaskModel newTask = TaskModel(
        localId: TaskModel.generateLocalId(),
        title: title,
        syncStatus: 'pending',
        createdAt: DateTime.now(),
      );

      // STEP 2: Save to local storage FIRST (instant, always works)
      bool savedLocally = await localService.saveTask(newTask);

      if (!savedLocally) {
        return false;
      }

      print('Task saved locally: ${newTask.localId}');

      // STEP 3: Try to sync to server (if online)
      try {
        bool isOnline = await NetworkService.checkConnection();

        if (isOnline) {
          bool sentToServer = await networkService.postRequest(
            endPoint: 'tasks',
            data: newTask.toJson(),
          );

          if (sentToServer) {
            // Note: We don't have server ID yet from this response
            // In real app, server should return the created task with _id
            // For now, we'll mark as synced
            await localService.updateTaskSyncStatus(newTask.localId!, 'synced');
            print('Task synced to server');
          }
        } else {
          print('Offline: Task will sync later');
        }
      } catch (e) {
        print('Failed to sync to server, will retry later: $e');
      }

      return true;
    } catch (e) {
      print('Error adding task: $e');
      return false;
    }
  }

  @override
  Future<bool> syncPendingTasks() async {
    try {
      // Get all pending tasks
      List<TaskModel> pendingTasks = await localService.getPendingTasks();

      if (pendingTasks.isEmpty) {
        print('No pending tasks to sync');
        return true;
      }

      print('Syncing ${pendingTasks.length} pending tasks...');

      // Try to send each pending task
      for (var task in pendingTasks) {
        try {
          bool success = await networkService.postRequest(
            endPoint: 'tasks',
            data: task.toJson(),
          );

          if (success) {
            // Update status to synced
            await localService.updateTaskSyncStatus(task.localId!, 'synced');
            print('Synced task: ${task.localId}');
          }
        } catch (e) {
          print('Failed to sync task ${task.localId}: $e');
        }
      }

      return true;
    } catch (e) {
      print('Error in syncPendingTasks: $e');
      return false;
    }
  }
}
