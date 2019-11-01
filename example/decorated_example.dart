import 'package:flutter/material.dart';
import 'package:table_sticky_headers/table_sticky_headers.dart';

void main() => runApp(MyApp());

/// This example shows how to use decoration for table. It also includes example on how to set click listeners on table cells. Once you tap on cell - entire row and column gets highlighted. Tap on sticky row or column to deselect.
class MyApp extends StatefulWidget {
  final List<String> columns = List.generate(10, (i) => '${i + 1}');
  final List<String> rows = List.generate(20, (i) => '${i + 1}');

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int selectedRow;
  int selectedColumn;

  Color getContentColor(int i, int j) {
    if (i == selectedRow && j == selectedColumn) {
      return Colors.amber;
    } else if (i == selectedRow || j == selectedColumn) {
      return Colors.amberAccent;
    } else {
      return Colors.white;
    }
  }

  void clearState() => setState(() {
        selectedRow = null;
        selectedColumn = null;
      });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return MaterialApp(
      title: 'Flutter Demo',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Sticky Headers Two-Dimension  Table'),
          backgroundColor: Colors.amber,
        ),
        body: StickyHeadersTable(
          columnsLength: widget.columns.length,
          rowsLength: widget.rows.length,
          columnsTitleBuilder: (i) => TableCell.stickyRow(
            'Top ${widget.columns[i]}',
            textStyle: textTheme.button.copyWith(fontSize: 15.0),
            onTap: clearState,
          ),
          rowsTitleBuilder: (i) => TableCell.stickyColumn(
            'Left ${widget.rows[i]}',
            textStyle: textTheme.button.copyWith(fontSize: 15.0),
            onTap: clearState,
          ),
          contentCellBuilder: (i, j) => TableCell.content(
            'T${widget.columns[i]} : L${widget.rows[j]}',
            textStyle: textTheme.body2.copyWith(fontSize: 12.0),
            colorBg: getContentColor(i, j),
            onTap: () => setState(() {
              selectedColumn = j;
              selectedRow = i;
            }),
          ),
          legendCell: TableCell.legend(
            'Sticky Legend',
            textStyle: textTheme.button.copyWith(fontSize: 16.5),
            onTap: clearState,
          ),
        ),
      ),
    );
  }
}

class TableCell extends StatelessWidget {
  TableCell.content(
    this.text, {
    this.textStyle,
    this.cellDimensions = CellDimensions.base,
    this.colorBg = Colors.white,
    this.onTap,
  })  : cellWidth = cellDimensions.contentCellWidth,
        cellHeight = cellDimensions.contentCellHeight,
        _colorHorizontalBorder = Colors.amber,
        _colorVerticalBorder = Colors.black38,
        _textAlign = TextAlign.center,
        _padding = EdgeInsets.zero;

  TableCell.legend(
    this.text, {
    this.textStyle,
    this.cellDimensions = CellDimensions.base,
    this.colorBg = Colors.amber,
    this.onTap,
  })  : cellWidth = cellDimensions.stickyLegendWidth,
        cellHeight = cellDimensions.stickyLegendHeight,
        _colorHorizontalBorder = Colors.white,
        _colorVerticalBorder = Colors.amber,
        _textAlign = TextAlign.start,
        _padding = EdgeInsets.only(left: 24.0);

  TableCell.stickyRow(
    this.text, {
    this.textStyle,
    this.cellDimensions = CellDimensions.base,
    this.colorBg = Colors.amber,
    this.onTap,
  })  : cellWidth = cellDimensions.contentCellWidth,
        cellHeight = cellDimensions.stickyLegendHeight,
        _colorHorizontalBorder = Colors.white,
        _colorVerticalBorder = Colors.amber,
        _textAlign = TextAlign.center,
        _padding = EdgeInsets.zero;

  TableCell.stickyColumn(
    this.text, {
    this.textStyle,
    this.cellDimensions = CellDimensions.base,
    this.colorBg = Colors.white,
    this.onTap,
  })  : cellWidth = cellDimensions.stickyLegendWidth,
        cellHeight = cellDimensions.contentCellHeight,
        _colorHorizontalBorder = Colors.amber,
        _colorVerticalBorder = Colors.black38,
        _textAlign = TextAlign.start,
        _padding = EdgeInsets.only(left: 24.0);

  final CellDimensions cellDimensions;

  final String text;
  final Function onTap;

  final double cellWidth;
  final double cellHeight;

  final Color colorBg;
  final Color _colorHorizontalBorder;
  final Color _colorVerticalBorder;

  final TextAlign _textAlign;
  final EdgeInsets _padding;

  final TextStyle textStyle;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: cellWidth,
        height: cellHeight,
        padding: _padding,
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: 2.0),
                child: Text(
                  text,
                  style: textStyle,
                  maxLines: 2,
                  textAlign: _textAlign,
                ),
              ),
            ),
            Container(
              width: double.infinity,
              height: 1.1,
              color: _colorVerticalBorder,
            ),
          ],
        ),
        decoration: BoxDecoration(
            border: Border(
              left: BorderSide(color: _colorHorizontalBorder),
              right: BorderSide(color: _colorHorizontalBorder),
            ),
            color: colorBg),
      ),
    );
  }
}
