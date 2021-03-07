import 'package:flutter/material.dart';
import 'package:table_sticky_headers/table_sticky_headers.dart';

class SimpleTablePage extends StatelessWidget {
  SimpleTablePage(
      {required this.data, required this.titleColumn, required this.titleRow});

  final List<List<String>> data;
  final List<String> titleColumn;
  final List<String> titleRow;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    );
  }
}
