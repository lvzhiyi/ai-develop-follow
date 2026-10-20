/// One immutable record. Identity and creation order do not depend on its title.
class TodoItem {
  const TodoItem({
    required this.id,
    required this.title,
    required this.creationOrder,
    this.isCompleted = false,
  });

  final int id;
  final String title;
  final bool isCompleted;
  final int creationOrder;
}
