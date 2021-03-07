import 'dart:ui';

/// Dimensions for table.
class CellDimensions {
  static const CellDimensions base = CellDimensions.fixed(
    contentCellWidth: 70.0,
    contentCellHeight: 50.0,
    stickyLegendWidth: 120.0,
    stickyLegendHeight: 50.0,
  );

  @Deprecated('Use CellDimensions.fixed instead.')
  const CellDimensions({
    /// Content cell width. Also applied to sticky row width.
    required this.contentCellWidth,

    /// Content cell height. Also applied to sticky column height.
    required this.contentCellHeight,

    /// Sticky legend width. Also applied to sticky column width.
    required this.stickyLegendWidth,

    /// Sticky legend height. Also applied to sticky row height.
    required this.stickyLegendHeight,
  })   : this.columnWidths = null,
        this.rowHeights = null;

  /// Same dimensions for each cell.
  const CellDimensions.uniform({
    required double width,
    required double height,
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
    required this.contentCellWidth,

    /// Content cell height. Also applied to sticky column height.
    required this.contentCellHeight,

    /// Sticky legend width. Also applied to sticky column width.
    required this.stickyLegendWidth,

    /// Sticky legend height. Also applied to sticky row height.
    required this.stickyLegendHeight,
  })   : this.columnWidths = null,
        this.rowHeights = null;

  /// Different width for each column.
  const CellDimensions.variableColumnWidth({
    /// Column widths (for content only). Also applied to sticky row widths.
    /// Length of list needs to match columnsLength.
    required this.columnWidths,

    /// Content cell height. Also applied to sticky column height.
    required this.contentCellHeight,

    /// Sticky legend width. Also applied to sticky column width.
    required this.stickyLegendWidth,

    /// Sticky legend height. Also applied to sticky row height.
    required this.stickyLegendHeight,
  })   : this.contentCellWidth = null,
        this.rowHeights = null;

  /// Different height for each row.
  const CellDimensions.variableRowHeight({
    /// Content cell width. Also applied to sticky row width.
    required this.contentCellWidth,

    /// Row heights (for content only). Also applied to sticky row heights.
    /// Length of list needs to match rowsLength.
    required this.rowHeights,

    /// Sticky legend width. Also applied to sticky column width.
    required this.stickyLegendWidth,

    /// Sticky legend height. Also applied to sticky row height.
    required this.stickyLegendHeight,
  })   : this.columnWidths = null,
        this.contentCellHeight = null;

  /// Different width for each column and different height for each row.
  const CellDimensions.variableColumnWidthAndRowHeight({
    /// Column widths (for content only). Also applied to sticky row widths.
    /// Length of list needs to match columnsLength.
    required this.columnWidths,

    /// Row heights (for content only). Also applied to sticky row heights.
    /// Length of list needs to match rowsLength.
    required this.rowHeights,

    /// Sticky legend width. Also applied to sticky column width.
    required this.stickyLegendWidth,

    /// Sticky legend height. Also applied to sticky row height.
    required this.stickyLegendHeight,
  })   : this.contentCellWidth = null,
        this.contentCellHeight = null;

  final double? contentCellWidth;
  final double? contentCellHeight;
  final List<double>? columnWidths;
  final List<double>? rowHeights;
  final double stickyLegendWidth;
  final double stickyLegendHeight;

  Size contentSize(int i, int j) {
    final width =
        (columnWidths != null ? columnWidths![j] : contentCellWidth) ??
            base.contentCellWidth!;
    final height = (rowHeights != null ? rowHeights![i] : contentCellHeight) ??
        base.contentCellHeight!;
    return Size(width, height);
  }

  double stickyWidth(int i) =>
      (columnWidths != null ? columnWidths![i] : contentCellWidth) ??
      base.contentCellWidth!;

  double stickyHeight(int i) =>
      (rowHeights != null ? rowHeights![i] : contentCellHeight) ??
      base.contentCellHeight!;

  void runAssertions(int rowsLength, int columnsLength) {
    assert(contentCellWidth != null || columnWidths != null);
    assert(contentCellHeight != null || rowHeights != null);
    if (columnWidths != null) {
      assert(columnWidths!.length == columnsLength);
    }
    if (rowHeights != null) {
      assert(rowHeights!.length == rowsLength);
    }
  }
}
