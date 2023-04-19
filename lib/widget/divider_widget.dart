import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class DividerWidget extends StatelessWidget {
  final String title;
  const DividerWidget({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 50,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.zero,
        color: AppColors.primaryColor.withOpacity(.2),
      ),
      child: Text(title),
    );
  }
}
