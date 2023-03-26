import 'package:custom_sliver_app_bar/blurred_backdrop_image.dart';
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
  static const collapsedBarHeight = 60.0;
  static const expandedBarHeight = 400.0;

  @override
  Widget build(BuildContext context) {
    final isCollapsed = useState(false);

    /// Triggers scrolling only when necessary

    return SnappingCollapsingAppBar(
      isCollapsed: isCollapsed,
      backgroundColor: isCollapsed.value ? Colors.black : Colors.transparent,
      backdropWidget: BlurredBackdropImage(movieDetails: movieDetails),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: const Icon(
                Icons.home,
                color: Colors.white,
              ),
              onPressed: () {
                // Add your home button logic here
              },
            ),
            IconButton(
              icon: const Icon(
                Icons.favorite,
                color: Colors.white,
              ),
              onPressed: () {
                // Add your favorites button logic here
              },
            ),
            IconButton(
              icon: const Icon(
                Icons.person,
                color: Colors.white,
              ),
              onPressed: () {
                // Add your profile button logic here
              },
            ),
          ],
        ),
      ),
      expandedBarHeight: expandedBarHeight,
      expandedBar: ExpandedAppBarContent(
        movieDetails: movieDetails,
      ),
      collapsedBar: AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: isCollapsed.value ? 1 : 0,
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
        borderRadius: getBorderRadius(isCollapsed),
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
