import 'package:todos_list/Second/todospage.dart';
import 'package:flutter/material.dart';

void onSaveTodo(String title, String description, String startDate,
    String endDate, String category, BuildContext context) {
  final homePageState = context.findAncestorStateOfType<_HomePagesState>();
  homePageState?.addTodo(title, description, startDate, endDate, category);
  Navigator.pop(context);
}

class HomePages extends StatefulWidget {
  const HomePages({super.key});

  @override
  State<HomePages> createState() => _HomePagesState();
}

class _HomePagesState extends State<HomePages> {
  String? _value;
  final List<Todo> _originalTodos = [];
  List<Todo> _filteredTodos = [];

  final List<Stuff> _stuff = [
    Stuff('Work', Colors.red),
    Stuff('Routine', Colors.amber),
    Stuff('Others', Colors.blue)
  ];

  void addTodo(String title, String description, String startDate,
      String endDate, String category) {
    setState(() {
      _originalTodos.add(Todo(
        title: title,
        description: description,
        startDate: startDate,
        endDate: endDate,
        category: category,
        isChecked: false,
      ));
      _filteredTodos = _originalTodos;
    });
  }

  void _selectedChip(String? value) {
    List<Todo> filter;
    if (value != null) {
      filter = _originalTodos
          .where((tile) => tile.category.contains(value))
          .toList();
    } else {
      filter = _originalTodos;
    }
    setState(() {
      _filteredTodos = filter;
      _value = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Todo> finishedTodos =
        _filteredTodos.where((check) => check.isChecked).toList();
    List<Todo> unfinishedTodos =
        _filteredTodos.where((check) => !check.isChecked).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Wrap(
            spacing: 5.0,
            children: List<Widget>.generate(
              _stuff.length,
              (int index) {
                return ChoiceChip(
                  label: Text(_stuff[index].label),
                  selectedColor: _stuff[index].color,
                  backgroundColor: Colors.white70,
                  side: BorderSide(color: _stuff[index].color, width: 2),
                  selected: _value == _stuff[index].label,
                  onSelected: (bool value) {
                    setState(() {
                      _value = value ? _stuff[index].label : null;
                    });

                    if (value) {
                      _selectedChip(_stuff[index].label);
                    } else {
                      _selectedChip(null);
                    }
                  },
                );
              },
            ),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 5, 8, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Unfinished',
                        style: TextStyle(color: Colors.black),
                      ),
                      Divider(
                        color: Colors.black87,
                      ),
                    ],
                  ),
                ),
                if (unfinishedTodos.isNotEmpty)
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: unfinishedTodos.length,
                    itemBuilder: (context, index) {
                      final todo = unfinishedTodos[index];
                      return Card(
                        color: Colors.white70,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: ExpansionTile(
                          leading: Checkbox(
                            value: todo.isChecked,
                            activeColor: _stuff
                                .firstWhere(
                                    (element) => element.label == todo.category)
                                .color,
                            side: BorderSide(
                                color: _stuff
                                    .firstWhere((element) =>
                                        element.label == todo.category)
                                    .color,
                                width: 2),
                            onChanged: (bool? value) {
                              setState(() {
                                todo.isChecked = value ?? false;
                              });
                            },
                          ),
                          title: Text(
                            todo.title,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          subtitle: Text(
                            '${todo.startDate} s/d ${todo.endDate}',
                          ),
                          trailing: const Icon(Icons.arrow_drop_down),
                          children: <Widget>[
                            ListTile(
                                title: Text(
                              todo.description,
                            )),
                          ],
                        ),
                      );
                    },
                  ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 5, 8, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Finished',
                        style: TextStyle(color: Colors.black),
                      ),
                      Divider(
                        color: Colors.black87,
                      ),
                    ],
                  ),
                ),
                if (finishedTodos.isNotEmpty)
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: finishedTodos.length,
                    itemBuilder: (context, index) {
                      final todo = finishedTodos[index];
                      return Card(
                        color: Colors.white70,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: ExpansionTile(
                          leading: Checkbox(
                            value: todo.isChecked,
                            activeColor: _stuff
                                .firstWhere(
                                    (element) => element.label == todo.category)
                                .color,
                            side: BorderSide(
                                color: _stuff
                                    .firstWhere((element) =>
                                        element.label == todo.category)
                                    .color,
                                width: 2),
                            onChanged: (bool? value) {
                              setState(() {
                                todo.isChecked = value ?? false;
                              });
                            },
                          ),
                          title: Text(
                            todo.title,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          subtitle: Text(
                            '${todo.startDate} s/d ${todo.endDate}',
                          ),
                          trailing: const Icon(Icons.arrow_drop_down),
                          children: <Widget>[
                            ListTile(
                                title: Text(
                              todo.description,
                            )),
                          ],
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class Stuff {
  String label;
  Color color;

  Stuff(this.label, this.color);
}

class Todo {
  final String title;
  final String description;
  final String startDate;
  final String endDate;
  final String category;
  bool isChecked;

  Todo({
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.category,
    this.isChecked = false,
  });
}
