import 'package:get/get.dart';
import 'package:to_do_list/database/db_helper.dart';
import 'package:to_do_list/models/task.dart';

class TaskController extends GetxController {
  final RxList<Task> taskList = <Task>[].obs;

  Future<int> addTask({Task? task}) {
    return DBHelper.insert(task);
  }

  // func to get data from database (reading data from db)
  Future<void> getTasks() async {
    final List<Map<String, dynamic>> tasks = await DBHelper.query();
    taskList.assignAll(tasks.map((data) => Task.fromJson(data)));
  }

  void deletTask(Task task) async {
    await DBHelper.delete(task);
    getTasks(); // fectching data from db after delete task
  }

  void deleteAllTasks() async {
    await DBHelper.deleteAll();
  }

  void markTaskDone(int id) async {
    await DBHelper.update(id);
    getTasks();
  }
}
