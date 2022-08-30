import 'package:flutter/material.dart';
import 'package:table_sticky_headers/table_sticky_headers.dart';

class OffsetToCellPage extends StatefulWidget {
  OffsetToCellPage(
      {required this.data, required this.titleColumn, required this.titleRow});

  final List<List<String>> data;
  final List<String> titleColumn;
  final List<String> titleRow;

  @override
  State<OffsetToCellPage> createState() => _OffsetToCellPageState();
}

class _OffsetToCellPageState extends State<OffsetToCellPage> {
  TextEditingController textXcontroller = TextEditingController(text: '0');
  TextEditingController textYcontroller = TextEditingController(text: '0');

  @override
  void dispose() {
    textXcontroller.dispose();
    textYcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Move to cell'),
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
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32),
            child: Row(
              children: [
                Text('X ='),
                const SizedBox(width: 16),
                Expanded(child: TextFormField(controller: textXcontroller)),
                const SizedBox(width: 16),
                Text('Y ='),
                const SizedBox(width: 16),
                Expanded(child: TextFormField(controller: textYcontroller)),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    print(
                        'Searching cell: X = ${textXcontroller.text}, Y = ${textYcontroller.text}');
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
