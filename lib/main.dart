import 'package:flutter/material.dart';
import 'package:flutter_app_test/infiniteloadinglist/inifinite_loading_list.dart';
import 'package:flutter_app_test/listcomponent/list_component.dart';
import 'package:flutter/rendering.dart';

void main() {
  debugPaintSizeEnabled=false;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Infinite Scroll',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Flutter app test'),
        ),
        //body: InfiniteLoadingList(),
        body: Column(
          children: [
            ListComponent(
              title: "List Component Title",
              height: 255,
            ),
            ListComponent(
              title: "List Component Title",
              subTitle: "Subtitle",
              height: 255,
            ),
          ],
        ),
      ),
    );
  }
}
