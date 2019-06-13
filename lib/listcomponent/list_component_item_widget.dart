import 'package:flutter/material.dart';
import 'package:flutter_app_test/listcomponent/list_component_item.dart';

class ListComponentItemWidget extends StatelessWidget {

  final ListComponentItem item;

  ListComponentItemWidget({this.item});

  @override
  Widget build(BuildContext context) {
    return Container (
      margin: EdgeInsets.all(8),
      color: Colors.grey,
      child: Image.network(item.url),
    );
  }
}
