import 'package:get/get.dart';
import 'package:todo/core/models/task_model.dart';
import 'package:todo/core/repos/task_repo.dart';

class HomeController extends GetxController {
  final TaskRepo taskRepo = TaskRepoImpl();

  Future<List<TaskModel>> getTasks() => taskRepo.getTasks();
}
