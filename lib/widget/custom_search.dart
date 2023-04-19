import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../model/patient.dart';

class CustomSearch extends StatelessWidget {
  final String hintText;
  final List<Patient> items;
  final Function(String) onFiltered;

  const CustomSearch({
    Key? key,
    required this.hintText,
    required this.items,
    required this.onFiltered,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        color: AppColors.backgroundColor,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: const [
          BoxShadow(
            color: AppColors.textColor,
            blurRadius: 1.0,
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.search),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: hintText,
                  border: InputBorder.none,
                ),
                onChanged: onFiltered,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
