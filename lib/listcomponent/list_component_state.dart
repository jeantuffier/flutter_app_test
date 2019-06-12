import 'package:flutter_app_test/listcomponent/list_component_item.dart';

abstract class ListComponentState {}

class ListComponentUninitialized extends ListComponentState {}

class ListComponentError extends ListComponentState {}

class ListComponentLoaded extends ListComponentState {
  final List<ListComponentItem> items;

  ListComponentLoaded({this.items});
}
