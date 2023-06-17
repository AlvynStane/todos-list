import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todos_list/Provider/darktheme.dart';
import 'package:todos_list/Provider/todos_provider.dart';
import 'package:todos_list/Second/todospage.dart';
import 'package:todos_list/MainPages/calendar.dart';
import 'package:todos_list/MainPages/profile.dart';
import 'package:todos_list/MainPages/home.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedBottomIndex = 0;
  final title = ["Todos", "Calendar", "Profile"];
  final PageController _pageController = PageController(initialPage: 0);

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<DarkThemeProvider>(context);
    final todosProvider = Provider.of<TodoProvider>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text(title[_selectedBottomIndex]),
          centerTitle: true,
          actions: <Widget>[
            Icon(themeProvider.darkTheme == false
                ? Icons.wb_sunny
                : Icons.nightlight_round),
            Switch(
                value: themeProvider.darkTheme,
                onChanged: (value) {
                  setState(() {
                    themeProvider.darkMode = value;
                  });
                })
          ],
        ),
        body: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _selectedBottomIndex = index;
            });
          },
          children: [
            HomePages(),
            CalendarPage(),
            ProfilePage(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: ((context) =>
                        Todos(onSaveTodo: todosProvider.addTodo))));
          },
          child: const Icon(Icons.add),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: 'Todos'),
            BottomNavigationBarItem(
                icon: Icon(Icons.calendar_month_outlined), label: 'Calender'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
          currentIndex: _selectedBottomIndex,
          selectedItemColor: Colors.green,
          onTap: (int index) {
            setState(() {
              _selectedBottomIndex = index;
              _pageController.animateToPage(
                index,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            });
          },
        ),
        drawer: Consumer<TodoProvider>(
          builder: (context, todosProvider, _) {
            List<Widget> drawerListTiles = todosProvider.stuff.map((stuff) {
              String category = stuff.label;
              int undoneNumber = todosProvider.undoneNumber(category);
              return ListTile(
                title: Text(category),
                trailing: Visibility(
                  visible: undoneNumber != 0,
                  child: todosProvider.counter(undoneNumber),
                ),
              );
            }).toList();

            return Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  DrawerHeader(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: themeProvider.darkTheme == false
                          ? Colors.green
                          : Colors.grey,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        Text(
                          'TODOS APP',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text('By: Alvyn Stane'),
                      ],
                    ),
                  ),
                  ...drawerListTiles,
                  const Divider(),
                  ListTile(
                    title: const Text('Dark Mode'),
                    trailing: Switch(
                      value: themeProvider.darkTheme,
                      onChanged: (value) {
                        setState(() {
                          themeProvider.darkMode = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ));
  }
}
