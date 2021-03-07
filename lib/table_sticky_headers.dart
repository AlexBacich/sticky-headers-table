library table_sticky_headers;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

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

    /// Alignments for cell contents
    this.cellAlignments = CellAlignments.base,

    /// Type of fit for content
    this.cellFit = BoxFit.scaleDown,

    /// Callbacks for when pressing a cell
    this.onStickyLegendPressed,
    this.onColumnTitlePressed,
    this.onRowTitlePressed,
    this.onContentCellPressed,

    /// Initial scroll offsets in X and Y directions
    this.initialScrollOffsetX = 0.0,
    this.initialScrollOffsetY = 0.0,

    /// Called when scrolling has ended, passing the current offset position
    this.onEndScrolling,

    /// Scroll controllers for the table
    ScrollControllers scrollControllers,
  })  : this.scrollControllers = scrollControllers ?? ScrollControllers(),
        super(key: key) {
    assert(columnsLength != null);
    assert(rowsLength != null);
    assert(columnsTitleBuilder != null);
    assert(rowsTitleBuilder != null);
    assert(contentCellBuilder != null);
    assert(cellDimensions.contentCellWidth != null || cellDimensions.columnWidths != null);
    assert(cellDimensions.contentCellHeight != null || cellDimensions.rowHeights != null);
    if (cellDimensions.columnWidths != null) {
      assert(cellDimensions.columnWidths.length == columnsLength);
    }
    if (cellDimensions.rowHeights != null) {
      assert(cellDimensions.rowHeights.length == rowsLength);
    }
    assert(cellAlignments.contentCellAlignment != null ||
        cellAlignments.columnAlignments != null ||
        cellAlignments.rowAlignments != null ||
        cellAlignments.contentCellAlignments != null);
    assert(cellAlignments.stickyColumnAlignment != null || cellAlignments.stickyColumnAlignments != null);
    assert(cellAlignments.stickyRowAlignment != null || cellAlignments.stickyRowAlignments != null);
    assert(cellAlignments.stickyLegendAlignment != null);
    if (cellAlignments.columnAlignments != null) {
      assert(cellAlignments.columnAlignments.length == columnsLength);
    }
    if (cellAlignments.rowAlignments != null) {
      assert(cellAlignments.rowAlignments.length == rowsLength);
    }
    if (cellAlignments.contentCellAlignments != null) {
      assert(cellAlignments.contentCellAlignments.length == rowsLength);
      for (int i = 0; i < cellAlignments.contentCellAlignments.length; i++) {
        assert(cellAlignments.contentCellAlignments[i].length == columnsLength);
      }
    }
    if (cellAlignments.stickyColumnAlignments != null) {
      assert(cellAlignments.stickyColumnAlignments.length == rowsLength);
    }
    if (cellAlignments.stickyRowAlignments != null) {
      assert(cellAlignments.stickyRowAlignments.length == columnsLength);
    }
  }

  final int rowsLength;
  final int columnsLength;
  final Widget legendCell;
  final Widget Function(int columnIndex) columnsTitleBuilder;
  final Widget Function(int rowIndex) rowsTitleBuilder;
  final Widget Function(int columnIndex, int rowIndex) contentCellBuilder;
  final CellDimensions cellDimensions;
  final CellAlignments cellAlignments;
  final BoxFit cellFit;
  final Function onStickyLegendPressed;
  final Function(int columnIndex) onColumnTitlePressed;
  final Function(int rowIndex) onRowTitlePressed;
  final Function(int columnIndex, int rowIndex) onContentCellPressed;
  final double initialScrollOffsetX;
  final double initialScrollOffsetY;
  final Function(double x, double y) onEndScrolling;
  final ScrollControllers scrollControllers;

  @override
  _StickyHeadersTableState createState() => _StickyHeadersTableState();
}

class _StickyHeadersTableState extends State<StickyHeadersTable> {
  _SyncScrollController _horizontalSyncController;
  _SyncScrollController _verticalSyncController;

  double _scrollOffsetX;
  double _scrollOffsetY;

