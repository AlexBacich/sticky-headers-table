library table_sticky_headers;

import 'package:flutter/material.dart';

/// Table with sticky headers. Whenever you scroll content horizontally
/// or vertically - top and left headers always stay.
class StickyHeadersTable extends StatefulWidget {
  StickyHeadersTable({
    Key key,

    /// Number of Columns (for content only)
    @required this.columnsLength,

    /// Number of Rows (for content only)
    @required this.rowsLength,

    /// Title for Top Left cell (always visible)
    this.legendCell = const Text(' '),

    /// Builder for column titles. Takes index of content column as parameter
    /// and returns String for column title
    @required this.columnsTitleBuilder,

    /// Builder for row titles. Takes index of content row as parameter
    /// and returns String for row title
    @required this.rowsTitleBuilder,

    /// Builder for content cell. Takes index for content column first,
    /// index for content row second and returns String for cell
    @required this.contentCellBuilder,

    /// Table cell dimensions
    this.cellDimensions = CellDimensions.base,

    /// Type of fit for content
    this.cellFit = BoxFit.scaleDown,
  }) : super(key: key) {
    assert(columnsLength != null);
    assert(rowsLength != null);
    assert(columnsTitleBuilder != null);
    assert(rowsTitleBuilder != null);
    assert(contentCellBuilder != null);
    assert(cellDimensions.contentCellWidth != null ||
        cellDimensions.columnWidths != null);
    assert(cellDimensions.contentCellHeight != null ||
        cellDimensions.rowHeights != null);
    if (cellDimensions.columnWidths != null) {
      assert(cellDimensions.columnWidths.length == columnsLength);
    }
    if (cellDimensions.rowHeights != null) {
      assert(cellDimensions.rowHeights.length == rowsLength);
    }
  }

  final int rowsLength;
  final int columnsLength;
  final Widget legendCell;
  final Widget Function(int colulmnIndex) columnsTitleBuilder;
  final Widget Function(int rowIndex) rowsTitleBuilder;
  final Widget Function(int columnIndex, int rowIndex) contentCellBuilder;
  final CellDimensions cellDimensions;
  final BoxFit cellFit;

  @override
  _StickyHeadersTableState createState() => _StickyHeadersTableState();
}

class _StickyHeadersTableState extends State<StickyHeadersTable> {
  final ScrollController _verticalTitleController = ScrollController();
  final ScrollController _verticalBodyController = ScrollController();

  final ScrollController _horizontalBodyController = ScrollController();
  final ScrollController _horizontalTitleController = ScrollController();

  _SyncScrollController _verticalSyncController;
  _SyncScrollController _horizontalSyncController;

