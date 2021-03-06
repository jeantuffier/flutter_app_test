import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_app_test/infiniteloadinglist/post_bloc.dart';
import 'package:flutter_app_test/infiniteloadinglist/post_state.dart';
import 'package:flutter_app_test/infiniteloadinglist/post_event.dart';
import 'package:flutter_app_test/infiniteloadinglist/post.dart';

class InfiniteLoadingList extends StatefulWidget {
  @override
  _InfiniteLoadingListState createState() => _InfiniteLoadingListState();
}

class _InfiniteLoadingListState extends State<InfiniteLoadingList> {
  final _scrollController = ScrollController();
  final PostBloc _postBloc = PostBloc(httpClient: http.Client());
  final _scrollThreshold = 200.0;
  PostState currentState = PostUninitialized();

  _InfiniteLoadingListState() {
    _scrollController.addListener(_onScroll);
    _postBloc.mapEventToState(currentState, Fetch());
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PostState>(
      stream: _postBloc.stream,
      builder: (context, snapshot) {
        final state = snapshot.data;
        currentState = state;
        if (state is PostUninitialized) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is PostError) {
          return Center(
            child: Text('failed to fetch posts'),
          );
        }
        if (state is PostLoaded) {
          if (state.posts.isEmpty) {
            return Center(
              child: Text('no posts'),
            );
          }
          return ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return index >= state.posts.length
                  ? BottomLoader()
                  : PostWidget(post: state.posts[index]);
            },
            itemCount: state.hasReachedMax
                ? state.posts.length
                : state.posts.length + 1,
            controller: _scrollController,
          );
        }
        return Container();
      },
    );
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll == currentScroll) {
      _postBloc.mapEventToState(currentState, Fetch());
    }
  }
}

class BottomLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Center(
        child: SizedBox(
          width: 33,
          height: 33,
          child: CircularProgressIndicator(
            strokeWidth: 1.5,
          ),
        ),
      ),
    );
  }
}

class PostWidget extends StatelessWidget {
  final Post post;

  const PostWidget({Key key, @required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text(
        post.id.toString(),
        style: TextStyle(fontSize: 10.0),
      ),
      title: Text('${post.title}'),
      isThreeLine: true,
      subtitle: Text(post.body),
      dense: true,
    );
  }
}
