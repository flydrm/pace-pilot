class TaskTitle {
  TaskTitle(String value) : value = value.trim() {
    if (this.value.isEmpty) {
      throw const TaskTitleEmptyException();
    }
  }

  final String value;

  @override
  String toString() => value;
}

class TaskTitleEmptyException implements Exception {
  const TaskTitleEmptyException();
}
