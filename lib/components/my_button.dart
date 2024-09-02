import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final Function()? onTap;
  final String text;
  final String? imagePath;
  final Color background;
  final Color textColor;

  const MyButton(
      {super.key,
      required this.onTap,
      required this.text,
      this.imagePath,
      required this.background,
      required this.textColor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(25),
        margin: const EdgeInsets.symmetric(horizontal: 25),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (imagePath != null) ...[
                Image.asset(
                  imagePath!,
                  height: 24,
                ),
                const SizedBox(width: 10),
              ],
              Text(text,
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
