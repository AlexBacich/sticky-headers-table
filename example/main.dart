import 'package:flutter/material.dart';
import 'package:table_sticky_headers/table_sticky_headers.dart';

void main() => runApp(TableSimple());

class TableSimple extends StatelessWidget {
  final List<String> columns = List.generate(10, (i) => '${i + 1}');
  final List<String> rows = List.generate(20, (i) => '${i + 1}');

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Sticky Headers Two-Dimension  Table'),
          backgroundColor: Colors.amber,
        ),
        body: StickyHeadersTable(
          columnsLength: columns.length,
          rowsLength: rows.length,
          columnsTitleBuilder: (i) => Text('Top ${columns[i]}'),
          rowsTitleBuilder: (i) => Text('Left ${rows[i]}'),
          contentCellBuilder: (i, j) => Text('T${columns[i]} : L${rows[j]}'),
          legendCell: Text('Sticky Legend'),
        ),
      ),
    );
  }
}

