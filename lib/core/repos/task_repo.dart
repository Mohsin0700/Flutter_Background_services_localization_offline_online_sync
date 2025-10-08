import 'package:todo/core/models/task_model.dart';
import 'package:todo/core/services/network_service.dart';

abstract class TaskRepo {
  Future<List<TaskModel>> getTasks();
}

class TaskRepoImpl implements TaskRepo {
  final NetworkService networkService = NetworkService();
  TaskRepoImpl();

  @override
  Future<List<TaskModel>> getTasks() async {
    try {
      final res = await networkService.getRequest(endPoint: 'tasks');
      print('Result From Repository::::::::::::::::::::::::::::::$res');
      return (res as List).map((e) => TaskModel.fromJson(e)).toList();
    } catch (e) {
      throw Exception('Failed to fetch items: $e');
    }
  }
}
