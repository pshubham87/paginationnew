import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'Auth/auth.dart';
import 'Pagination/infiniteScroll.dart';
import 'Pagination/model/data_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(DataModelAdapter());
  await Hive.openBox<DataModel>('data');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: const AuthScreen(),
    );
  }
}
