import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_app_test/listcomponent/list_component_state.dart';
import 'package:flutter_app_test/listcomponent/list_component_item.dart';
import 'dart:convert';
import 'dart:async';

class ListComponentBloc {
  final http.Client httpClient;

  ListComponentBloc({@required this.httpClient});

  ListComponentState get initialState => ListComponentUninitialized();

  StreamController _streamController = StreamController<ListComponentState>();

  Stream<ListComponentState> get stream => _streamController.stream;

  void mapEventToState(ListComponentState currentState) async {
    try {
      if (currentState is ListComponentUninitialized) {
        final items = await _fetchItems(0, 20);
        final state = ListComponentLoaded(items: items);
        _streamController.sink.add(state);
      }
    } catch (_) {
      _streamController.sink.add(ListComponentError());
    }
  }

  Future<List<ListComponentItem>> _fetchItems(int startIndex, int limit) async {
    final response = await httpClient.get(
        'https://jsonplaceholder.typicode.com/photos?_start=$startIndex&_limit=$limit');
    if (response.statusCode == 200) {
      final data = json.decode(response.body) as List;
      return data.map((rawPost) {
        return ListComponentItem(
          albumId: rawPost['albumId'],
          id: rawPost['id'],
          title: rawPost['title'],
          url: rawPost['url'],
          thumbnailUrl: rawPost['thumbnailUrl'],
        );
      }).toList();
    } else {
      throw Exception('error fetching items');
    }
  }

  void dispose() {
    _streamController.close();
  }
}
