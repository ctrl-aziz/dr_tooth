import 'package:flutter/material.dart';

import '../view/dental_patients_view.dart';

class AppRoute {

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const DentalPatientsView());
      default:
        return MaterialPageRoute(builder: (_) => const DentalPatientsView());
    }
  }
}
