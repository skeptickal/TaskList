import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:task_list_app/models/task.dart';
import 'package:task_list_app/service/task_service.dart';
part 'task_state.dart';

class TaskCubit extends Cubit<TaskState> {
  final TaskService taskService;

  TaskCubit({TaskService? taskService}) : taskService = taskService ?? TaskService(), super(TaskInitial());

  Future<void> addTask({required Task taskName}) async {
    try {
      await taskService.addTask(taskName: taskName);
      emit(
        state.copyWith(
          taskNames: [...state.taskNames, taskName],
          completedTasks: state.completedTasks,
        ),
      );
    } catch (e) {
      print('Error adding task: $e');
    }
  }

  Future<void> readTasks() async {
    final List<Task> tasks = await taskService.readTasks();
    emit(state.copyWith(
      taskNames: [...tasks],
    ));
  }

  void completeTask({required Task taskName}) {
    emit(
      state.copyWith(
        completedTasks: [...state.completedTasks, taskName],
      ),
    );
    emit(state.removeTask(taskName));
  }

  void deleteTask({required Task taskName}) {
    emit(state.deleteTask(taskName));
  }
}
