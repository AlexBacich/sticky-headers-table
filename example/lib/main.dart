import 'package:flutter/material.dart';
import 'simple_table_page.dart';
import 'tap_handler_page.dart';
import 'decorated_table_page.dart';

void main() {
  runApp(
    MaterialApp(
      home: LandingPage(),
    ),
  );
}

class LandingPage extends StatefulWidget {
  final columns = 10;
  final rows = 20;

  List<List<String>> makeData() {
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
  List<String> makeTitleColumn() => List.generate(columns, (i) => 'Top $i');

  /// Simple generator for row title
  List<String> makeTitleRow() => List.generate(rows, (i) => 'Left $i');

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  int _selectedIndex = 0;

  Widget _widgetOptions(int index) {
    switch (index) {
      case 0:
        return SimpleTablePage(
          titleColumn: widget.makeTitleColumn(),
          titleRow: widget.makeTitleRow(),
          data: widget.makeData(),
        );
      case 1:
        return TapHandlerPage(
          titleColumn: widget.makeTitleColumn(),
          titleRow: widget.makeTitleRow(),
          data: widget.makeData(),
        );
      case 2:
        return DecoratedTablePage(
          titleColumn: widget.makeTitleColumn(),
          titleRow: widget.makeTitleRow(),
          data: widget.makeData(),
        );
      default:
        print('$index not supported');
        return Container();
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Container(),
            label: 'Simple',
          ),
          BottomNavigationBarItem(
            icon: Container(),
            label: 'Tap Handler',
          ),
          BottomNavigationBarItem(
            icon: Container(),
            label: 'Decorated',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
