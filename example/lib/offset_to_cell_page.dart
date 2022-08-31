import 'package:flutter/material.dart';
import 'package:table_sticky_headers/table_sticky_headers.dart';

class OffsetToCellPage extends StatefulWidget {
  OffsetToCellPage({
    required this.data,
    required this.titleColumn,
    required this.titleRow,
  });

  final List<List<String>> data;
  final List<String> titleColumn;
  final List<String> titleRow;

  @override
  State<OffsetToCellPage> createState() => _OffsetToCellPageState();
}

class _OffsetToCellPageState extends State<OffsetToCellPage> {
  TextEditingController textControllerLeft = TextEditingController();
  TextEditingController textControllerTop = TextEditingController();
  TextEditingController textControllerOffsetX = TextEditingController();
  TextEditingController textControllerOffsetY = TextEditingController();

  int? indexX;
  int? indexY;
  double? offsetX;
  double? offsetY;

  @override
  void dispose() {
    textControllerLeft.dispose();
    textControllerTop.dispose();
    textControllerOffsetX.dispose();
    textControllerOffsetY.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Offset Programmatically (by points or index)'),
        backgroundColor: Colors.amber,
      ),
      body: Column(
        children: [
          Expanded(
            child: StickyHeadersTable(
              columnsLength: widget.titleColumn.length,
              rowsLength: widget.titleRow.length,
              columnsTitleBuilder: (i) => Text(widget.titleColumn[i]),
              rowsTitleBuilder: (i) => Text(widget.titleRow[i]),
              contentCellBuilder: (i, j) => Text(widget.data[i][j]),
              legendCell: Text('Sticky Legend'),
              scrollOffsetIndexX: indexX,
              scrollOffsetIndexY: indexY,
              initialScrollOffsetX: offsetX,
              initialScrollOffsetY: offsetY,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
            child: Row(
              children: [
                Text('Offset X: '),
                const SizedBox(width: 8),
                Expanded(
                    child: TextFormField(controller: textControllerOffsetX)),
                const SizedBox(width: 16),
                Text('Offset Y: '),
                const SizedBox(width: 8),
                Expanded(
                    child: TextFormField(controller: textControllerOffsetY)),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: onOffset,
                  child: Text('To Pixel'),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16),
            child: Row(
              children: [
                Text('Column: '),
                const SizedBox(width: 8),
                Expanded(child: TextFormField(controller: textControllerLeft)),
                const SizedBox(width: 16),
                Text('Row: '),
                const SizedBox(width: 8),
                Expanded(child: TextFormField(controller: textControllerTop)),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: onCell,
                  child: Text('To Cell'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void onOffset() {
    final newOffsetX = double.tryParse(textControllerOffsetX.text);
    final newOffsetY = double.tryParse(textControllerOffsetY.text);
    if (newOffsetX == null || newOffsetY == null) {
      final snackBar =
          SnackBar(content: Text('You should put number in input'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    setState(() {
      offsetX = newOffsetX;
      offsetY = newOffsetY;
    });
  }

  void onCell() {
    final newIndexX = int.tryParse(textControllerLeft.text);
    final newIndexY = int.tryParse(textControllerTop.text);
    if (newIndexX == null || newIndexY == null) {
      final snackBar =
          SnackBar(content: Text('You should put number in input'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    if (newIndexX >= widget.titleColumn.length) {
      final snackBar = SnackBar(content: Text('X is too big'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    if (newIndexY >= widget.titleRow.length) {
      final snackBar = SnackBar(content: Text('Y is too big'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    setState(() {
      offsetX = null;
      offsetY = null;
      indexX = newIndexX;
      indexY = newIndexY;
    });
  }
}
