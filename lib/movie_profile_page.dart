import 'dart:ui';

import 'package:custom_sliver_app_bar/widgets/expanded_app_bar_content.dart';
import 'package:custom_sliver_app_bar/models/MovieDetails.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class MovieProfilePage extends HookWidget {
  const MovieProfilePage({super.key, required this.movieDetails});

  final MovieDetails movieDetails;

  @override
  Widget build(BuildContext context) {
    final scrollController = useScrollController();
    final isCollapsed = useState(false);
    final didAddFeedback = useState(false);

    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        isCollapsed.value = scrollController.hasClients &&
            scrollController.offset > (400 - kToolbarHeight);
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
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                  movieDetails.backdropPath ?? '',
                ),
                fit: BoxFit.cover,
              ),
            ),
            height: MediaQuery.of(context).size.height / 1.5,
            child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 7.0, sigmaY: 7.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.0),
                  ),
                )),
          ),
          CustomScrollView(
            controller: scrollController,
            slivers: [
              SliverAppBar(
                expandedHeight: 400,
                toolbarHeight: 60,
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
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {},
                                  style: ButtonStyle(
                                    padding: MaterialStateProperty.all(
                                      const EdgeInsets.all(0.0),
                                    ),
                                    elevation: MaterialStateProperty.all(0),
                                    shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                    ),
                                  ),
                                  child: Ink(
                                    decoration: const BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Color(0xFF0DC0F7),
                                          Color(0xFF3087DC),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(5.0),
                                      ),
                                    ),
                                    child: Container(
                                      constraints: const BoxConstraints(
                                        minWidth: 88.0,
                                        minHeight: 45.0,
                                      ),
                                      alignment: Alignment.center,
                                      child: const Text(
                                        'Watch now',
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              SizedBox(
                                height: 45.0,
                                child: OutlinedButton(
                                  child: const Icon(
                                    Icons.favorite_outline,
                                    color: Colors.black,
                                  ),
                                  onPressed: () {},
                                ),
                              ),
                            ],
                          ),
                          const Divider(),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            'Introduction',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            movieDetails.overview ?? '',
                            textAlign: TextAlign.start,
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          )
                        ],
                      ),
                    ),
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
