library easy_listview;

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class EasyListView extends StatefulWidget {
  EasyListView({
    @required this.itemCount,
    @required this.itemBuilder,
    this.headerBuilder,
    this.footerBuilder,
    this.loadMore: false,
    this.onLoadMore,
    this.dividerSize: 0.0,
  });

  final int itemCount;
  final WidgetBuilder headerBuilder;
  final WidgetBuilder footerBuilder;
  final bool loadMore;
  final IndexedWidgetBuilder itemBuilder;
  final VoidCallback onLoadMore;
  final double dividerSize;

  @override
  State<StatefulWidget> createState() {
    return EasyListViewState();
  }
}

class EasyListViewState extends State<EasyListView> {
  @override
  Widget build(BuildContext context) {
    var itemCount = _itemCount();
    var headerCount = _headerCount();
    var footerCount = _footerCount();
    return new ListView.builder(
        itemCount: itemCount + headerCount + footerCount,
        itemBuilder: (context, index) {
          if (hasHeader() && index == 0) return widget.headerBuilder(context);
          if (widget.loadMore && index == headerCount + itemCount) {
            if (widget.onLoadMore != null) widget.onLoadMore();
            return new Center(
              child: new CircularProgressIndicator(),
            );
          }
          if (hasFooter() && index == headerCount + itemCount)
            return widget.footerBuilder(context);

          if (index.isEven)
            return new Divider(
              height: widget.dividerSize,
              color: Colors.black12,
            );

          var itemIndex = (index - headerCount) ~/ 2;
          return widget.itemBuilder(context, itemIndex);
        });
  }

  int _headerCount() {
    return hasHeader() ? 1 : 0;
  }

  int _footerCount() {
    return hasFooter() || widget.loadMore ? 1 : 0;
  }

  int _itemCount() {
    return widget.itemCount * (hasDivider() ? 2 : 1);
  }

  bool hasDivider() {
    return widget.dividerSize > 0.0 ? true : false;
  }

  bool hasHeader() {
    return widget.headerBuilder != null;
  }

  bool hasFooter() {
    return widget.footerBuilder != null;
  }
}
