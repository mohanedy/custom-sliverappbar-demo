import 'package:custom_sliver_app_bar/snapping-collapsing-sliver-appbar/expanded_content_type.dart';
import 'package:custom_sliver_app_bar/snapping-collapsing-sliver-appbar/snapping_app_bar_body.dart';
import 'package:custom_sliver_app_bar/snapping-collapsing-sliver-appbar/snapping_scroll_notification_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

typedef CollapsingStateCallback = void Function(
  bool isCollapsed,
  double scrollingOffset,
  double maxExtent,
);

class SnappingCollapsingAppBar extends HookWidget {
  const SnappingCollapsingAppBar({
    super.key,
    required this.expandedContent,
    required this.collapsedContent,
    required this.body,
    this.onCollapseStateChanged,
    this.expandedContentHeight,
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
    this.expandedContentType = ExpandedContentType.normal,
  });

  factory SnappingCollapsingAppBar.withAnimatedExpnandedContent(
    {
      Key? key,
      required Widget expandedContent,
      required Widget collapsedContent,
      required Widget body,
      CollapsingStateCallback? onCollapseStateChanged,
      double? expandedContentHeight,
      ScrollController? scrollController,
      ScrollBehavior? scrollBehavior,
      bool floating = false,
      bool pinned = true,
      bool snap = false,
      bool stretch = false,
      PreferredSizeWidget? bottom,
      Widget? leading,
      List<Widget>? actions,
      double collapsedBarHeight = 60.0,
      Widget? backdropWidget,
      Color? backgroundColor,
    }) => SnappingCollapsingAppBar(
      key: key,
      expandedContent: expandedContent,
      collapsedContent: collapsedContent,
      body: body,
      onCollapseStateChanged: onCollapseStateChanged,
      expandedContentHeight: expandedContentHeight,
      scrollController: scrollController,
      scrollBehavior: scrollBehavior,
      floating: floating,
      pinned: pinned,
      snap: snap,
      stretch: stretch,
      bottom: bottom,
      leading: leading,
      actions: actions,
      collapsedBarHeight: collapsedBarHeight,
      backdropWidget: backdropWidget,
      backgroundColor: backgroundColor,
      expandedContentType: ExpandedContentType.animatedOpacity,
    );

  final ScrollController? scrollController;

  /// The content that is shown when the appBar is expanded
  ///
  /// (e.g. a movie poster and it's ratings)
  final Widget expandedContent;

  /// The collapsed appbar or content that is shown when state is collapsed
  ///
  /// (e.g. the title of the movie)
  final Widget collapsedContent;

  /// The content that is shown below the appbar
  final Widget body;

  /// The height of the [ExpandedContent]
  final double? expandedContentHeight;

  /// The height of the [collapsedContent]
  final double collapsedBarHeight;
  final bool floating;
  final bool pinned;
  final bool snap;
  final bool stretch;
  final List<Widget>? actions;
  final Widget? leading;
  final PreferredSizeWidget? bottom;

  /// The widget that is shown behind the [ExpandedContent]
  ///
  /// (e.g. a blurred image of the movie poster)
  final Widget? backdropWidget;
  final Color? backgroundColor;
  final ScrollBehavior? scrollBehavior;

  /// Callback that is called when the [ExpandedContent] is collapsed or expanded
  ///
  final CollapsingStateCallback? onCollapseStateChanged;

  /// If the [ExpandedContent] should be animated in scrolling state or not
  ///
  final ExpandedContentType expandedContentType;

  @override
  Widget build(BuildContext context) {
    final isCollapsedValueNotifier = useState(false);
    final defaultExpandedContentHeight =
        expandedContentHeight ?? MediaQuery.of(context).size.height / 2;

    final controller = scrollController ?? useScrollController();
    final snappingScrollNotificationHandler =
        SnappingScrollNotificationHandler.withHapticFeedback(
      expandedBarHeight: defaultExpandedContentHeight,
      collapsedBarHeight: collapsedBarHeight,
      bottomBarHeight: bottom?.preferredSize.height ?? 0.0,
    );

    return NotificationListener<ScrollNotification>(
      onNotification: (notification) =>
          snappingScrollNotificationHandler.handleScrollNotification(
            notification: notification,
        isCollapsedValueNotifier: isCollapsedValueNotifier,
        onCollapseStateChanged: onCollapseStateChanged,
        scrollController: controller,
      ),
      child: SnappingAppBarBody(
        scrollController: controller,
        backdropWidget: backdropWidget,
        collapsedBar: collapsedContent,
        bottom: bottom,
        expandedContent: expandedContentType.getExpandedContentWidget(
          expandedContent,
          controller,
          expandedContentHeight,
        ),
        leading: leading,
        actions: actions,
        pinned: pinned,
        floating: floating,
        snap: snap,
        stretch: stretch,
        body: body,
        scrollBehavior: scrollBehavior,
        collapsedBarHeight: collapsedBarHeight,
        expandedContentHeight: defaultExpandedContentHeight,
        backgroundColor: backgroundColor,
      ),
    );
  }
}
