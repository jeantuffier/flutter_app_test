import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_app_test/infiniteloadinglist/post_state.dart';
import 'package:flutter_app_test/infiniteloadinglist/post_event.dart';
import 'package:flutter_app_test/infiniteloadinglist/post.dart';
import 'dart:convert';
import 'dart:async';

class PostBloc {
  final http.Client httpClient;

  PostBloc({@required this.httpClient});

  PostState get initialState => PostUninitialized();

  StreamController _streamController = StreamController<PostState>();

  Stream<PostState> get stream => _streamController.stream;

  void mapEventToState(
    PostState currentState,
    PostEvent event,
  ) async {
    if (event is Fetch && !_hasReachedMax(currentState)) {
      try {
        if (currentState is PostUninitialized) {
          final posts = await _fetchPosts(0, 20);
          final state = PostLoaded(posts: posts, hasReachedMax: false);
          _streamController.sink.add(state);
        }
        if (currentState is PostLoaded) {
          final posts = await _fetchPosts(currentState.posts.length, 20);
          final state = posts.isEmpty
              ? currentState.copyWith(hasReachedMax: true)
              : PostLoaded(
                  posts: currentState.posts + posts, hasReachedMax: false);
          _streamController.sink.add(state);
        }
      } catch (_) {
        _streamController.sink.add(PostError());
      }
    }
  }

  bool _hasReachedMax(PostState state) =>
      state is PostLoaded && state.hasReachedMax;

  Future<List<Post>> _fetchPosts(int startIndex, int limit) async {
    final response = await httpClient.get(
        'https://jsonplaceholder.typicode.com/posts?_start=$startIndex&_limit=$limit');
    if (response.statusCode == 200) {
      final data = json.decode(response.body) as List;
      return data.map((rawPost) {
        return Post(
          id: rawPost['id'],
          title: rawPost['title'],
          body: rawPost['body'],
        );
      }).toList();
    } else {
      throw Exception('error fetching posts');
    }
  }
}
