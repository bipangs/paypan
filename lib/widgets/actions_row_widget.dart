import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

class ActionsRowWidget extends StatelessWidget {
  const ActionsRowWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Pay
        Column(
          children: [
            OutlinedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/payment');
              },
              style: OutlinedButton.styleFrom(
                shape: const CircleBorder(),
                side: const BorderSide(color: Colors.transparent),
                padding: const EdgeInsets.all(16),
                elevation: 5,
                backgroundColor: Colors.white,
                shadowColor: Colors.grey.withOpacity(0.2),
              ),
              child: const Icon(Iconsax.money_send),
            ),
            Text(
              "Pay",
              style: GoogleFonts.poppins(
                  fontSize: 14, fontWeight: FontWeight.w400),
            ),
          ],
        ),
        // Top Up
        Column(
          children: [
            OutlinedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/top_up');
              },
              style: OutlinedButton.styleFrom(
                shape: const CircleBorder(),
                side: const BorderSide(color: Colors.transparent),
                padding: const EdgeInsets.all(16),
                elevation: 5,
                backgroundColor: Colors.white,
                shadowColor: Colors.grey.withOpacity(0.2),
              ),
              child: const Icon(Iconsax.add),
            ),
            Text(
              "Top Up",
              style: GoogleFonts.poppins(
                  fontSize: 14, fontWeight: FontWeight.w400),
            ),
          ],
        ),
      ],
    );
  }
}
