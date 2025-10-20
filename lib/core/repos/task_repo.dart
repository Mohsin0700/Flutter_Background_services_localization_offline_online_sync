import 'package:todo/core/models/task_model.dart';
import 'package:todo/core/services/network_service.dart';

abstract class TaskRepo {
  Future<List<TaskModel>> getTasks();
  Future<bool> addTask({required String title});
}

class TaskRepoImpl implements TaskRepo {
  final NetworkService networkService = NetworkService();
  TaskRepoImpl();

  @override
  Future<List<TaskModel>> getTasks() async {
    // Fetch tasks from local storage

    try {
      final res = await networkService.getRequest(endPoint: 'tasks');
      print('Get Result From Repository::::::::::::::::::::::::::::::$res');
      return (res as List).map((e) => TaskModel.fromJson(e)).toList();
    } catch (e) {
      throw Exception('Failed to fetch items: $e');
    }
  }

  @override
  Future<bool> addTask({required String title}) async {
    try {
      print('Sending task data: ${TaskModel(title: title, sId: '').toJson()}');
      bool result = await networkService.postRequest(
        endPoint: 'tasks',
        data: {'title': title},
      );
      return result;
    } catch (e) {
      print('Error occurred while adding task from repo function: $e');
      return false;
    }
  }
}
