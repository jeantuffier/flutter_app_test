import 'package:flutter/material.dart';
import 'package:flutter_app_test/infiniteloadinglist/inifinite_loading_list.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Infinite Scroll',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Posts'),
        ),
        body: InfiniteLoadingList(),
      ),
    );
  }
}
