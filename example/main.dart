import 'package:flutter/material.dart';
import 'package:table_sticky_headers/table_sticky_headers.dart';

void main() {
  final columns = 10;
  final rows = 20;

  List<List<String>> _makeData() {
    final List<List<String>> output = [];
    for (int i = 0; i < columns; i++) {
      final List<String> row = [];
      for (int j = 0; j < rows; j++) {
        row.add('T$i : L$j');
      }
      output.add(row);
    }
    return output;
  }

  /// Simple generator for column title
  List<String> _makeTitleColumn() => List.generate(columns, (i) => 'Top $i');

  /// Simple generator for row title
  List<String> _makeTitleRow() => List.generate(rows, (i) => 'Left $i');

  runApp(
    TableSimple(
      titleColumn: _makeTitleColumn(),
      titleRow: _makeTitleRow(),
      data: _makeData(),
    ),
  );
}

class TableSimple extends StatelessWidget {
  TableSimple(
      {@required this.data,
        @required this.titleColumn,
        @required this.titleRow});

  final List<List<String>> data;
  final List<String> titleColumn;
  final List<String> titleRow;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Sticky Headers Two-Dimension  Table'),
          backgroundColor: Colors.amber,
        ),
        body: StickyHeadersTable(
          columnsLength: titleColumn.length,
          rowsLength: titleRow.length,
          columnsTitleBuilder: (i) => Text(titleColumn[i]),
          rowsTitleBuilder: (i) => Text(titleRow[i]),
          contentCellBuilder: (i, j) => Text(data[i][j]),
          legendCell: Text('Sticky Legend'),
        ),
      ),
    );
  }
}