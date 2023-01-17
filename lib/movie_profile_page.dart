import 'dart:ui';

import 'package:custom_sliver_app_bar/blurred_backdrop_image.dart';
import 'package:custom_sliver_app_bar/page_body_widget.dart';
import 'package:custom_sliver_app_bar/models/MovieDetails.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class MovieProfilePage extends HookWidget {
  const MovieProfilePage({super.key, required this.movieDetails});

  final MovieDetails movieDetails;

  @override
  Widget build(BuildContext context) {
    const collapsedBarHeight = 60.0;
    const expandedBarHeight = 400.0;

    final scrollController = useScrollController();
    final isCollapsed = useState(false);
    final didAddFeedback = useState(false);

    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        isCollapsed.value = scrollController.hasClients &&
            scrollController.offset > (expandedBarHeight - collapsedBarHeight);
        if (isCollapsed.value && !didAddFeedback.value) {
          HapticFeedback.mediumImpact();
          didAddFeedback.value = true;
        } else if (!isCollapsed.value) {
          didAddFeedback.value = false;
        }
        return false;
      },
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
                  child: Row(
                    children: [
                      Text(
                        movieDetails.title ?? '',
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      SizedBox(
                        height: 40,
                        child: Image.network(
                          movieDetails.productionCompanies?.first.logoPath ??
                              '',
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      )
                    ],
                  ),
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
