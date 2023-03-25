
import 'package:custom_sliver_app_bar/blurred_backdrop_image.dart';
import 'package:custom_sliver_app_bar/collapsed_app_bar_content.dart';
import 'package:custom_sliver_app_bar/snapping_scroll_notification_handler.dart';
import 'package:custom_sliver_app_bar/page_body_widget.dart';
import 'package:custom_sliver_app_bar/models/movie_details.dart';
import 'package:custom_sliver_app_bar/widgets/expanded_app_bar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class MovieProfilePage extends HookWidget {
  const MovieProfilePage({super.key, required this.movieDetails});

  final MovieDetails movieDetails;
  static const collapsedBarHeight = 60.0;
  static const expandedBarHeight = 400.0;

  @override
  Widget build(BuildContext context) {
    final scrollController = useScrollController();
    final isCollapsed = useState(false);
    final didAddFeedback = useState(false);
    final scrollPercentage = useState(1.0);

    /// Triggers scrolling only when necessary
    final ValueNotifier<bool> shouldScrollNotifier = useState(false);
    final SnappingScrollNotificationHandler scrollNotificationHandler =
        SnappingScrollNotificationHandler(
            expandedBarHeight: expandedBarHeight,
            collapsedBarHeight: collapsedBarHeight);

    /// The offset which we will scroll to
    final ValueNotifier<double> scrollToOffsetNotifier = useState(0.0);

    return NotificationListener<ScrollNotification>(
      onNotification: (notification) =>
          scrollNotificationHandler.onScrollOffsetChanged(
              notification: notification,
              isCollapsed: isCollapsed,
              scrollController: scrollController,
              scrollPercentage: scrollPercentage,
              didAddFeedback: didAddFeedback,
              shouldScrollNotifier: shouldScrollNotifier,
              scrollToOffsetNotifier: scrollToOffsetNotifier),
      child: Stack(
        children: [
          BlurredBackdropImage(movieDetails: movieDetails),
          CustomScrollView(
            controller: scrollController,
            slivers: [
              SliverAppBar(
                expandedHeight: expandedBarHeight,
                collapsedHeight: collapsedBarHeight,
                centerTitle: false,
                pinned: true,
                title: AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: isCollapsed.value ? 1 : 0,
                  child: CollapsedAppBarContent(movieDetails: movieDetails),
                ),
                elevation: 0,
                backgroundColor:
                    isCollapsed.value ? Colors.black : Colors.transparent,
                leading: const BackButton(
                  color: Colors.white,
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: ExpandedAppBarContent(
                    movieDetails: movieDetails,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                      minHeight: MediaQuery.of(context).size.height),
                  child: Material(
                    elevation: 7,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(
                        15,
                      ),
                      topRight: Radius.circular(
                        15,
                      ),
                    ),
                    child: PageBodyWidget(movieDetails: movieDetails),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
