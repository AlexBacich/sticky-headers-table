library table_sticky_headers;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'custom_properties/cell_alignments.dart';
import 'custom_properties/cell_dimensions.dart';
import 'custom_properties/custom_scroll_physics.dart';
import 'custom_properties/scroll_controllers.dart';

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

    /// Called when scrolling has ended, passing the current offset position
    this.onEndScrolling,

    /// Scroll controllers for the table. Make sure that you dispose ScrollControllers inside when you don't need table_sticky_headers anymore.
    ScrollControllers? scrollControllers,

    /// Custom Scroll physics for table
    CustomScrollPhysics? scrollPhysics,

    /// Table Direction to support RTL languages
    this.tableDirection = TextDirection.ltr,

    /// Initial scroll offsets in X and Y directions. Specified in points. Overrides scroll Offset in index if both are present.
    this.initialScrollOffsetX,
    this.initialScrollOffsetY,

    /// Initial scroll offsets in X and Y directions. Specified in index.
    this.scrollOffsetIndexX,
    this.scrollOffsetIndexY,
  })  : this.shouldDisposeScrollControllers = scrollControllers == null,
        this.scrollControllers = scrollControllers ?? ScrollControllers(),
        this.onStickyLegendPressed = onStickyLegendPressed ?? (() {}),
        this.onColumnTitlePressed = onColumnTitlePressed ?? ((_) {}),
        this.onRowTitlePressed = onRowTitlePressed ?? ((_) {}),
        this.onContentCellPressed = onContentCellPressed ?? ((_, __) {}),
        this.scrollPhysics = scrollPhysics ?? CustomScrollPhysics(),
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
  final Function(double x, double y)? onEndScrolling;
  final ScrollControllers scrollControllers;
  final CustomScrollPhysics scrollPhysics;
  final TextDirection tableDirection;
  final int? scrollOffsetIndexY;
  final int? scrollOffsetIndexX;
  final double? initialScrollOffsetX;
  final double? initialScrollOffsetY;

  final bool shouldDisposeScrollControllers;

  @override
  _StickyHeadersTableState createState() => _StickyHeadersTableState();
}

class _StickyHeadersTableState extends State<StickyHeadersTable> {
  final globalRowTitleKeys = <int, GlobalKey>{};
  final globalColumnTitleKeys = <int, GlobalKey>{};

  late _SyncScrollController _horizontalSyncController;
  late _SyncScrollController _verticalSyncController;

  late double _scrollOffsetX;
  late double _scrollOffsetY;