  @override
  void initState() {
    super.initState();
    _scrollOffsetX = widget.initialScrollOffsetX;
    _scrollOffsetY = widget.initialScrollOffsetY;
    _verticalSyncController = _SyncScrollController([
      widget.scrollControllers._verticalTitleController,
      widget.scrollControllers._verticalBodyController,
    ]);
    _horizontalSyncController = _SyncScrollController([
      widget.scrollControllers._horizontalTitleController,
      widget.scrollControllers._horizontalBodyController,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      widget.scrollControllers._horizontalTitleController.jumpTo(widget.initialScrollOffsetX);
      widget.scrollControllers._verticalTitleController.jumpTo(widget.initialScrollOffsetY);
    });
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            // STICKY LEGEND
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: widget.onStickyLegendPressed ?? null,
              child: Container(
                width: widget.cellDimensions.stickyLegendWidth,
                height: widget.cellDimensions.stickyLegendHeight,
                alignment: widget.cellAlignments.stickyLegendAlignment,
                child: FittedBox(
                  fit: widget.cellFit,
                  child: widget.legendCell,
                ),
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
                      (i) => GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: widget.onColumnTitlePressed != null ? () => widget.onColumnTitlePressed(i) : null,
                        child: Container(
                          width: widget.cellDimensions.columnWidths != null
                              ? widget.cellDimensions.columnWidths[i]
                              : widget.cellDimensions.contentCellWidth,
                          height: widget.cellDimensions.stickyLegendHeight,
                          alignment: widget.cellAlignments.stickyRowAlignments != null
                              ? widget.cellAlignments.stickyRowAlignments[i]
                              : widget.cellAlignments.stickyRowAlignment,
                          child: FittedBox(
                            fit: widget.cellFit,
                            child: widget.columnsTitleBuilder(i),
                          ),
                        ),
                      ),
                    ),
                  ),
                  controller: widget.scrollControllers._horizontalTitleController,
                ),
                onNotification: (ScrollNotification notification) {
                  final didEndScrolling = _horizontalSyncController.processNotification(
                    notification,
                    widget.scrollControllers._horizontalTitleController,
                  );
                  if (widget.onEndScrolling != null && didEndScrolling) {
                    _scrollOffsetX = widget.scrollControllers._horizontalTitleController.offset;
                    widget.onEndScrolling(_scrollOffsetX, _scrollOffsetY);
                  }
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
                      (i) => GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: widget.onRowTitlePressed != null ? () => widget.onRowTitlePressed(i) : null,
                        child: Container(
                          width: widget.cellDimensions.stickyLegendWidth,
                          height: widget.cellDimensions.rowHeights != null
                              ? widget.cellDimensions.rowHeights[i]
                              : widget.cellDimensions.contentCellHeight,
                          alignment: widget.cellAlignments.stickyColumnAlignments != null
                              ? widget.cellAlignments.stickyColumnAlignments[i]
                              : widget.cellAlignments.stickyColumnAlignment,
                          child: FittedBox(
                            fit: widget.cellFit,
                            child: widget.rowsTitleBuilder(i),
                          ),
                        ),
                      ),
                    ),
                  ),
                  controller: widget.scrollControllers._verticalTitleController,
                ),
                onNotification: (ScrollNotification notification) {
                  final didEndScrolling = _verticalSyncController.processNotification(
                    notification,
                    widget.scrollControllers._verticalTitleController,
                  );
                  if (widget.onEndScrolling != null && didEndScrolling) {
                    _scrollOffsetY = widget.scrollControllers._verticalTitleController.offset;
                    widget.onEndScrolling(_scrollOffsetX, _scrollOffsetY);
                  }
                  return true;
                },
              ),
              // CONTENT
              Expanded(
                child: NotificationListener<ScrollNotification>(
                  onNotification: (ScrollNotification notification) {
                    final didEndScrolling = _horizontalSyncController.processNotification(
                      notification,
                      widget.scrollControllers._horizontalBodyController,
                    );
                    if (widget.onEndScrolling != null && didEndScrolling) {
                      _scrollOffsetX = widget.scrollControllers._horizontalBodyController.offset;
                      widget.onEndScrolling(_scrollOffsetX, _scrollOffsetY);
                    }
                    return true;
                  },
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    controller: widget.scrollControllers._horizontalBodyController,
                    child: NotificationListener<ScrollNotification>(
                      child: SingleChildScrollView(
                        controller: widget.scrollControllers._verticalBodyController,
                        child: Column(
                          children: List.generate(
                            widget.rowsLength,
                            (int i) => Row(
                              children: List.generate(
                                widget.columnsLength,
                                (int j) => GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: widget.onContentCellPressed != null
                                      ? () => widget.onContentCellPressed(j, i)
                                      : null,
                                  child: Container(
                                    width: widget.cellDimensions.columnWidths != null
                                        ? widget.cellDimensions.columnWidths[j]
                                        : widget.cellDimensions.contentCellWidth,
                                    height: widget.cellDimensions.rowHeights != null
                                        ? widget.cellDimensions.rowHeights[i]
                                        : widget.cellDimensions.contentCellHeight,
                                    alignment: (() {
                                      if (widget.cellAlignments.contentCellAlignment != null) {
                                        return widget.cellAlignments.contentCellAlignment;
                                      } else if (widget.cellAlignments.columnAlignments != null) {
                                        return widget.cellAlignments.columnAlignments[j];
                                      } else if (widget.cellAlignments.rowAlignments != null) {
                                        return widget.cellAlignments.rowAlignments[i];
                                      } else if (widget.cellAlignments.contentCellAlignments != null) {
                                        return widget.cellAlignments.contentCellAlignments[i][j];
                                      }
                                    }()),
                                    child: FittedBox(
                                      fit: widget.cellFit,
                                      child: widget.contentCellBuilder(j, i),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      onNotification: (ScrollNotification notification) {
                        final didEndScrolling = _verticalSyncController.processNotification(
                          notification,
                          widget.scrollControllers._verticalBodyController,
                        );
                        if (widget.onEndScrolling != null && didEndScrolling) {
                          _scrollOffsetY = widget.scrollControllers._verticalBodyController.offset;
                          widget.onEndScrolling(_scrollOffsetX, _scrollOffsetY);
                        }
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

/// Dimensions for table.
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

  /// Same dimensions for each cell.
  const CellDimensions.uniform({
    @required double width,
    @required double height,
  }) : this.fixed(
          contentCellWidth: width,
          contentCellHeight: height,
          stickyLegendWidth: width,
          stickyLegendHeight: height,
        );

  /// Same dimensions for each content cell, but different dimensions for the
  /// sticky legend, column and row.
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

  /// Different width for each column.
  const CellDimensions.variableColumnWidth({
    /// Column widths (for content only). Also applied to sticky row widths.
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

  /// Different height for each row.
  const CellDimensions.variableRowHeight({
    /// Content cell width. Also applied to sticky row width.
    @required this.contentCellWidth,

    /// Row heights (for content only). Also applied to sticky row heights.
    /// Length of list needs to match rowsLength.
    @required this.rowHeights,

    /// Sticky legend width. Also applied to sticky column width.
    @required this.stickyLegendWidth,

    /// Sticky legend height. Also applied to sticky row height.
    @required this.stickyLegendHeight,
  })  : this.columnWidths = null,
        this.contentCellHeight = null;

  /// Different width for each column and different height for each row.
  const CellDimensions.variableColumnWidthAndRowHeight({
    /// Column widths (for content only). Also applied to sticky row widths.
    /// Length of list needs to match columnsLength.
    @required this.columnWidths,

    /// Row heights (for content only). Also applied to sticky row heights.
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

/// Alignment for cell contents.
class CellAlignments {
  /// Same alignment for each cell.
  const CellAlignments.uniform(Alignment alignment)
      : this.fixed(
          contentCellAlignment: alignment,
          stickyColumnAlignment: alignment,
          stickyRowAlignment: alignment,
          stickyLegendAlignment: alignment,
        );

  /// Same alignment for each content cell, but different alignment for the
  /// sticky column, row and legend.
  const CellAlignments.fixed({
    /// Same alignment for each content cell.
    @required this.contentCellAlignment,

    /// Same alignment for each sticky column cell.
    @required this.stickyColumnAlignment,

    /// Same alignment for each sticky row cell.
    @required this.stickyRowAlignment,

    /// Alignment for the sticky legend cell.
    @required this.stickyLegendAlignment,
  })  : columnAlignments = null,
        rowAlignments = null,
        contentCellAlignments = null,
        stickyColumnAlignments = null,
        stickyRowAlignments = null;

  /// Different alignment for each column.
  const CellAlignments.variableColumnAlignment({
    /// Different alignment for each column (for content only).
    /// Length of list must match columnsLength.
    @required this.columnAlignments,

    /// Different alignment for each sticky row cell.
    /// Length of list must match columnsLength.
    @required this.stickyRowAlignments,

    /// Same alignment for each sticky column cell.
    @required this.stickyColumnAlignment,

    /// Alignment for the sticky legend cell.
    @required this.stickyLegendAlignment,
  })  : contentCellAlignment = null,
        rowAlignments = null,
        contentCellAlignments = null,
        stickyColumnAlignments = null,
        stickyRowAlignment = null;

  /// Different alignment for each row.
  const CellAlignments.variableRowAlignment({
    /// Different alignment for each row (for content only).
    /// Length of list must match rowsLength.
    @required this.rowAlignments,

    /// Different alignment for each sticky column cell.
    /// Length of list must match rowsLength.
    @required this.stickyColumnAlignments,

    /// Same alignment for each sticky row cell.
    @required this.stickyRowAlignment,

    /// Alignment for the sticky legend cell.
    @required this.stickyLegendAlignment,
  })  : contentCellAlignment = null,
        columnAlignments = null,
        contentCellAlignments = null,
        stickyRowAlignments = null,
        stickyColumnAlignment = null;

  /// Different alignment for every cell.
  const CellAlignments.variable({
    /// Different alignment for each content cell.
    /// Dimensions of array must match rowsLength x columnsLength.
    @required this.contentCellAlignments,

    /// Different alignment for each sticky column cell.
    /// Length of list must match rowsLength.
    @required this.stickyColumnAlignments,

    /// Different alignment for each sticky row cell.
    /// Length of list must match columnsLength.
    @required this.stickyRowAlignments,

    /// Alignment for the sticky legend cell.
    @required this.stickyLegendAlignment,
  })  : contentCellAlignment = null,
        columnAlignments = null,
        rowAlignments = null,
        stickyColumnAlignment = null,
        stickyRowAlignment = null;

  final Alignment contentCellAlignment;
  final List<Alignment> columnAlignments;
  final List<Alignment> rowAlignments;
  final List<List<Alignment>> contentCellAlignments;
  final Alignment stickyColumnAlignment;
  final List<Alignment> stickyColumnAlignments;
  final Alignment stickyRowAlignment;
  final List<Alignment> stickyRowAlignments;
  final Alignment stickyLegendAlignment;

  static const CellAlignments base = CellAlignments.uniform(Alignment.center);
}

class ScrollControllers {
  final ScrollController _verticalTitleController;
  final ScrollController _verticalBodyController;

  final ScrollController _horizontalBodyController;
  final ScrollController _horizontalTitleController;

  ScrollControllers({
    ScrollController verticalTitleController,
    ScrollController verticalBodyController,
    ScrollController horizontalBodyController,
    ScrollController horizontalTitleController,
  })  : this._verticalTitleController = verticalTitleController ?? ScrollController(),
        this._verticalBodyController = verticalBodyController ?? ScrollController(),
        this._horizontalBodyController = horizontalBodyController ?? ScrollController(),
        this._horizontalTitleController = horizontalTitleController ?? ScrollController();
}

/// SyncScrollController keeps scroll controllers in sync.
class _SyncScrollController {
  _SyncScrollController(List<ScrollController> controllers) {
    controllers.forEach((controller) => _registeredScrollControllers.add(controller));
  }

  final List<ScrollController> _registeredScrollControllers = [];

  ScrollController _scrollingController;
  bool _scrollingActive = false;

  bool processNotification(
    ScrollNotification notification,
    ScrollController controller,
  ) {
    if (notification is ScrollStartNotification && !_scrollingActive) {
      _scrollingController = controller;
      _scrollingActive = true;
      return false;
    }

    if (identical(controller, _scrollingController) && _scrollingActive) {
      if (notification is ScrollEndNotification) {
        _scrollingController = null;
        _scrollingActive = false;
        return true;
      }

      if (notification is ScrollUpdateNotification) {
        for (ScrollController controller in _registeredScrollControllers) {
          if (identical(_scrollingController, controller)) continue;
          controller.jumpTo(_scrollingController.offset);
        }
      }
    }
    return false;
  }
}
