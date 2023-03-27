import 'package:custom_sliver_app_bar/blurred_backdrop_image.dart';
import 'package:custom_sliver_app_bar/bottom_bar_widget.dart';
import 'package:custom_sliver_app_bar/models/movie_details.dart';
import 'package:custom_sliver_app_bar/page_body_widget.dart';
import 'package:custom_sliver_app_bar/snapping-collapsing-sliver-appbar/collapsed_app_bar_content.dart';
import 'package:custom_sliver_app_bar/snapping-collapsing-sliver-appbar/snapping_collapsing_app_bar.dart';
import 'package:custom_sliver_app_bar/widgets/expanded_app_bar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class MovieProfilePage extends HookWidget {
  const MovieProfilePage({super.key, required this.movieDetails});

  final MovieDetails movieDetails;
  static const expandedBarHeight = 400.0;

  @override
  Widget build(BuildContext context) {
    final isCollapsedValueNotifier = useState(false);
    final scrollPercentValueNotifier = useState(0.0);

    /// Triggers scrolling only when necessary

    return SnappingCollapsingAppBar.withAnimatedExpnandedContent(
      onCollapseStateChanged: (isCollapsed, scrollingOffset, maxExtent) {
        isCollapsedValueNotifier.value = isCollapsed;
        scrollPercentValueNotifier.value = 1 - scrollingOffset / maxExtent;
      },
      backgroundColor:
          isCollapsedValueNotifier.value ? Colors.black : Colors.transparent,
      backdropWidget: BlurredBackdropImage(movieDetails: movieDetails),
      bottom: const BottomBarWidget(),
      expandedContentHeight: expandedBarHeight,
      expandedContent: ExpandedAppBarContent(
        movieDetails: movieDetails,
      ),
      collapsedContent: AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: isCollapsedValueNotifier.value ? 1 : 0,
        child: CollapsedAppBarContent(
          title: Text(
            movieDetails.title ?? '',
            style: const TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          trailing: SizedBox(
            height: 40,
            child: Image.network(
              movieDetails.productionCompanies?.first.logoPath ?? '',
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
      body: Material(
        elevation: 7,
        borderRadius: getBorderRadius(isCollapsedValueNotifier),
        child: PageBodyWidget(movieDetails: movieDetails),
      ),
    );
  }

  BorderRadius getBorderRadius(ValueNotifier<bool> isCollapsed) {
    return !isCollapsed.value
        ? const BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(
              15,
            ),
          )
        : BorderRadius.zero;
  }
}
