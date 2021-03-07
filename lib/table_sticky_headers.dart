library table_sticky_headers;

export 'cell_alignments.dart';
export 'cell_dimensions.dart';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'cell_alignments.dart';
import 'cell_dimensions.dart';

/// Table with sticky headers. Whenever you scroll content horizontally
/// or vertically - top and left headers always stay.
class StickyHeadersTable extends StatefulWidget {
  StickyHeadersTable({
    Key? key,

    /// Number of Columns (for content only)
    required this.columnsLength,

    /// Number of Rows (for content only)
    required this.rowsLength,

    /// Title for Top Left cell (always visible)
    this.legendCell = const Text(''),

    /// Builder for column titles. Takes index of content column as parameter
    /// and returns String for column title
    required this.columnsTitleBuilder,

    /// Builder for row titles. Takes index of content row as parameter
    /// and returns String for row title
    required this.rowsTitleBuilder,

    /// Builder for content cell. Takes index for content column first,
    /// index for content row second and returns String for cell
    required this.contentCellBuilder,

    /// Table cell dimensions
    this.cellDimensions = CellDimensions.base,

    /// Alignments for cell contents
    this.cellAlignments = CellAlignments.base,

    /// Callbacks for when pressing a cell
    Function()? onStickyLegendPressed,
    Function(int columnIndex)? onColumnTitlePressed,
    Function(int rowIndex)? onRowTitlePressed,
    Function(int columnIndex, int rowIndex)? onContentCellPressed,

    /// Initial scroll offsets in X and Y directions
    this.initialScrollOffsetX = 0.0,
    this.initialScrollOffsetY = 0.0,

    /// Called when scrolling has ended, passing the current offset position
    this.onEndScrolling,

    /// Scroll controllers for the table
    ScrollControllers? scrollControllers,
  })  : this.scrollControllers = scrollControllers ?? ScrollControllers(),
        this.onStickyLegendPressed = onStickyLegendPressed ?? (() {}),
        this.onColumnTitlePressed = onColumnTitlePressed ?? ((_) {}),
        this.onRowTitlePressed = onRowTitlePressed ?? ((_) {}),
        this.onContentCellPressed = onContentCellPressed ?? ((_, __) {}),
        super(key: key) {
    cellDimensions.runAssertions(rowsLength, columnsLength);
    cellAlignments.runAssertions(rowsLength, columnsLength);
  }

  final int rowsLength;
  final int columnsLength;
  final Widget legendCell;
  final Widget Function(int columnIndex) columnsTitleBuilder;
  final Widget Function(int rowIndex) rowsTitleBuilder;
  final Widget Function(int columnIndex, int rowIndex) contentCellBuilder;
  final CellDimensions cellDimensions;
  final CellAlignments cellAlignments;
  final Function() onStickyLegendPressed;
  final Function(int columnIndex) onColumnTitlePressed;
  final Function(int rowIndex) onRowTitlePressed;
  final Function(int columnIndex, int rowIndex) onContentCellPressed;
  final double initialScrollOffsetX;
  final double initialScrollOffsetY;
  final Function(double x, double y)? onEndScrolling;
  final ScrollControllers scrollControllers;

  @override
  _StickyHeadersTableState createState() => _StickyHeadersTableState();
}

class _StickyHeadersTableState extends State<StickyHeadersTable> {
  late _SyncScrollController _horizontalSyncController;
  late _SyncScrollController _verticalSyncController;

