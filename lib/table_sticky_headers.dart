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
    this.legendCell = '',

    /// Builder for column titles. Takes index of content column as parameter
    /// and returns String for column title
    @required this.columnsTitleBuilder,

    /// Builder for row titles. Takes index of content row as parameter
    /// and returns String for row title
    @required this.rowsTitleBuilder,

    /// Builder for content cell. Takes index for content column first,
    /// index for content row second and returns String for cell
    @required this.contentCellBuilder,
  }) : super(key: key) {
    assert(columnsLength != null);
    assert(rowsLength != null);
    assert(columnsTitleBuilder != null);
    assert(rowsTitleBuilder != null);
    assert(contentCellBuilder != null);
  }

  final int rowsLength;
  final int columnsLength;
  final String legendCell;
  final String Function(int colulmnIndex) columnsTitleBuilder;
  final String Function(int rowIndex) rowsTitleBuilder;
  final String Function(int columnIndex, int rowIndex) contentCellBuilder;

  @override
  _StickyHeadersTableState createState() => _StickyHeadersTableState();
}

class _StickyHeadersTableState extends State<StickyHeadersTable> {
  final ScrollController _verticalTitleController = ScrollController();
  final ScrollController _verticalBodyController = ScrollController();

  final ScrollController _horizontalBodyController = ScrollController();
  final ScrollController _horizontalTitleController = ScrollController();

  SyncScrollController _verticalSyncController;
  SyncScrollController _horizontalSyncController;

  @override
  void initState() {
    super.initState();
    _verticalSyncController = SyncScrollController(
        [_verticalTitleController, _verticalBodyController]);
    _horizontalSyncController = SyncScrollController(
        [_horizontalTitleController, _horizontalBodyController]);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            // TOP LEFT STICKY
            _Item(widget.legendCell, cellType: CellType.Legend),
            // TOP TITLE STICKY
            Expanded(
              child: NotificationListener<ScrollNotification>(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(
                      widget.columnsLength,
                      (i) => _Item(
                        widget.columnsTitleBuilder(i),
                        cellType: CellType.Top,
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
              // LEFT TITLE STICKY
              NotificationListener<ScrollNotification>(
                child: SingleChildScrollView(
                  child: Column(
                    children: List.generate(
                      widget.rowsLength,
                      (i) => _Item(
                        widget.rowsTitleBuilder(i),
                        cellType: CellType.Left,
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
              // BODY PRICES
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
                                  (int j) {
                                    return _Item(
                                      widget.contentCellBuilder(j, i),
                                      cellType: CellType.Body,
                                    );
                                  },
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

enum CellType {
  Top,
  Left,
  Body,
  Legend,
}

class _Item extends StatelessWidget {
  _Item(this.text, {@required this.cellType, this.onTap});

  final String text;
  final CellType cellType;
  final Function onTap;

  double get _width =>
      cellType == CellType.Left || cellType == CellType.Legend ? 120.0 : 70.0;

  Color get _colorBg => cellType == CellType.Left || cellType == CellType.Body
      ? Colors.white
      : Colors.amber;

  Color get _colorHorizontalBorder =>
      cellType == CellType.Left || cellType == CellType.Body
          ? Colors.amber
          : Colors.white;

  Color get _colorVerticalBorder =>
      cellType == CellType.Left || cellType == CellType.Body
          ? Colors.black38
          : Colors.amber;

  EdgeInsets get _padding =>
      cellType == CellType.Left || cellType == CellType.Legend
          ? EdgeInsets.only(left: 24.0)
          : EdgeInsets.zero;

  TextAlign get _textAlign =>
      cellType == CellType.Left || cellType == CellType.Legend
          ? TextAlign.start
          : TextAlign.center;

  @override
  Widget build(BuildContext context) {
    TextStyle getTextStyle() {
      final textTheme = Theme.of(context).textTheme;
      if (cellType == CellType.Legend)
        return textTheme.button.copyWith(fontSize: 16.5);
      if (cellType == CellType.Top)
        return textTheme.button.copyWith(fontSize: 15.0);
      if (cellType == CellType.Left)
        return textTheme.button.copyWith(fontSize: 15.0);
      if (cellType == CellType.Body)
        return textTheme.body2.copyWith(fontSize: 12.0);
      return null;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: _width,
        height: 50,
        padding: _padding,
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: 2.0),
                child: Text(
                  text,
                  style: getTextStyle(),
                  maxLines: 2,
                  textAlign: _textAlign,
                ),
              ),
            ),
            Container(
              width: double.infinity,
              height: 1.1,
              color: _colorVerticalBorder,
            ),
          ],
        ),
        decoration: BoxDecoration(
            border: Border(
              left: BorderSide(color: _colorHorizontalBorder),
              right: BorderSide(color: _colorHorizontalBorder),
            ),
            color: _colorBg),
      ),
    );
  }
}

/// SyncScrollController keeps scroll controllers in sync.
class SyncScrollController {
  SyncScrollController(List<ScrollController> controllers) {
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
