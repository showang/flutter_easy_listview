library easy_listview;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class EasyListView extends StatefulWidget {
  EasyListView(
      {@required this.itemCount,
      @required this.itemBuilder,
      this.headerBuilder,
      this.footerBuilder,
      this.loadMore = false,
      this.onLoadMore,
      this.loadMoreWhenNoData = false,
      this.loadMoreItemBuilder,
      this.dividerSize = 0.0,
      this.dividerColor = Colors.black12,
      this.physics,
      this.headerSliverBuilder})
      : assert(itemBuilder != null);

  final int itemCount;
  final WidgetBuilder headerBuilder;
  final WidgetBuilder footerBuilder;
  final WidgetBuilder loadMoreItemBuilder;
  final bool loadMore;
  final IndexedWidgetBuilder itemBuilder;
  final VoidCallback onLoadMore;
  final bool loadMoreWhenNoData;

  final double dividerSize;
  final Color dividerColor;
  final ScrollPhysics physics;
  final NestedScrollViewHeaderSliversBuilder headerSliverBuilder;

  @override
  State<StatefulWidget> createState() {
    return EasyListViewState();
  }
}

class EasyListViewState extends State<EasyListView> {
  @override
  Widget build(BuildContext context) {
    return widget.headerSliverBuilder != null
        ? NestedScrollView(
            headerSliverBuilder: widget.headerSliverBuilder,
            body: MediaQuery.removePadding(
                context: context, removeTop: true, child: _buildList()),
          )
        : _buildList();
  }

  _buildList() {
    var itemCount = _itemCount();
    var headerCount = _headerCount();
    var footerCount = _footerCount();
    var hasDivider = _hasDivider();
    return ListView.builder(
        physics: widget.physics,
        itemCount: itemCount + headerCount + footerCount,
        itemBuilder: (context, index) {
          if (hasHeader() && index == 0) return widget.headerBuilder(context);
          if (widget.loadMore && index == headerCount + itemCount) {
            if ((widget.loadMoreWhenNoData ||
                    (!widget.loadMoreWhenNoData && widget.itemCount > 0)) &&
                widget.onLoadMore != null) {
              Timer(Duration(milliseconds: 100), widget.onLoadMore);
            }
            return widget.loadMoreItemBuilder != null
                ? widget.loadMoreItemBuilder(context)
                : Container(
                    padding: EdgeInsets.all(8.0),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
          }
          if (hasFooter() && index == headerCount + itemCount) {
            return widget.footerBuilder(context);
          }

          var dataIndex = index - headerCount;
          if (hasDivider) {
            return index.isEven
                ? Divider(
                    height: widget.dividerSize,
                    color: widget.dividerColor,
                  )
                : widget.itemBuilder(context, dataIndex ~/ 2);
          }
          return widget.itemBuilder(context, dataIndex);
        });
  }

  int _headerCount() => hasHeader() ? 1 : 0;

  int _footerCount() => (hasFooter() || widget.loadMore) ? 1 : 0;

  int _itemCount() => widget.itemCount * (_hasDivider() ? 2 : 1);

  bool _hasDivider() => widget.dividerSize > 0.0 ? true : false;

  bool hasHeader() => widget.headerBuilder != null;

  bool hasFooter() => widget.footerBuilder != null;
}
