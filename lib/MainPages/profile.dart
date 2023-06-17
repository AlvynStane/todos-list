import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todos_list/Provider/todos_provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final todosProvider = Provider.of<TodoProvider>(context);
    return Column(
      children: [
        Card(
          child: ListTile(
            leading: const CircleAvatar(backgroundColor: Colors.black),
            title: const Text("Alvyn Stane"),
            subtitle: Text('Task finished: ${todosProvider.finishedTodos.length}'),
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              for (final stuff in todosProvider.stuff)
                Card(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.316,
                    height: 150,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(stuff.label, style: const TextStyle(fontSize: 15)),
                        Text(
                          '${todosProvider.doneNumber(stuff.label)}',
                          style: TextStyle(color: stuff.color, fontSize: 35),
                        ),
                        const Text('Finished', style: TextStyle(fontSize: 15)),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
