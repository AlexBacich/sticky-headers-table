import 'package:flutter/material.dart';
import 'package:table_sticky_headers/table_sticky_headers.dart';

class ColumnWidthInPercentPage extends StatefulWidget {
  @override
  State<ColumnWidthInPercentPage> createState() =>
      _ColumnWidthInPercentPageState();
}

class _ColumnWidthInPercentPageState extends State<ColumnWidthInPercentPage> {
  final columns = 2;

  final rows = 20;

  List<List<String>> makeData() {
    final List<List<String>> output = [];
    for (int i = 0; i < columns; i++) {
      final List<String> row = [];
      for (int j = 0; j < rows; j++) {
        row.add('L$j : T$i');
      }
      output.add(row);
    }
    return output;
  }

  /// Simple generator for column title
  List<String> makeTitleColumn() => List.generate(columns, (i) => 'Top $i');

  /// Simple generator for row title
  List<String> makeTitleRow() => List.generate(rows, (i) => 'Left $i');

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final titleColumn = makeTitleColumn();
    final titleRow = makeTitleRow();
    final data = makeData();

    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('Column Width in Percent'),
        backgroundColor: Colors.amber,
      ),
      body: StickyHeadersTable(
        columnsLength: titleColumn.length,
        rowsLength: titleRow.length,
        columnsTitleBuilder: (i) => Text(titleColumn[i]),
        rowsTitleBuilder: (i) => Text(titleRow[i]),
        contentCellBuilder: (i, j) => Text(data[i][j]),
        legendCell: Text('Sticky Legend'),
        cellDimensions: CellDimensions.uniform(
            width: (screenWidth / (titleColumn.length + 1)), height: 50),
      ),
    );
  }
}
