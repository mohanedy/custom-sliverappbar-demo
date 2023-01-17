import 'package:custom_sliver_app_bar/models/fake_data.dart';
import 'package:custom_sliver_app_bar/movie_profile_page.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Custom SliverAppBar Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: MovieProfilePage(
        movieDetails: FakeData.theBatmanMovie,
      ),
    );
  }
}
