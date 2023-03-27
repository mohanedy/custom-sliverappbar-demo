import 'package:flutter/material.dart';

/// The type of expanded content.
/// This determines how the expanded content is displayed.
///
/// - [normal]: the expanded content is displayed as is.
/// - [animatedOpacity]: the expanded content is displayed with an animated opacity.
/// The opacity is calculated based on the scroll percentage.
///
enum ExpandedContentType {
  /// The expanded content is displayed as is.
  ///
  normal,

  /// The expanded content is displayed with an animated opacity.
  /// The opacity is calculated based on the scroll percentage.
  ///
  animatedOpacity;

  /// Returns the widget for the expanded content, based on the ExpandedContentType.
  ///
  /// If the ExpandedContentType is normal, the expandedContent is returned as is.
  /// If the ExpandedContentType is animatedOpacity, an AnimatedOpacity widget is returned,
  /// with a duration of 150 milliseconds, and an opacity calculated based on the
  /// scrollPercentage passed to _calculateOpacity function.
  ///
  /// Params:
  /// - expandedContent: the widget for the expanded content, a Widget.
  /// - scrollController: the scroll controller for the parent widget, a ScrollController.
  /// - expandedContentHeight: the height of the expanded content, a double.
  Widget getExpandedContentWidget(
    Widget expandedContent,
    ScrollController? scrollController,
    double? expandedContentHeight,
  ) {
    final scrollPercentage = _calculateScrollPercentage(
      scrollController: scrollController,
      expandedContentHeight: expandedContentHeight,
    );

    switch (this) {
      case ExpandedContentType.normal:
        return expandedContent;
      case ExpandedContentType.animatedOpacity:
        return AnimatedOpacity(
          duration: const Duration(milliseconds: 150),
          opacity: _calculateOpacity(scrollPercentage),
          child: expandedContent,
        );
    }
  }

  /// Calculates the opacity based on the scroll percentage.
  ///
  /// The opacity is calculated as follows:
  /// - If the scroll percentage is less than [opacityThreshold],
  /// the opacity is 0.0.
  ///
  /// - If the scroll percentage is less than [maxScrollPercentage],
  /// the opacity is
  /// [scrollPercentage] minus [opacityAdjustment].
  ///
  /// - Otherwise, the opacity is [scrollPercentage].
  ///
  /// Throws an [ArgumentError] if [scrollPercentage] is not between 0 and 1.0.
  ///
  /// Params:
  /// - [scrollPercentage]: the percentage of the scroll position, a double value
  /// Returns:
  /// - The calculated opacity, a double value
  double _calculateOpacity(double scrollPercentage) {
    const double opacityThreshold = 0.5;
    const double opacityAdjustment = 0.5;
    const double maxScrollPercentage = 1.0;

    if (scrollPercentage < 0 || scrollPercentage > maxScrollPercentage) {
      throw ArgumentError('scrollPercentage must be between 0 and 1.0');
    }

    if (scrollPercentage < opacityThreshold) {
      return 0.0;
    } else if (scrollPercentage < maxScrollPercentage) {
      return scrollPercentage - opacityAdjustment;
    } else {
      return scrollPercentage;
    }
  }

  /// Returns the calculated scroll percentage of scroll position
  /// based on the given [scrollController] and [expandedContentHeight].
  ///
  /// The percentage of scroll position is calculated as follows:
  /// - The [scrollPosition] is obtained from [scrollController] and if it is null, 0.0 is used as default.
  ///
  /// - The [scrollPercentage] is calculated by dividing [scrollPosition] by [expandedContentHeight] and if it is null, 0.0 is used as default.
  ///
  /// - The final scroll percentage is calculated as 1 subtracted by [scrollPercentage].
  /// as the scroll position is measured from the top of the widget attached to the [scrollController].
  ///
  /// Params:
  /// - [scrollController] : the controller of the scroll view, a [ScrollController] object
  /// - [expandedContentHeight] : the height of the expanded content, a double value
  ///
  /// Returns:
  double _calculateScrollPercentage({
    required ScrollController? scrollController,
    required double? expandedContentHeight,
  }) {
    final scrollPosition = scrollController?.position.pixels ?? 0.0;
    final scrollPercentage = scrollPosition / (expandedContentHeight ?? 0.0);

    return 1 - scrollPercentage;
  }
}
