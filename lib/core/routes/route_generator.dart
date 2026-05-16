import 'package:flutter/material.dart';
import '../../screens/heritage/heritage_list_screen.dart';
import '../../screens/heritage/heritage_detail_screen.dart';
import '../../screens/heritage/add_heritage_screen.dart';
import '../../screens/heritage/edit_heritage_screen.dart';
import 'route_names.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.home:
        return MaterialPageRoute(builder: (_) => const HeritageListScreen());
      case RouteNames.detail:
        final itemId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => HeritageDetailScreen(itemId: itemId),
        );
      case RouteNames.add:
        return MaterialPageRoute(builder: (_) => const AddHeritageScreen());
      case RouteNames.edit:
      final itemId = settings.arguments as String;
      
      return MaterialPageRoute(
        builder: (_) => EditHeritageScreen(itemId: itemId),
        );
        
      default:
        return MaterialPageRoute(builder: (_) => const HeritageListScreen());
    }
  }
}