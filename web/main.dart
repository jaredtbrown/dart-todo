import 'dart:html';
import 'dart:convert';

// model
class Todo {
  String description;

  Todo(this.description);

  Todo.fromJson(Map<String, dynamic> json)
      : description = json['description'];

  Map<String, dynamic> toJson() =>
    {
      'description': description,
    };
}

// ui
class TodoList {
  final _output = querySelector('#todos');

  void render(List<Todo> todos) {
    _output.children.clear();
    for (var todo in todos) {
      _output.children.add(_createListItem(todo.description));
    }
  }

  LIElement _createListItem(String itemText) => LIElement()..text = itemText;
}

class CreateTodoButton {
  final _output = querySelector('#add');

  void render(Function event) {
    _output.onClick.listen(event);
  }
}

class CreateTodoInput {
  final _output = querySelector('#input') as InputElement;
  String value;

  CreateTodoInput() {
    value = _output.value;
  }
}

// app
void main() {
  var todos = getTodos();
  TodoList().render(todos);

  CreateTodoButton().render(addTodo);

  CreateTodoInput();
}

void addTodo(Event event) {
  var todos = getTodos();
  var newTodo = Todo(CreateTodoInput().value);
  todos.add(newTodo);
  TodoList().render(todos);

  var storedTodos = <Map<String, dynamic>>[];
  for (var todo in todos) {
    storedTodos.add(todo.toJson());
  }
  window.localStorage['todos'] = json.encode(storedTodos);
}

List<Todo> getTodos() {
  var todosInStorage = window.localStorage.containsKey('todos') ? json.decode(window.localStorage['todos']) : [];
  
  var todos = <Todo>[];
  for (var todo in todosInStorage) {
    todos.add(Todo.fromJson(todo));
  }

  return todos;
}
