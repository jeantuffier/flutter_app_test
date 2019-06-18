import 'package:flutter/material.dart';
import 'package:flutter_app_test/listcomponent/list_component_item.dart';

class ListComponentItemWidget extends StatelessWidget {

  final ListComponentItem _item;
  final EdgeInsets _margin;

  ListComponentItemWidget(this._item, this._margin);

  @override
  Widget build(BuildContext context) {
    return Container (
      margin: _margin,
      color: Colors.grey,
      child: Image.network(_item.url),
    );
  }
}
