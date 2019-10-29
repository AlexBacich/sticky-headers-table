import 'package:flutter/material.dart';
import 'package:table_sticky_headers/table_sticky_headers.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<String> tops = List.generate(20, (i) => '${i + 1}');
    List<String> lefts = List.generate(20, (i) => '${i + 1}');

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Sticky Headers Two-Dimension  Table'),
          backgroundColor: Colors.amber,
        ),
        body: StickyHeadersTable(
          columnsLength: tops.length,
          rowsLength: lefts.length,
          columnsTitleBuilder: (i) => 'Top ${tops[i]}',
          rowsTitleBuilder: (i) => 'Left ${lefts[i]}',
          contentCellBuilder: (i, j) => 'T${tops[i]} : L${lefts[j]}',
          legendCell: 'Permanently Sticky',
        ),
      ),
    );
  }
}