import 'package:flutter/material.dart';

class PatientRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const PatientRow({
    Key? key,
    required this.icon,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Row(
        children: [
          Icon(
            icon,
          ),
          const SizedBox(width: 10),
          Text(
            text,
            textDirection:
            icon == Icons.phone ? TextDirection.ltr : TextDirection.rtl,
          ),
        ],
      ),
    );
  }
}