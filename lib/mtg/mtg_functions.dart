import 'dart:math';

List<String> shuffle(List<String> array) {
  array.shuffle();
  return array;
}

void drawACard(List<String> deck, List<String> hand) {
  if (deck.length != 0) {
    moveCardFromTo(deck[0], deck, hand);
  } else {
    print("deckout!!!");
  }
}

int countCardInList(List<String> list, String card) {
  return list.where((c) => c == card).toList().length;
}

void moveCardFromTo(String card, List<String> from, List<String> to) {
  from.remove(card);
  to.add(card);
}

void putCardFromHandOnBottomOfDeck(
    String card, List<String> hand, List<String> deck) {
  moveCardFromTo(card, hand, deck);
}

String getRandomCardFrom(list) {
  return list[new Random().nextInt(list.length)];
}