  late double _scrollOffsetX;
  late double _scrollOffsetY;

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
    SchedulerBinding.instance?.addPostFrameCallback((_) {
      widget.scrollControllers._horizontalTitleController
          .jumpTo(widget.initialScrollOffsetX);
      widget.scrollControllers._verticalTitleController
          .jumpTo(widget.initialScrollOffsetY);
    });
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            // STICKY LEGEND
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: widget.onStickyLegendPressed,
              child: Container(
                width: widget.cellDimensions.stickyLegendWidth,
                height: widget.cellDimensions.stickyLegendHeight,
                alignment: widget.cellAlignments.stickyLegendAlignment,
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
                      (i) => GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => widget.onColumnTitlePressed(i),
                        child: Container(
                          width: widget.cellDimensions.stickyWidth(i),
                          height: widget.cellDimensions.stickyLegendHeight,
                          alignment: widget.cellAlignments.rowAlignment(i),
                          child: widget.columnsTitleBuilder(i),
                        ),
                      ),
                    ),
                  ),
                  controller:
                      widget.scrollControllers._horizontalTitleController,
                ),
                onNotification: (ScrollNotification notification) {
                  final didEndScrolling =
                      _horizontalSyncController.processNotification(
                    notification,
                    widget.scrollControllers._horizontalTitleController,
                  );
                  if (widget.onEndScrolling != null && didEndScrolling) {
                    _scrollOffsetX = widget
                        .scrollControllers._horizontalTitleController.offset;
                    widget.onEndScrolling!(_scrollOffsetX, _scrollOffsetY);
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
                        onTap: () => widget.onRowTitlePressed(i),
                        child: Container(
                          width: widget.cellDimensions.stickyLegendWidth,
                          height: widget.cellDimensions.stickyHeight(i),
                          alignment: widget.cellAlignments.columnAlignment(i),
                          child: widget.rowsTitleBuilder(i),
                        ),
                      ),
                    ),
                  ),
                  controller: widget.scrollControllers._verticalTitleController,
                ),
                onNotification: (ScrollNotification notification) {
                  final didEndScrolling =
                      _verticalSyncController.processNotification(
                    notification,
                    widget.scrollControllers._verticalTitleController,
                  );
                  if (widget.onEndScrolling != null && didEndScrolling) {
                    _scrollOffsetY = widget
                        .scrollControllers._verticalTitleController.offset;
                    widget.onEndScrolling!(_scrollOffsetX, _scrollOffsetY);
                  }
                  return true;
                },
              ),
              // CONTENT
              Expanded(
                child: NotificationListener<ScrollNotification>(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    controller:
                        widget.scrollControllers._horizontalBodyController,
                    child: NotificationListener<ScrollNotification>(
                      child: SingleChildScrollView(
                        controller:
                            widget.scrollControllers._verticalBodyController,
                        child: Column(
                          children: List.generate(
                            widget.rowsLength,
                            (int rowIdx) => Row(
                              children: List.generate(
                                widget.columnsLength,
                                (int columnIdx) => GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () => widget.onContentCellPressed(
                                      columnIdx, rowIdx),
                                  child: Container(
                                    width: widget.cellDimensions
                                        .contentSize(rowIdx, columnIdx)
                                        .width,
                                    height: widget.cellDimensions
                                        .contentSize(rowIdx, columnIdx)
                                        .height,
                                    alignment: widget.cellAlignments
                                        .contentAlignment(rowIdx, columnIdx),
                                    child: widget.contentCellBuilder(
                                        columnIdx, rowIdx),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      onNotification: (ScrollNotification notification) {
                        final didEndScrolling =
                            _verticalSyncController.processNotification(
                          notification,
                          widget.scrollControllers._verticalBodyController,
                        );
                        if (widget.onEndScrolling != null && didEndScrolling) {
                          _scrollOffsetY = widget
                              .scrollControllers._verticalBodyController.offset;
                          widget.onEndScrolling!(
                              _scrollOffsetX, _scrollOffsetY);
                        }
                        return true;
                      },
                    ),
                  ),
                  onNotification: (ScrollNotification notification) {
                    final didEndScrolling =
                        _horizontalSyncController.processNotification(
                      notification,
                      widget.scrollControllers._horizontalBodyController,
                    );
                    if (widget.onEndScrolling != null && didEndScrolling) {
                      _scrollOffsetX = widget
                          .scrollControllers._horizontalBodyController.offset;
                      widget.onEndScrolling!(_scrollOffsetX, _scrollOffsetY);
                    }
                    return true;
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ScrollControllers {
  final ScrollController _verticalTitleController;
  final ScrollController _verticalBodyController;

  final ScrollController _horizontalBodyController;
  final ScrollController _horizontalTitleController;

  ScrollControllers({
    ScrollController? verticalTitleController,
    ScrollController? verticalBodyController,
    ScrollController? horizontalBodyController,
    ScrollController? horizontalTitleController,
  })  : this._verticalTitleController =
            verticalTitleController ?? ScrollController(),
        this._verticalBodyController =
            verticalBodyController ?? ScrollController(),
        this._horizontalBodyController =
            horizontalBodyController ?? ScrollController(),
        this._horizontalTitleController =
            horizontalTitleController ?? ScrollController();
}

/// SyncScrollController keeps scroll controllers in sync.
class _SyncScrollController {
  _SyncScrollController(List<ScrollController> controllers) {
    controllers
        .forEach((controller) => _registeredScrollControllers.add(controller));
  }

  final List<ScrollController> _registeredScrollControllers = [];

  ScrollController? _scrollingController;
  bool _scrollingActive = false;

  /// Returns true if reached scroll end
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
          controller.jumpTo(_scrollingController!.offset);
        }
      }
    }
    return false;
  }
}
