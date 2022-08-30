import 'package:flutter/material.dart';
import 'package:table_sticky_headers/table_sticky_headers.dart';

class TapHandlerPage extends StatefulWidget {
  TapHandlerPage({
    required this.data,
    required this.titleColumn,
    required this.titleRow,
  });

  final List<List<String>> data;
  final List<String> titleColumn;
  final List<String> titleRow;

  @override
  _TapHandlerPageState createState() => _TapHandlerPageState();
}

class _TapHandlerPageState extends State<TapHandlerPage> {
  int? selectedRow;
  int? selectedColumn;

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
            columnsTitleBuilder: (i) => TextButton(
              child: Text(widget.titleColumn[i]),
              onPressed: clearState,
            ),
            rowsTitleBuilder: (i) => TextButton(
              child: Text(widget.titleRow[i]),
              onPressed: clearState,
            ),
            contentCellBuilder: (i, j) => ElevatedButton(
              child: Text(
                widget.data[i][j],
                style: TextStyle(color: Colors.black),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  getContentColor(i, j),
                ),
                elevation: MaterialStateProperty.all(0),
                padding: MaterialStateProperty.all(EdgeInsets.zero),
              ),
              onPressed: () => setState(() {
                selectedColumn = j;
                selectedRow = i;
              }),
            ),
            legendCell: TextButton(
              child: Text('Sticky Legend'),
              onPressed: clearState,
            ),
            scrollOffsetIndexX: selectedRow,
            scrollOffsetIndexY: selectedColumn,
          ),
        ),
      );
}
