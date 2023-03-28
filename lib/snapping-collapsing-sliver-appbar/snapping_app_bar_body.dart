import 'package:flutter/material.dart';

class SnappingAppBarBody extends StatelessWidget {
  const SnappingAppBarBody({
    super.key,
    required this.scrollController,
    required this.expandedContent,
    required this.collapsedBar,
    required this.collapsedBarHeight,
    required this.body,
    this.scrollBehavior,
    this.leading,
    this.floating = false,
    this.pinned = false,
    this.snap = false,
    this.stretch = false,
    this.backdropWidget,
    this.expandedContentHeight,
    this.collapsedBackgroundColor,
    this.expandedBackgroundColor,
    this.actions,
    this.bottom,
    this.isCollapsed = false,
  });

  final ScrollController scrollController;

  final Widget expandedContent;
  final List<Widget>? actions;
  final Widget collapsedBar;
  final Widget body;
  final double? expandedContentHeight;
  final double collapsedBarHeight;
  final PreferredSizeWidget? bottom;
  final Widget? leading;
  final bool pinned;
  final bool floating;
  final bool snap;
  final bool stretch;
  final bool isCollapsed;
  final Widget? backdropWidget;
  final Color? collapsedBackgroundColor;
  final Color? expandedBackgroundColor;
  final ScrollBehavior? scrollBehavior;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (backdropWidget != null) backdropWidget!,
        CustomScrollView(
          controller: scrollController,
          scrollBehavior: scrollBehavior,
          slivers: [
            SliverAppBar(
              actions: actions,
              snap: snap,
              floating: floating,
              stretch: stretch,
              bottom: bottom,
              expandedHeight: expandedContentHeight,
              collapsedHeight: collapsedBarHeight,
              centerTitle: false,
              pinned: pinned,
              elevation: 0,
              title: collapsedBar,
              automaticallyImplyLeading: false,
              backgroundColor: isCollapsed? collapsedBackgroundColor : expandedBackgroundColor,
              leading: leading,
              flexibleSpace: FlexibleSpaceBar(
                background: expandedContent,
              ),
            ),
            SliverToBoxAdapter(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height,
                ),
                child: body,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
