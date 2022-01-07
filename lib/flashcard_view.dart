import 'package:flip_card/flip_card.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class FlashcardView extends StatelessWidget {
  // UI Constants
  final double elevation = 4;
  final double width = 250;
  final double height = 250;

  // Attr
  final String front;
  final String back;

  // State
  bool flipped = false;
  GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();

  FlashcardView({Key? key, required this.front, required this.back}) : super
      (key: key);

  @override
  Widget build(BuildContext context) {
    FlipCard flipcard = FlipCard(
      key: cardKey,
      fill: Fill.fillBack, // Fill the back side of the card to make in the same size as the front.
      direction: FlipDirection.HORIZONTAL, // default
      front: Card(
        elevation: elevation,
        child: Center(
            child: Text(front)
        ),
      ),
      back: Card(
        elevation: elevation,
        child: Center(
            child: Text(back)
        ),
      ),
      onFlip: (){flipped = !flipped;},
    );


    return SizedBox(
      width: width,
      height: height,
      child: flipcard
    );
  }

  void resetFlip() {
    if (kDebugMode) {
      print("Card has been flipped: $flipped");
    }
    if (flipped) {
      cardKey.currentState?.toggleCard();
    }
  }

}
