import 'package:flutter/material.dart';

class FlashCard extends StatefulWidget {
  final String discount;
  final String subTitle;
  const FlashCard({super.key, required this.discount, required this.subTitle});

  @override
  State<FlashCard> createState() => _FlashCardState();
}

class _FlashCardState extends State<FlashCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 160,
        width: 320,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Color(0xFF1A1A2E),
        ),
        clipBehavior: Clip.hardEdge,
        child: Stack(
          children: [
            // Decorative circles background
            Positioned(
              right: -30,
              top: -30,
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFC5E41A).withOpacity(0.12),
                ),
              ),
            ),
            Positioned(
              right: 30,
              bottom: -40,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFC5E41A).withOpacity(0.08),
                ),
              ),
            ),
            Positioned(
              left: -20,
              bottom: -20,
              child: Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFC5E41A).withOpacity(0.06),
                ),
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Top row: SALE badge + discount badge
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Color(0xFFC5E41A),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          "🔥 SALE",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Color(0xFFC5E41A),
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          "Limited Time",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFFC5E41A),
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Middle: headline
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.discount,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          height: 1.1,
                        ),
                      ),
                      Text(
                        widget.subTitle,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Colors.white60,
                        ),
                      ),
                    ],
                  ),
                  // Bottom: CTA button
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                    decoration: BoxDecoration(
                      color: Color(0xFFC5E41A),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      "Shop Now →",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
