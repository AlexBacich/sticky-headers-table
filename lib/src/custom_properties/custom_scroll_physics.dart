import 'package:flutter/widgets.dart';

class CustomScrollPhysics {
  CustomScrollPhysics({
    this.stickyRow,
    this.stickyColumn,
    this.contentVertical,
    this.contentHorizontal,
  });

  final ScrollPhysics? stickyRow;
  final ScrollPhysics? stickyColumn;
  final ScrollPhysics? contentVertical;
  final ScrollPhysics? contentHorizontal;
}
