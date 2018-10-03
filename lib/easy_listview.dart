library easy_listview;

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class EasyListView extends StatefulWidget {
  EasyListView({
    @required this.itemCount,
    @required this.itemBuilder,
    this.headerBuilder,
    this.footerBuilder,
    this.loadMore = false,
    this.onLoadMore,
    this.loadMoreWhenNoData = false,
    this.dividerSize = 0.0,
    this.dividerColor = Colors.black12,
  }) : assert(itemBuilder != null);

  final int itemCount;
  final WidgetBuilder headerBuilder;
  final WidgetBuilder footerBuilder;
  final bool loadMore;
  final IndexedWidgetBuilder itemBuilder;
  final VoidCallback onLoadMore;
  final bool loadMoreWhenNoData;

  final double dividerSize;
  final Color dividerColor;

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
            if ((widget.loadMoreWhenNoData ||
                    (!widget.loadMoreWhenNoData && widget.itemCount > 0)) &&
                widget.onLoadMore != null) widget.onLoadMore();
            return new Center(
              child: CircularProgressIndicator(),
            );
          }
          if (hasFooter() && index == headerCount + itemCount) {
            return widget.footerBuilder(context);
          }

          if (index.isOdd) {
            return Divider(
              height: widget.dividerSize,
              color: widget.dividerColor,
            );
          }

          var dataIndex = (index - headerCount) ~/ 2;
          return widget.itemBuilder(context, dataIndex);
        });
  }

  int _headerCount() => hasHeader() ? 1 : 0;

  int _footerCount() => (hasFooter() || widget.loadMore) ? 1 : 0;

  int _itemCount() => widget.itemCount * (hasDivider() ? 2 : 1);

  bool hasDivider() => widget.dividerSize > 0.0 ? true : false;

  bool hasHeader() => widget.headerBuilder != null;

  bool hasFooter() => widget.footerBuilder != null;
}
