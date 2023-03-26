import 'package:flutter/material.dart';

class SnappingAppBarBody extends StatelessWidget {
  const SnappingAppBarBody({
    Key? key,
    required this.scrollController,
    required this.expandedBar,
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
    this.expandedBarHeight,
    this.backgroundColor,
    this.actions,
    this.bottom,
  }) : super(key: key);

  final ScrollController scrollController;

  final Widget expandedBar;
  final List<Widget>? actions;
  final Widget collapsedBar;
  final Widget body;
  final double? expandedBarHeight;
  final double collapsedBarHeight;
  final PreferredSizeWidget? bottom;
  final Widget? leading;
  final bool pinned;
  final bool floating;
  final bool snap;
  final bool stretch;
  final Widget? backdropWidget;
  final Color? backgroundColor;
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
              expandedHeight: expandedBarHeight,
              collapsedHeight: collapsedBarHeight,
              centerTitle: false,
              pinned: pinned,
              elevation: 0,
              title: collapsedBar,
              backgroundColor: backgroundColor,
              leading: leading ??
                  const BackButton(
                    color: Colors.white,
                  ),
              flexibleSpace: FlexibleSpaceBar(
                background: expandedBar,
              ),
            ),
            SliverToBoxAdapter(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height),
                child: body,
              ),
            )
          ],
        ),
      ],
    );
  }
}
