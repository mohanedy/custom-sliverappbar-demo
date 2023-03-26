import 'package:custom_sliver_app_bar/snapping-collapsing-sliver-appbar/snapping_app_bar_body.dart';
import 'package:custom_sliver_app_bar/snapping-collapsing-sliver-appbar/snapping_scroll_notification_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class SnappingCollapsingAppBar extends HookWidget {
  const SnappingCollapsingAppBar({
    super.key,
    required this.expandedBar,
    required this.collapsedBar,
    required this.body,
    required this.isCollapsed,
    this.expandedBarHeight,
    this.scrollController,
    this.scrollBehavior,
    this.floating = false,
    this.pinned = true,
    this.snap = false,
    this.stretch = false,
    this.bottom,
    this.leading,
    this.actions,
    this.collapsedBarHeight = 60.0,
    this.backdropWidget,
    this.backgroundColor,
  });

  final ScrollController? scrollController;

  final Widget expandedBar;
  final Widget collapsedBar;
  final Widget body;
  final double? expandedBarHeight;
  final double collapsedBarHeight;
  final bool floating;
  final bool pinned;
  final bool snap;
  final bool stretch;
  final List<Widget>? actions;
  final Widget? leading;
  final PreferredSizeWidget? bottom;
  final Widget? backdropWidget;
  final Color? backgroundColor;
  final ScrollBehavior? scrollBehavior;
  final ValueNotifier<bool> isCollapsed;

  @override
  Widget build(BuildContext context) {
    final defaultExpandedBarHeight =
        expandedBarHeight ?? MediaQuery.of(context).size.height / 2;

    final controller = scrollController ?? useScrollController();
    final snappingScrollNotificationHandler =
        SnappingScrollNotificationHandler.withHapticFeedback(
      expandedBarHeight: defaultExpandedBarHeight,
      collapsedBarHeight: collapsedBarHeight,
          bottomBarHeight: bottom?.preferredSize.height ?? 0.0,
    );

    return NotificationListener<ScrollNotification>(
      onNotification: (notification) =>
          snappingScrollNotificationHandler.handleScrollNotification(
        notification: notification,
        isCollapsed: isCollapsed,
        scrollController: controller,
      ),
      child: SnappingAppBarBody(
        scrollController: controller,
        backdropWidget: backdropWidget,
        collapsedBar: collapsedBar,
        bottom: bottom,
        expandedBar: expandedBar,
        leading: leading,
        actions: actions,
        pinned: pinned,
        floating: floating,
        snap: snap,
        stretch: stretch,
        body: body,
        scrollBehavior: scrollBehavior,
        collapsedBarHeight: collapsedBarHeight,
        expandedBarHeight: defaultExpandedBarHeight,
        backgroundColor: backgroundColor,
      ),
    );
  }
}
