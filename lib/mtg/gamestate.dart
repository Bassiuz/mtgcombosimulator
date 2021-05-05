class GameState {
  List<String> deck;
  List<String> hand;
  List<String> battlefield;
  List<String> graveyard;
  int turn = 1;
  int startingHand = 7;
  int storm = 0;

  GameState(
      {required this.deck,
      required this.hand,
      required this.battlefield,
      required this.graveyard});
}
