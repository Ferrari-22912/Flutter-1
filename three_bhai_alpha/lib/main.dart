import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:three_bhai/app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const ThreeBhaiApp());
}
