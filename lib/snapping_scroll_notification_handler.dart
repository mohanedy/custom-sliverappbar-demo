import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

///
class SnappingScrollNotificationHandler {
  SnappingScrollNotificationHandler({
    required double expandedBarHeight,
    required double collapsedBarHeight,
  })  : _expandedBarHeight = expandedBarHeight,
        _collapsedBarHeight = collapsedBarHeight,
        assert(
            expandedBarHeight > 0.0, 'Expanded Bar Height cannot be negative'),
        assert(collapsedBarHeight > 0.0,
            'Collapsed bar height cannot have a negative value'),
        assert(collapsedBarHeight < expandedBarHeight,
            'Expanded bar height value must have a higher value than the collapsed bar height value');

  final double _expandedBarHeight;
  final double _collapsedBarHeight;

  /// Scrolling Notification listener
  ///
  /// triggers haptic feedback and snaps the appbar to either collapse or expand
  /// depending on which state is closest to the current scrolling offset
  bool onScrollOffsetChanged({
    required ScrollNotification notification,
    required ScrollController scrollController,
    required ValueNotifier<bool> isCollapsed,
    required ValueNotifier<double> scrollPercentage,
    required ValueNotifier<bool> didAddFeedback,
    required ValueNotifier<bool> shouldScrollNotifier,
    required ValueNotifier<double> scrollToOffsetNotifier,
  }) {
    _addHapticFeedback(isCollapsed, didAddFeedback);

    /// The position at which we either collapse or expand
    ///
    /// the threshold which if we exceed then we should expand
    /// otherwise we should collapse the appbar
    final double expandThresholdPosition =
        (_expandedBarHeight - _collapsedBarHeight) / 2;

    /// The current position of the scrolling
    final double currentScrollingPosition = scrollController.offset;


    scrollPercentage.value =
        1 - scrollController.offset / scrollController.position.maxScrollExtent;

    /// sets the collapsed and expanded views as the user scrolls
    //region Update isCollapsed value as user scrolls
    isCollapsed.value = scrollController.hasClients &&
        scrollController.offset > expandThresholdPosition;
    //endregion

    //region
    if (notification is ScrollEndNotification) {
      _expandAppBar(
        currentScrollingPosition: currentScrollingPosition,
        expandThresholdPosition: expandThresholdPosition,
        scrollController: scrollController,
      );

      _collapseAppBar(
        currentScrollingPosition: currentScrollingPosition,
        expandThresholdPosition: expandThresholdPosition,
        scrollController: scrollController,
      );
    }
    //endregion

    return false;
  }

  /// Adds and triggers haptic feedback
  ///
  ///
  void _addHapticFeedback(
      ValueNotifier<bool> isCollapsed, ValueNotifier<bool> didAddFeedback) {
    if (isCollapsed.value && !didAddFeedback.value) {
      HapticFeedback.mediumImpact();
      didAddFeedback.value = true;
    } else if (!isCollapsed.value) {
      didAddFeedback.value = false;
    }
  }

  /// Expands Appbar
  ///
  /// start is 0 Offset
  void _expandAppBar({
    required double currentScrollingPosition,
    required double expandThresholdPosition,
    required ScrollController scrollController,
  }) {
    if (currentScrollingPosition > _collapsedBarHeight &&
        currentScrollingPosition < expandThresholdPosition) {
      scrollToOffset(
        scrollController: scrollController,
        scrollToOffset: 0.0,
      );
    }
  }

  /// Collapses Appbar
  ///
  /// subtracting collapsedBarHeight
  /// so the buttons section doesn't get hidden beneath the appbar
  void _collapseAppBar({
    required double currentScrollingPosition,
    required double expandThresholdPosition,
    required ScrollController scrollController,
  }) {
    if (currentScrollingPosition > expandThresholdPosition &&
        currentScrollingPosition < _expandedBarHeight) {
      scrollToOffset(
        scrollController: scrollController,
        scrollToOffset: _expandedBarHeight - _collapsedBarHeight,
      );
    }
  }

  /// Scrolls to the calculated [scrollToOffset] from the previous step
  ///
  /// snaps the appbar to either collapse or expand depending on which
  /// state is closest to the current scrolling offset
  void scrollToOffset({
    required ScrollController scrollController,
    required double scrollToOffset,
  }) {
    Future.microtask(
      () => scrollController.animateTo(
        scrollToOffset,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeIn,
      ),
    );
  }
}
