import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:easy_listview/easy_listview.dart';

void main() => runApp(ExampleApp());

class ExampleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'EasyListView Demo',
        theme: ThemeData(accentColor: Colors.pinkAccent),
        home: MyHomePage(),
      );
}

class MyHomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  var itemCount = 20;
  var hasNextPage = true;
  var foregroundWidget = Container(
      alignment: AlignmentDirectional.center,
      child: CircularProgressIndicator());

  @override
  void initState() {
    super.initState();
    Timer(Duration(milliseconds: 3000),
        () => setState(() => foregroundWidget = null));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: EasyListView(
          headerSliverBuilder: headerSliverBuilder,
          headerBuilder: headerBuilder,
          footerBuilder: footerBuilder,
          itemCount: itemCount + 1,
          // 1 for custom scroll view example.
          itemBuilder: itemBuilder,
          dividerBuilder: dividerBuilder,
          loadMore: hasNextPage,
          onLoadMore: onLoadMoreEvent,
          foregroundWidget: foregroundWidget,
        ),
      );

  onLoadMoreEvent() {
    Timer(
      Duration(milliseconds: 2000),
      () => setState(() {
            itemCount += 10;
            hasNextPage = itemCount <= 30;
          }),
    );
  }

  Widget dividerBuilder(context, index) => Divider(
        color: Colors.grey,
        height: 1.0,
      );

  var headerBuilder = (context) => Container(
        color: Colors.blue,
        height: 100.0,
        alignment: AlignmentDirectional.center,
        child: Text(
          "This is header",
          style: TextStyle(
            fontSize: 24.0,
            color: Colors.white,
          ),
        ),
      );

  var footerBuilder = (context) => Container(
        color: Colors.green,
        height: 100.0,
        alignment: AlignmentDirectional.center,
        child: Text(
          "This is footer",
          style: TextStyle(
            fontSize: 24.0,
            color: Colors.white,
          ),
        ),
      );

  static List<Widget> sliverItems = List.generate(
    10,
    (index) => Container(
          color: Color((Random().nextDouble() * 0xFFFFFF).toInt() << 0)
              .withOpacity(1.0),
          padding: EdgeInsets.all(8.0),
          height: 60.0,
          alignment: AlignmentDirectional.center,
          child: Text(
            "This is sliver item \nin CustomScrollView",
            style: TextStyle(color: Colors.white),
          ),
        ),
  );

  var itemBuilder = (context, index) => index == 0
      ? Container(
          height: 60.0,
          child: CustomScrollView(
            slivers: <Widget>[
              SliverList(delegate: SliverChildListDelegate(sliverItems)),
            ],
            scrollDirection: Axis.horizontal,
          ),
        )
      : Container(
          height: 60.0,
          alignment: AlignmentDirectional.center,
          child: Text(
            "Item with data index: $index",
            style: TextStyle(color: Colors.black87),
          ),
        );

  var headerSliverBuilder = (context, _) => [
        SliverAppBar(
          expandedHeight: 120.0,
          pinned: true,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          flexibleSpace: FlexibleSpaceBar(
            centerTitle: true,
            title: Container(
              child: Text(
                "Sliver App Bar",
                style: TextStyle(color: Colors.black),
              ),
            ),
          ),
        ),
      ];
}
