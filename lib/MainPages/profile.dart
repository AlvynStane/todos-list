import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:todos_list/Provider/darktheme.dart';
import 'package:todos_list/Provider/todos_provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  getFromGallery() async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        context.read<TodoProvider>().setPicture = MemoryImage(bytes);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final todosProvider = Provider.of<TodoProvider>(context);
    int sliderValue = todosProvider.finishedTodos.length;
    int maxSliderValue = todosProvider.originalTodos.length;
    int unfinished = todosProvider.unfinishedTodos.length;
    return Column(
      children: [
        Card(
          child: ListTile(
            leading: InkWell(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Dialog(
                          insetPadding: EdgeInsets.all(100),
                          child: Container(
                            height: 300,
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                  child: Container(
                                      width: double.infinity,
                                      child: context
                                                  .watch<TodoProvider>()
                                                  .getPicture ==
                                              null
                                          ? CircleAvatar(
                                              backgroundColor: Colors.grey,
                                              child: Icon(
                                                Icons.person,
                                                color: Colors.white,
                                                size: 200,
                                              ),
                                            )
                                          : Expanded(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                  image: context
                                                      .watch<TodoProvider>()
                                                      .getPicture!,
                                                  fit: BoxFit.cover,
                                                )),
                                              ),
                                            )),
                                ),
                                Container(
                                  color: context
                                          .watch<DarkThemeProvider>()
                                          .darkTheme
                                      ? Colors.greenAccent
                                      : Colors.green,
                                  height: 50,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      IconButton(
                                          onPressed: () {
                                            setState(() {
                                              context
                                                  .read<TodoProvider>()
                                                  .setPicture = null;
                                            });
                                          },
                                          icon: Icon(
                                            Icons.delete,
                                          )),
                                      IconButton(
                                          onPressed: () {
                                            setState(() {
                                              getFromGallery();
                                            });
                                          },
                                          icon: Icon(
                                            Icons.edit,
                                          )),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ));
                    });
              },
              child: context.watch<TodoProvider>().getPicture == null
                  ? CircleAvatar(
                      backgroundColor: Colors.grey,
                      child: Icon(
                        Icons.person,
                        color: Colors.white,
                      ),
                    )
                  : CircleAvatar(
                      backgroundImage: context.watch<TodoProvider>().getPicture,
                    ),
            ),
            title: const Text(
              "Alvyn Stane",
              style: TextStyle(fontSize: 16),
            ),
            subtitle: Text('Task finished: $sliderValue'),
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (final stuff in todosProvider.stuff)
                Card(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.316,
                    height: 130,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(stuff.label, style: const TextStyle(fontSize: 15)),
                        Text(
                          '${todosProvider.doneNumber(stuff.label)}',
                          style: TextStyle(color: stuff.color, fontSize: 40),
                        ),
                        const Text('Finished', style: TextStyle(fontSize: 15)),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Slider(
                    min: 0,
                    max: maxSliderValue.toDouble(),
                    value: sliderValue.toDouble(),
                    onChanged: null),
                SizedBox(
                  height: 12,
                ),
                Text(
                  unfinished == 0
                      ? 'All tasks done'
                      : 'You still have $unfinished task(s) to do',
                  style: TextStyle(fontSize: 15),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
