import 'package:flutter/material.dart';

class FlashCard extends StatefulWidget {
  final String title;
  final String subTitle;
  const FlashCard({super.key, required this.title, required this.subTitle});

  @override
  State<FlashCard> createState() => _FlashCardState();
}

class _FlashCardState extends State<FlashCard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
