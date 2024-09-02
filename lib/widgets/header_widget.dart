import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HeaderWidget extends StatelessWidget {
  final String name;

  const HeaderWidget({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Hello!",
                style: GoogleFonts.poppins(
                    fontSize: 14, fontWeight: FontWeight.normal)),
            Text(name,
                style: GoogleFonts.poppins(
                    fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 2),
          ],
        ),
        const CircleAvatar(
          radius: 26,
          backgroundImage: NetworkImage(''),
          backgroundColor: Colors.black,
        ),
      ],
    );
  }
}
