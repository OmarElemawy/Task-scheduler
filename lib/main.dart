import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:untitled1/shared/bloc_observer.dart';
import 'layout/home.dart';


main() {
  runApp(const MyApp());
  Bloc.observer = MyBlocObserver();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}


