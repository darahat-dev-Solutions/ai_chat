import 'package:hive/hive.dart';
import 'package:opsmate/core/services/hive_service.dart';

import '../domain/task_model.dart';

class TaskRepository {
  Box<TaskModel> get _box => HiveService.taskBox;

  Future<List<TaskModel>> getTasks() async {
    return _box.values.toList();
  }

  Future<TaskModel?> addTask(String text) async {
    final key = DateTime.now().millisecondsSinceEpoch.toString();
    final task = TaskModel(
      tid: key,
      title: text,
      isCompleted: false,
      taskCreationTime: DateTime.now().toIso8601String(),
    );
    await _box.put(key, task);
    return task;
  }

  Future<void> toggleTask(String tid) async {
    final task = _box.get(tid);
    if (task != null) {
      final updated = task.copyWith(isCompleted: !task.isCompleted);
      await _box.put(tid, updated);
    }
  }

  Future<void> removeTask(String tid) async {
    await _box.delete(tid);
  }

  Future<void> editTask(String tid, String newText) async {
    final task = _box.get(tid);
    if (task != null) {
      final updated = task.copyWith(title: newText);
      await _box.put(tid, updated);
    }
  }
}
