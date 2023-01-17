
import 'package:custom_sliver_app_bar/models/movie_details.dart';
import 'package:flutter/material.dart';

class CollapsedAppBarContent extends StatelessWidget {
  const CollapsedAppBarContent({
    Key? key,
    required this.movieDetails,
  }) : super(key: key);

  final MovieDetails movieDetails;

  @override
  Widget build(BuildContext context) {
    return Row(
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
            movieDetails.productionCompanies?.first.logoPath ?? '',
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(
          width: 10,
        )
      ],
    );
  }
}
