# table_sticky_headers

This package for [Flutter](https://flutter.io) allows you to display two-dimension table with both sticky headers.

Key of this package is sticky headers. You can scroll table any direction and headers (top and left) will always stay. 
Cells themselves are fully customizable as you can fill them with Widgets. 

To work with table you need to fill it with data. It has three builders for generating title column (List<Widget>), title row (List<Widget>) and content itself (List<Widget>.

Simplest UseCase. You have two-dimensional array of Strings. Builder takes value from array and generates Text widget: 
```dart
contentCellBuilder: (i, j) => Text(data[i][j]),
```

For more advanced usage - decorate Text with other widgets like borders, cell colors, etc. Check decorated_example.dart to see it in action.
You can also wrap cell with tap listeners and add custom behavior on tap. Check tap_handler_example.dart.

You can also customize the cell dimensions using the cellDimensions property of StickyHeadersTable. Uniform or different cell widths and heights are both supported.
  
Feature requests and PRs are welcome.  

![Пример работы](https://github.com/AlexBacich/sticky-headers-table/blob/master/example/sticky_demo.gif?raw=true)


Widget usage example:
```dart
// titleColumn - List<String> (title column)
// titleColumn - List<String> (title row)
// titleColumn - List<List<String>> (data)

StickyHeadersTable(
          columnsLength: titleColumn.length,
          rowsLength: titleRow.length,
          columnsTitleBuilder: (i) => Text(titleColumn[i]),
          rowsTitleBuilder: (i) => Text(titleRow[i]),
          contentCellBuilder: (i, j) => Text(data[i][j]),
          legendCell: Text('Sticky Legend'),
        ),
```

Visit examples to see it in details

## Support

Please file [issues and feature requests](https://github.com/AlexBacich/sticky-headers-table).

## Getting Started

This project is a starting point for a Dart
[package](https://flutter.dev/developing-packages/),
a library module containing code that can be shared easily across
multiple Flutter or Dart projects.

For help getting started with Flutter, view our 
[online documentation](https://flutter.dev/docs), which offers tutorials, 
samples, guidance on mobile development, and a full API reference.
