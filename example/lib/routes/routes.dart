import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:formio_flutter_example/menu.dart';
import 'package:formio_flutter_example/screens/demonstration.dart';

Route generateRoutes(RouteSettings settings) {
  switch (settings.name) {
    case 'menu':
      return MaterialPageRoute(builder: (context) => MenuPage());
      break;
    case 'demonstration':
      return MaterialPageRoute(
          builder: (context) =>
              DemonstrationPage(argument: settings.arguments));
      break;
    default:
      return MaterialPageRoute(builder: (context) => MenuPage());
  }
}
