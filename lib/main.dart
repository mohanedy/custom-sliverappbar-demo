import 'dart:ui' as ui;

import 'package:custom_sliver_app_bar/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';

void main() async {

  runApp(const App());

  await FlutterDisplayMode.setHighRefreshRate();

}
