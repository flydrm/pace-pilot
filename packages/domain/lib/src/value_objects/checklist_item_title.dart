class ChecklistItemTitle {
  ChecklistItemTitle(String value) : value = value.trim() {
    if (this.value.isEmpty) {
      throw const ChecklistItemTitleEmptyException();
    }
  }

  final String value;

  @override
  String toString() => value;
}

class ChecklistItemTitleEmptyException implements Exception {
  const ChecklistItemTitleEmptyException();
}
