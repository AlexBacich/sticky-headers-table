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
  TextEditingController textXController = TextEditingController(text: '0');
  TextEditingController textYController = TextEditingController(text: '0');

  int indexX = 0;
  int indexY = 0;

  @override
  void dispose() {
    textXController.dispose();
    textYController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Move to Cell Programmatically'),
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
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32),
            child: Row(
              children: [
                Text('X: '),
                const SizedBox(width: 16),
                Expanded(child: TextFormField(controller: textXController)),
                const SizedBox(width: 16),
                Text('Y: '),
                const SizedBox(width: 16),
                Expanded(child: TextFormField(controller: textYController)),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    final newIndexX = int.tryParse(textXController.text);
                    final newIndexY = int.tryParse(textYController.text);
                    if (newIndexX == null || newIndexY == null) {
                      final snackBar = SnackBar(content: Text('You should put number in input'));
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
                      indexX = newIndexX;
                      indexY = newIndexY;
                    });
                  },
                  child: Text('Move'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
