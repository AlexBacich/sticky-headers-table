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
    TableTapHandlerHighlightSelectedCell(
      titleColumn: _makeTitleColumn(),
      titleRow: _makeTitleRow(),
      data: _makeData(),
    ),
  );
}

class TableTapHandlerHighlightSelectedCell extends StatefulWidget {
  TableTapHandlerHighlightSelectedCell(
      {@required this.data,
        @required this.titleColumn,
        @required this.titleRow});

  final List<List<String>> data;
  final List<String> titleColumn;
  final List<String> titleRow;

  @override
  _TableTapHandlerHighlightSelectedCellState createState() =>
      _TableTapHandlerHighlightSelectedCellState();
}

class _TableTapHandlerHighlightSelectedCellState
    extends State<TableTapHandlerHighlightSelectedCell> {
  int selectedRow;
  int selectedColumn;

  Color getContentColor(int i, int j) {
    if (i == selectedRow && j == selectedColumn) {
      return Colors.amber;
    } else if (i == selectedRow || j == selectedColumn) {
      return Colors.amberAccent;
    } else {
      return Colors.transparent;
    }
  }

  void clearState() => setState(() {
    selectedRow = null;
    selectedColumn = null;
  });

  @override
  Widget build(BuildContext context) => MaterialApp(
    home: Scaffold(
      appBar: AppBar(
        title: Text(
          'Tap handler example: highlight selected cell with row & column',
          maxLines: 2,
        ),
        backgroundColor: Colors.amber,
      ),
      body: StickyHeadersTable(
        columnsLength: widget.titleColumn.length,
        rowsLength: widget.titleRow.length,
        columnsTitleBuilder: (i) => FlatButton(
          child: Text(widget.titleColumn[i]),
          onPressed: clearState,
        ),
        rowsTitleBuilder: (i) => FlatButton(
          child: Text(widget.titleRow[i]),
          onPressed: clearState,
        ),
        contentCellBuilder: (i, j) => FlatButton(
          child: Text(widget.data[i][j]),
          color: getContentColor(i, j),
          onPressed: () => setState(() {
            selectedColumn = j;
            selectedRow = i;
          }),
        ),
        legendCell: FlatButton(
          child: Text('Sticky Legend'),
          onPressed: clearState,
        ),
      ),
    ),
  );
}

