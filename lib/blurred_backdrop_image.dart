import 'dart:ui';

import 'package:flutter/material.dart';

import 'models/movie_details.dart';

class BlurredBackdropImage extends StatelessWidget {
  const BlurredBackdropImage({
    Key? key,
    required this.movieDetails,
  }) : super(key: key);

  final MovieDetails movieDetails;

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}
