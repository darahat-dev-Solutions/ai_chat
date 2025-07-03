import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/task_model.dart';
import '../infrastructure/task_repository.dart';

/// Used to indicate loading status in the UI
final taskLoadingProvider = StateProvider<bool>((ref) => false);

/// Main Task Controller connected to Hive-backed TaskRepository
class TaskController extends StateNotifier<List<TaskModel>> {
  final TaskRepository _repo;
  final Ref ref;

  TaskController(this._repo, this.ref) : super([]) {
    Future.microtask(() => getTask());
  }

  /// Load all tasks from repository
  Future<void> getTask() async {
    ref.read(taskLoadingProvider.notifier).state = true;

    final tasks = await _repo.getTasks();
    state = tasks.where((task) => task.isCompleted == false).toList();

    ref.read(taskLoadingProvider.notifier).state = false;
  }

  /// Add a new task and reload list
  Future<void> addTask(String text) async {
    final task = await _repo.addTask(text);
    if (task != null) {
      await getTask(); // reload state
    }
  }

  /// Toggle a task and reload list
  Future<void> toggleTask(String tid) async {
    await _repo.toggleTask(tid);
    await getTask();
  }

  /// Remove a task and reload list
  Future<void> removeTask(String id) async {
    await _repo.removeTask(id);
    await getTask();
  }

  /// Edit a task and reload list
  Future<void> editTask(String id, String newText) async {
    await _repo.editTask(id, newText);
    await getTask();
  }
}
