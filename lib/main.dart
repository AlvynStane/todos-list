import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todos_list/Provider/darktheme.dart';
import 'package:todos_list/Provider/todos_provider.dart';
import 'package:todos_list/mainpage.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => DarkThemeProvider()),
      ChangeNotifierProvider(create: (_) => TodoProvider()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<DarkThemeProvider>(context);
    return MaterialApp(
      title: 'Todos',
      theme: themeProvider.darkTheme == true
          ? themeProvider.dark
          : themeProvider.light,
      home: const MainPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
