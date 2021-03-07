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

The cell dimensions can be customized using the cellDimensions property of StickyHeadersTable. Use:
- CellDimensions.base: Default fixed values.
- CellDimensions.uniform: Same dimensions for each cell.
- CellDimensions.fixed: Custom fixed width and height for each content cell.
- CellDimensions.variableColumnWidth: Different width for each column.
- CellDimensions.variableRowHeight: Different height for each row.
- CellDimensions.variableColumnWidthAndRowHeight: Different width for each column and different height for each row.

The alignment of the cell contents can be customized using the cellAlignments property of StickyHeadersTable. Use:
- CellAlignments.base: Default alignment value (Alignment.center).
- CellAlignments.uniform: Same alignment for each cell.
- CellAlignments.fixed: Same alignment for each content cell, but different alignment for the sticky column, row and legend.
- CellAlignments.variableColumnAlignment: Different alignment for each column.
- CellAlignments.variableRowAlignment: Different alignment for each row.
- CellAlignments.variable: Different alignment for every cell.

You can provide functions that execute when tapping a cell by setting the properties:
- onStickyLegendPressed: () => print('Sticky legend pressed.'),
- onColumnTitlePressed: (i) => print('Column $i title pressed.'),
- onRowTitlePressed: (j) => print('Row $j title pressed.'),
- onContentCellPressed: (i, j) => print('Cell at column $i, row $j pressed.'),

The initial scroll offset of the table in the x and y directions can be set by using the properties:
- initialScrollOffsetX
- initialScrollOffsetY

You can also set a callback for when the scrolling ends by setting the onEndScrolling property.

By combining the two above features, you can return to the previous scroll position after a rebuild. See example below:

```dart
double _scrollOffsetX = 0.0;
double _scrollOffsetY = 0.0;

StickyHeadersTable(
  // ... other properties ...
  initialScrollOffsetX: _scrollOffsetX,
  initialScrollOffsetY: _scrollOffsetY,
  onEndScrolling: (scrollOffsetX, scrollOffsetY) {
    _scrollOffsetX = scrollOffsetX;
    _scrollOffsetY = scrollOffsetY;
  },
)
```

You can also define a custom set of scroll controllers for both title and body with the ```scrollControllers``` property
  
Feature requests and PRs are welcome.  

![Examples](https://github.com/AlexBacich/sticky-headers-table/blob/master/example/sticky_demo.gif?raw=true)

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
