import 'package:flutter/widgets.dart';

class ScrollControllers {
  ScrollControllers({
    ScrollController? verticalTitleController,
    ScrollController? verticalBodyController,
    ScrollController? horizontalBodyController,
    ScrollController? horizontalTitleController,
  })  : this.verticalTitleController =
            verticalTitleController ?? ScrollController(),
        this.verticalBodyController =
            verticalBodyController ?? ScrollController(),
        this.horizontalBodyController =
            horizontalBodyController ?? ScrollController(),
        this.horizontalTitleController =
            horizontalTitleController ?? ScrollController();

  final ScrollController verticalTitleController;
  final ScrollController verticalBodyController;

  final ScrollController horizontalBodyController;
  final ScrollController horizontalTitleController;

  void dispose() {
    verticalBodyController.dispose();
    verticalTitleController.dispose();

    horizontalBodyController.dispose();
    horizontalTitleController.dispose();
  }
}
