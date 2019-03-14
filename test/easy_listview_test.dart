import 'package:flutter/widgets.dart';
import 'package:easy_listview/easy_listview.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test("test widget", () {
    var easyListView = EasyListView(
      itemCount: 10,
      itemBuilder: (context, index) {
        return new Text("Item $index");
      },
      headerBuilder: (context) {
        return new Text("Header widget");
      },
      footerBuilder: (context) {
        return new Text("Footer widget");
      },
      loadMore: true,
      onLoadMore: () {
        print("load more request.");
      },
    );
    easyListView.createState();
  });
}
