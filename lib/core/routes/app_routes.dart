import 'package:flutter/material.dart';
import 'route_generator.dart';

class AppRouter {
  final RouteGenerator routeGenerator = RouteGenerator();

  Route<dynamic> onGenerateRoute(RouteSettings settings) {
    return RouteGenerator.generateRoute(settings);
  }

  
}