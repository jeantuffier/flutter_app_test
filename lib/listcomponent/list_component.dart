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
    return StreamBuilder<ListComponentState>(
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
            itemBuilder: (BuildContext context, int index) {
              return ListComponentItemWidget(item: state.items[index]);
            },
            itemCount: state.items.length,
          );
        }
        return Container();
      },
    );
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  /*StreamBuilder _buildFromStream() {
    return StreamBuilder<List<T>>(
      stream: widget._streamController.stream,
      initialData: [],
      builder: (context, snapshot) {
        return Column(
          children: <Widget>[
            ListHeaderWidget<T>(
              widget._title,
              widget._subTitle,
            ),
            Container(
              margin: EdgeInsets.only(bottom: 16),
              height: 200,
              child: _getContent(snapshot.data),
            ),
          ],
        );
      },
    );
  }

  Widget _getContent(List<T> items) {
    return items.isEmpty ? _getProgressView() : _getListView(items);
  }

  ListView _getListView(List<T> items) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemBuilder: (BuildContext context, int index) {
        return widget._widgetBuilder.buildSimpleWidget(items[index]);
      },
      itemCount: items.length > 20 ? 20 : items.length,
    );
  }

  Container _getProgressView() {
    return Container(
      alignment: Alignment.center,
      child: Center(
        child: SizedBox(
          width: 33,
          height: 33,
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    widget._dispose();
    super.dispose();
  }*/
}
