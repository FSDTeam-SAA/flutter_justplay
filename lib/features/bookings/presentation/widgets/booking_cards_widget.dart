import 'package:flutter/material.dart';



// Reusable Booking Card Widget
class BookingCard extends StatelessWidget {
  final String date;
  final String time;
  final String pitch;
  final VoidCallback? onTap;
  final bool isSelected;

  const BookingCard({
    Key? key,
    required this.date,
    required this.time,
    required this.pitch,
    this.onTap,
    this.isSelected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: SizedBox(
        height: 92,
        width: double.infinity,
        child: Material(                  // ← Keep Material for ink splash
          borderRadius: BorderRadius.circular(91.27),
          clipBehavior: Clip.hardEdge,   // Important for rounded corners
          color: Colors.transparent,     // ← Make it transparent
          child: InkWell(
            borderRadius: BorderRadius.circular(91.27),
            onTap: onTap,
            child: Container(              // ← Move the color here
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFFE0E400)   // Dark yellow when selected
                    : const Color(0xFFEAEC91),  // Light yellow default
                borderRadius: BorderRadius.circular(91.27),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '$date | $time',
                      style: TextStyle(
                        fontSize: 16.5,
                        fontWeight: FontWeight.w700,
                        color: isSelected ? Color(0xFF000000) : Color(0xFF000000),
                      ),
                    ),
                    Text(
                      pitch,
                      style: TextStyle(
                        fontSize: 16.5,
                        fontWeight: FontWeight.w700,
                        color: isSelected ? Color(0xFF000000) : Color(0xFF000000),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}