  @override
  void initState() {
    super.initState();
    _verticalSyncController = _SyncScrollController(
        [_verticalTitleController, _verticalBodyController]);
    _horizontalSyncController = _SyncScrollController(
        [_horizontalTitleController, _horizontalBodyController]);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            // STICKY LEGEND
            Container(
              width: widget.cellDimensions.stickyLegendWidth,
              height: widget.cellDimensions.stickyLegendHeight,
              child: FittedBox(
                fit: widget.cellFit,
                child: widget.legendCell,
              ),
            ),
            // STICKY ROW
            Expanded(
              child: NotificationListener<ScrollNotification>(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(
                      widget.columnsLength,
                      (i) => Container(
                        width: widget.cellDimensions.columnWidths != null
                            ? widget.cellDimensions.columnWidths[i]
                            : widget.cellDimensions.contentCellWidth,
                        height: widget.cellDimensions.stickyLegendHeight,
                        child: FittedBox(
                          fit: widget.cellFit,
                          child: widget.columnsTitleBuilder(i),
                        ),
                      ),
                    ),
                  ),
                  controller: _horizontalTitleController,
                ),
                onNotification: (ScrollNotification notification) {
                  _horizontalSyncController.processNotification(
                      notification, _horizontalTitleController);
                  return true;
                },
              ),
            )
          ],
        ),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // STICKY COLUMN
              NotificationListener<ScrollNotification>(
                child: SingleChildScrollView(
                  child: Column(
                    children: List.generate(
                      widget.rowsLength,
                      (i) => Container(
                        width: widget.cellDimensions.stickyLegendWidth,
                        height: widget.cellDimensions.rowHeights != null
                            ? widget.cellDimensions.rowHeights[i]
                            : widget.cellDimensions.contentCellHeight,
                        child: FittedBox(
                          fit: widget.cellFit,
                          child: widget.rowsTitleBuilder(i),
                        ),
                      ),
                    ),
                  ),
                  controller: _verticalTitleController,
                ),
                onNotification: (ScrollNotification notification) {
                  _verticalSyncController.processNotification(
                      notification, _verticalTitleController);
                  return true;
                },
              ),
              // CONTENT
              Expanded(
                child: NotificationListener<ScrollNotification>(
                  onNotification: (ScrollNotification notification) {
                    _horizontalSyncController.processNotification(
                        notification, _horizontalBodyController);
                    return true;
                  },
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    controller: _horizontalBodyController,
                    child: NotificationListener<ScrollNotification>(
                      child: SingleChildScrollView(
                          controller: _verticalBodyController,
                          child: Column(
                            children: List.generate(
                              widget.rowsLength,
                              (int i) => Row(
                                children: List.generate(
                                  widget.columnsLength,
                                  (int j) => Container(
                                    width: widget.cellDimensions.columnWidths !=
                                            null
                                        ? widget.cellDimensions.columnWidths[j]
                                        : widget
                                            .cellDimensions.contentCellWidth,
                                    height: widget.cellDimensions.rowHeights !=
                                            null
                                        ? widget.cellDimensions.rowHeights[i]
                                        : widget
                                            .cellDimensions.contentCellHeight,
                                    child: FittedBox(
                                      fit: widget.cellFit,
                                      child: widget.contentCellBuilder(j, i),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )),
                      onNotification: (ScrollNotification notification) {
                        _verticalSyncController.processNotification(
                            notification, _verticalBodyController);
                        return true;
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Dimensions for table
class CellDimensions {
  @Deprecated('Use CellDimensions.fixed instead.')
  const CellDimensions({
    /// Content cell width. Also applied to sticky row width.
    @required this.contentCellWidth,

    /// Content cell height. Also applied to sticky column height.
    @required this.contentCellHeight,

    /// Sticky legend width. Also applied to sticky column width.
    @required this.stickyLegendWidth,

    /// Sticky legend height. Also applied to sticky row height.
    @required this.stickyLegendHeight,
  })  : this.columnWidths = null,
        this.rowHeights = null;

  /// Use if the same width and height is needed for each content cell.
  const CellDimensions.fixed({
    /// Content cell width. Also applied to sticky row width.
    @required this.contentCellWidth,

    /// Content cell height. Also applied to sticky column height.
    @required this.contentCellHeight,

    /// Sticky legend width. Also applied to sticky column width.
    @required this.stickyLegendWidth,

    /// Sticky legend height. Also applied to sticky row height.
    @required this.stickyLegendHeight,
  })  : this.columnWidths = null,
        this.rowHeights = null;

  /// Use if different width is needed for each column.
  const CellDimensions.variableColumnWidth({
    /// Column widths. Also applied to sticky row widths.
    /// Length of list needs to match columnsLength.
    @required this.columnWidths,

    /// Content cell height. Also applied to sticky column height.
    @required this.contentCellHeight,

    /// Sticky legend width. Also applied to sticky column width.
    @required this.stickyLegendWidth,

    /// Sticky legend height. Also applied to sticky row height.
    @required this.stickyLegendHeight,
  })  : this.contentCellWidth = null,
        this.rowHeights = null;

  /// Use if different height is needed for each row.
  const CellDimensions.variableRowHeight({
    /// Content cell width. Also applied to sticky row width.
    @required this.contentCellWidth,

    /// Row heights. Also applied to sticky row heights.
    /// Length of list needs to match rowsLength.
    @required this.rowHeights,

    /// Sticky legend width. Also applied to sticky column width.
    @required this.stickyLegendWidth,

    /// Sticky legend height. Also applied to sticky row height.
    @required this.stickyLegendHeight,
  })  : this.columnWidths = null,
        this.contentCellHeight = null;

  /// Use if different width is needed for each column and different height
  /// is needed for each row.
  const CellDimensions.variableColumnWidthAndRowHeight({
    /// Column widths. Also applied to sticky row widths.
    /// Length of list needs to match columnsLength.
    @required this.columnWidths,

    /// Row heights. Also applied to sticky row heights.
    /// Length of list needs to match rowsLength.
    @required this.rowHeights,

    /// Sticky legend width. Also applied to sticky column width.
    @required this.stickyLegendWidth,

    /// Sticky legend height. Also applied to sticky row height.
    @required this.stickyLegendHeight,
  })  : this.contentCellWidth = null,
        this.contentCellHeight = null;

  final double contentCellWidth;
  final double contentCellHeight;
  final List<double> columnWidths;
  final List<double> rowHeights;
  final double stickyLegendWidth;
  final double stickyLegendHeight;

  static const CellDimensions base = CellDimensions.fixed(
    contentCellWidth: 70.0,
    contentCellHeight: 50.0,
    stickyLegendWidth: 120.0,
    stickyLegendHeight: 50.0,
  );
}

/// SyncScrollController keeps scroll controllers in sync.
class _SyncScrollController {
  _SyncScrollController(List<ScrollController> controllers) {
    controllers
        .forEach((controller) => _registeredScrollControllers.add(controller));
  }

  final List<ScrollController> _registeredScrollControllers = [];

  ScrollController _scrollingController;
  bool _scrollingActive = false;

  processNotification(
      ScrollNotification notification, ScrollController sender) {
    if (notification is ScrollStartNotification && !_scrollingActive) {
      _scrollingController = sender;
      _scrollingActive = true;
      return;
    }

    if (identical(sender, _scrollingController) && _scrollingActive) {
      if (notification is ScrollEndNotification) {
        _scrollingController = null;
        _scrollingActive = false;
        return;
      }

      if (notification is ScrollUpdateNotification) {
        for (ScrollController controller in _registeredScrollControllers) {
          if (identical(_scrollingController, controller)) continue;
          controller.jumpTo(_scrollingController.offset);
        }
      }
    }
  }
}