  void _shiftUsingOffsets() {
    final scrollOffsetX = widget.initialScrollOffsetX;
    if (scrollOffsetX != null) {
      // Try to use natural offset first
      widget.scrollControllers.horizontalTitleController.jumpTo(scrollOffsetX);
    } else {
      // Try to use index offset second
      final scrollOffsetIndexX = widget.scrollOffsetIndexX;
      final keyX = globalRowTitleKeys[scrollOffsetIndexX];
      if (scrollOffsetIndexX != null && keyX != null) {
        _verticalSyncController.jumpToIndex(keyX);
      }
    }

    final scrollOffsetY = widget.initialScrollOffsetY;
    if (scrollOffsetY != null) {
      // Try to use natural offset first
      widget.scrollControllers.verticalTitleController.jumpTo(scrollOffsetY);
    } else {
      // Try to use index offset second
      final scrollOffsetIndexY = widget.scrollOffsetIndexY;
      final keyY = globalColumnTitleKeys[scrollOffsetIndexY];
      if (scrollOffsetIndexY != null && keyY != null) {
        _horizontalSyncController.jumpToIndex(keyY);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollOffsetX = widget.initialScrollOffsetX ?? 0;
    _scrollOffsetY = widget.initialScrollOffsetY ?? 0;
  }

  @override
  void dispose() {
    if (widget.shouldDisposeScrollControllers) {
      widget.scrollControllers.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _verticalSyncController = _SyncScrollController([
      widget.scrollControllers.verticalTitleController,
      widget.scrollControllers.verticalBodyController,
    ]);
    _horizontalSyncController = _SyncScrollController([
      widget.scrollControllers.horizontalTitleController,
      widget.scrollControllers.horizontalBodyController,
    ]);
    SchedulerBinding.instance.addPostFrameCallback((_) => _shiftUsingOffsets());
    return Column(
      children: <Widget>[
        Row(
          textDirection: widget.tableDirection,
          children: <Widget>[
            /// STICKY LEGEND
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
            /// STICKY ROW
            Expanded(
              child: NotificationListener<ScrollNotification>(
                child: SingleChildScrollView(
                  reverse: widget.tableDirection == TextDirection.rtl,
                  physics: widget.scrollPhysics.stickyRow,
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    textDirection: widget.tableDirection,
                    children: List.generate(
                      widget.columnsLength,
                      (i) => GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => widget.onColumnTitlePressed(i),
                        child: Container(
                          key: globalRowTitleKeys[i] ??= GlobalKey(),
                          width: widget.cellDimensions.stickyWidth(i),
                          height: widget.cellDimensions.stickyLegendHeight,
                          alignment: widget.cellAlignments.rowAlignment(i),
                          child: widget.columnsTitleBuilder(i),
                        ),
                      ),
                    ),
                  ),
                  controller: widget.scrollControllers.horizontalTitleController,
                ),
                onNotification: (ScrollNotification notification) {
                  final didEndScrolling = _horizontalSyncController.processNotification(
                    notification,
                    widget.scrollControllers.horizontalTitleController,
                  );
                  if (widget.onEndScrolling != null && didEndScrolling) {
                    _scrollOffsetX = widget.scrollControllers.horizontalTitleController.offset;
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
            textDirection: widget.tableDirection,
            children: <Widget>[
              /// STICKY COLUMN
              NotificationListener<ScrollNotification>(
                child: SingleChildScrollView(
                  physics: widget.scrollPhysics.stickyColumn,
                  child: Column(
                    children: List.generate(
                      widget.rowsLength,
                      (i) => GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => widget.onRowTitlePressed(i),
                        child: Container(
                          key: globalColumnTitleKeys[i] ??= GlobalKey(),
                          width: widget.cellDimensions.stickyLegendWidth,
                          height: widget.cellDimensions.stickyHeight(i),
                          alignment: widget.cellAlignments.columnAlignment(i),
                          child: widget.rowsTitleBuilder(i),
                        ),
                      ),
                    ),
                  ),
                  controller: widget.scrollControllers.verticalTitleController,
                ),
                onNotification: (ScrollNotification notification) {
                  final didEndScrolling = _verticalSyncController.processNotification(
                    notification,
                    widget.scrollControllers.verticalTitleController,
                  );
                  if (widget.onEndScrolling != null && didEndScrolling) {
                    _scrollOffsetY = widget.scrollControllers.verticalTitleController.offset;
                    widget.onEndScrolling!(_scrollOffsetX, _scrollOffsetY);
                  }
                  return true;
                },
              ),
              // CONTENT
              Expanded(
                child: NotificationListener<ScrollNotification>(
                  child: SingleChildScrollView(
                    reverse: widget.tableDirection == TextDirection.rtl,
                    physics: widget.scrollPhysics.contentHorizontal,
                    scrollDirection: Axis.horizontal,
                    controller: widget.scrollControllers.horizontalBodyController,
                    child: NotificationListener<ScrollNotification>(
                      child: SingleChildScrollView(
                        physics: widget.scrollPhysics.contentVertical,
                        controller: widget.scrollControllers.verticalBodyController,
                        child: Column(
                          children: List.generate(
                            widget.rowsLength,
                            (int rowIdx) => Row(
                              textDirection: widget.tableDirection,
                              children: List.generate(
                                widget.columnsLength,
                                (int columnIdx) => GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () => widget.onContentCellPressed(columnIdx, rowIdx),
                                  child: Container(
                                    width: widget.cellDimensions.contentSize(rowIdx, columnIdx).width,
                                    height: widget.cellDimensions.contentSize(rowIdx, columnIdx).height,
                                    alignment: widget.cellAlignments.contentAlignment(rowIdx, columnIdx),
                                    child: widget.contentCellBuilder(columnIdx, rowIdx),
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
                          widget.scrollControllers.verticalBodyController,
                        );
                        if (widget.onEndScrolling != null && didEndScrolling) {
                          _scrollOffsetY = widget.scrollControllers.verticalBodyController.offset;
                          widget.onEndScrolling!(_scrollOffsetX, _scrollOffsetY);
                        }
                        return true;
                      },
                    ),
                  ),
                  onNotification: (ScrollNotification notification) {
                    final didEndScrolling = _horizontalSyncController.processNotification(
                      notification,
                      widget.scrollControllers.horizontalBodyController,
                    );
                    if (widget.onEndScrolling != null && didEndScrolling) {
                      _scrollOffsetX = widget.scrollControllers.horizontalBodyController.offset;
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



/// SyncScrollController keeps scroll controllers in sync.
class _SyncScrollController {
  _SyncScrollController(this._registeredScrollControllers);

  final List<ScrollController> _registeredScrollControllers;

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
          if (controller.positions.isEmpty) continue;
          final offset = _scrollingController?.offset;
          if (offset != null) {
            controller.jumpTo(offset);
          }
        }
      }
    }
    return false;
  }

  void jumpToIndex(GlobalKey key) {
    final context = key.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(context);
    }
  }
}