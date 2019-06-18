import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_app_test/listcomponent/list_component_bloc.dart';
import 'package:flutter_app_test/listcomponent/list_component_state.dart';
import 'package:flutter_app_test/listcomponent/list_component_item_widget.dart';

class ListComponent extends StatefulWidget {
  final String _title;
  final double _height;
  final String _subTitle;

  ListComponent({
    @required String title,
    @required double height,
    String subTitle,
  })  : this._title = title,
        this._height = height,
        this._subTitle = subTitle;

  @override
  State<StatefulWidget> createState() => _ListComponentState();
}

class _ListComponentState extends State<ListComponent> {
  final ListComponentBloc _bloc = ListComponentBloc(httpClient: http.Client());

  @override
  void initState() {
    _bloc.mapEventToState(_bloc.initialState);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                widget._title,
                style: Theme.of(context).textTheme.title,
              ),
            ),
            Text(
              "View more",
              style: Theme.of(context).textTheme.button,
            ),
            Icon(Icons.keyboard_arrow_right),
          ],
        ),
        widget._subTitle != null ? Text(widget._subTitle) : Container(),
        Container(
          height: widget._height,
          child: StreamBuilder<ListComponentState>(
            stream: _bloc.stream,
            builder: (context, snapshot) {
              final state = snapshot.data;
              if (state is ListComponentUninitialized) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (state is ListComponent) {
                return Center(
                  child: Text('failed to fetch items'),
                );
              }
              if (state is ListComponentLoaded) {
                if (state.items.isEmpty) {
                  return Center(
                    child: Text('no items'),
                  );
                }
                return ListView.builder(
                  itemCount: state.items.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    final margin = getMargin(index, state.items.length);
                    return ListComponentItemWidget(state.items[index], margin);
                  },
                );
              }
              return Container();
            },
          ),
        ),
      ],
    );
  }

  EdgeInsets getMargin(int index, int max) {
    double left, right = 0;
    if (index == 0) {
      left = 8;
      right = 4;
    } else if (index == max - 1) {
      left = 4;
      right = 8;
    } else {
      left = 4;
      right = 4;
    }

    return EdgeInsets.fromLTRB(left, 8, right, 8);
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }
}
