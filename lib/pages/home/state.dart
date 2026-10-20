import 'model.dart';

class HomeState {
  HomeState({Iterable<TodoItem> todos = const []}) : todos = _snapshot(todos);

  final List<TodoItem> todos;

  static List<TodoItem> _snapshot(Iterable<TodoItem> input) {
    final items = input.toList();
    final identities = <int>{};
    for (final item in items) {
      if (!identities.add(item.id)) {
        throw ArgumentError.value(item.id, 'todos', 'Duplicate todo identity');
      }
    }
    items.sort((a, b) {
      final order = b.creationOrder.compareTo(a.creationOrder);
      return order != 0 ? order : b.id.compareTo(a.id);
    });
    return List.unmodifiable(items);
  }
}
