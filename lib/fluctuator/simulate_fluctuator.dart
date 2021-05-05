import 'dart:math';

import 'package:mtgcombosimulator/mtg/gamestate.dart';
import 'package:mtgcombosimulator/mtg/mtg_functions.dart';

class FluctuatorSimulator {
  int tappedCyclingLands = 20;
  int sideboardCyclers = 2;
  int sideboardCards = 0;
  int killconditions = 1;
  int petals = 1;
  int rituals = 1;
  int reapingTheGraves = 0;
  int simulatingGames = 5;
  bool gameLogging = true;

  FluctuatorSimulator(
      {required this.tappedCyclingLands,
      required this.sideboardCyclers,
      required this.sideboardCards,
      required this.killconditions,
      required this.petals,
      required this.rituals,
      required this.reapingTheGraves,
      required this.simulatingGames,
      required this.gameLogging});

  List<String> returnCoreDecklist() {
    return returnDecklist(tappedCyclingLands, sideboardCyclers, sideboardCards,
        killconditions, petals, rituals, reapingTheGraves);
  }

  double simulateCoreDecklist() {
    return simulateGames(returnCoreDecklist);
  }

  GameState simulateTestGame() {
    GameState gameState =
        GameState(deck: [], hand: [], battlefield: [], graveyard: []);
    gameState.deck = returnDecklist(20, 0, 0, 1, 2, 2, 1);

    moveCardFromTo("Untapped Cycling Land", gameState.deck, gameState.hand);
    moveCardFromTo("Dromar's Cavern", gameState.deck, gameState.hand);
    moveCardFromTo("Fluctuator", gameState.deck, gameState.hand);
    moveCardFromTo("Cycling Card", gameState.deck, gameState.hand);
    moveCardFromTo("Cycling Card", gameState.deck, gameState.hand);
    moveCardFromTo("Cycling Card", gameState.deck, gameState.hand);
    moveCardFromTo("Cycling Card", gameState.deck, gameState.hand);

    if (isHandPlayable(gameState.hand)) {
      return makePlay(gameState: gameState);
    }

    return gameState;
  }

  double simulateGames(returnCoreDecklist) {
    var turn2 = 0;
    var turn3 = 0;
    var turn4 = 0;
    var turn5 = 0;
    var turn6 = 0;
    var turn7 = 0;
    var turn8 = 0;
    var turn9 = 0;
    var turn10 = 0;

    var brick = 0;
    var totalScore = 0;
    var totalHandsize = 0;
    var onThePlay = true;

    for (var amountOfGames = 0;
        amountOfGames < simulatingGames;
        amountOfGames++) {
      onThePlay = !onThePlay;
      GameState gameState = simulateGame(
          onThePlay: onThePlay, returnDecklistFunction: returnCoreDecklist);
      var mulligan = gameState.startingHand;
      var turn = gameState.turn;
      turn == 2 ? turn2 = turn2 + 1 : '';
      turn == 3 ? turn3 = turn3 + 1 : '';
      turn == 4 ? turn4 = turn4 + 1 : '';
      turn == 5 ? turn5 = turn5 + 1 : '';
      turn == 6 ? turn6 = turn6 + 1 : '';
      turn == 7 ? turn7 = turn7 + 1 : '';
      turn == 8 ? turn8 = turn8 + 1 : '';
      turn == 9 ? turn9 = turn9 + 1 : '';
      turn == 10 ? turn10 = turn10 + 1 : '';
      turn == 99 ? brick = brick + 1 : '';

      turn != 99 ? totalScore = totalScore + turn : '';
    }
    double averageComboTurn = totalScore / (simulatingGames - brick);

    /*var after = Date.now();
    var averageHandsize = totalHandsize / (simulatingGames);
    print("Results after simulating " + simulatingGames + " games");
    print("*****************************")
    print("Average Combo Turn: " + averageComboTurn);
    print("Bricked Game Percentage: " + brick / simulatingGames * 100);
    print("Average Starting Hand Size " + averageHandsize);
    print("Turn 2: " + turn2 + " Turn 3: " + turn3 + " Turn 4: " + turn4 + " Turn 5: " + turn5 + " Turn 6: " + turn6 + " Turn 7: " + turn7 + " Turn 8: " + turn8 + " Turn 9: " + turn9 + " Turn 10: " + turn10+ " Brick: " + brick)
    print("Finished in " + (after - before) + " milliseconds");*/

    return averageComboTurn;
  }

  GameState simulateGame({onThePlay = false, returnDecklistFunction}) {
    return mulligan(7, onThePlay, returnDecklistFunction);
  }

  GameState makePlay(
      {required GameState gameState,
      playedALand = false,
      extraManaThisTurn = 0}) {
    var playMade = false;

    if (countCardInList(gameState.graveyard, "Cycling Card") > 21 &&
        (((gameState.hand.contains("Lotus Petal") || extraManaThisTurn == 1) &&
                gameState.hand.contains("Songs of the Damned")) ||
            extraManaThisTurn > 2) &&
        gameState.hand.contains("Haunting Misery")) {
      // we win, give turn we won on.
      return gameState;
    }

    if (countCardInList(gameState.battlefield, "Fluctuator") > 0) {
      // cycle a card
      if (gameState.hand.contains("Cycling Card")) {
        if (!playMade) {
          if (gameLogging) {
            print("cycle a cycling card");
          }
          moveCardFromTo("Cycling Card", gameState.hand, gameState.graveyard);
          drawACard(gameState.deck, gameState.hand);
          playMade = true;
        }
      }

      if (gameState.hand.contains("Cycling Card - Sideboard Card")) {
        if (!playMade) {
          if (gameLogging) {
            print("cycle a cycling card");
          }
          moveCardFromTo("Cycling Card - Sideboard Card", gameState.hand,
              gameState.graveyard);
          drawACard(gameState.deck, gameState.hand);
          playMade = true;
        }
      }
      // cycle a card
      if (gameState.hand.contains("Cycling Land")) {
        if (!playMade) {
          if (gameLogging) {
            print("cycle a cycling land");
          }
          moveCardFromTo("Cycling Land", gameState.hand, gameState.graveyard);
          drawACard(gameState.deck, gameState.hand);
          playMade = true;
        }
      }
      // cycle a card
      if (gameState.hand.contains("Untapped Cycling Land")) {
        if (!playMade) {
          if (gameLogging) {
            print("cycle a untapped cycling land");
          }
          moveCardFromTo(
              "Untapped Cycling Land", gameState.hand, gameState.graveyard);
          drawACard(gameState.deck, gameState.hand);
          playMade = true;
        }
      }
      if (!playMade) {
        if (gameState.hand.contains("Reaping the Graves")) {
          if (gameLogging) {
            print("Reaping the storm in hand and nothing to cycle");
          }

          if ((gameState.hand.contains("Lotus Petal") ||
                  extraManaThisTurn > 0) &&
              gameState.hand.contains("Songs of the Damned")) {
            // play all your lotus petals
            while (gameState.hand.contains("Lotus Petal")) {
              moveCardFromTo(
                  "Lotus Petal", gameState.hand, gameState.graveyard);
              gameState.storm = gameState.storm + 1;
              extraManaThisTurn = extraManaThisTurn + 1;
            }

            if (gameLogging) {
              print("Songs of the Damned for x cards: " +
                  countCardInList(gameState.graveyard, "Cycling Card")
                      .toString());
            }

            extraManaThisTurn = extraManaThisTurn - 1;
            gameState.storm = gameState.storm + 1;
            moveCardFromTo(
                "Songs of the Damned", gameState.hand, gameState.graveyard);
            extraManaThisTurn = extraManaThisTurn +
                countCardInList(gameState.graveyard, "Cycling Card");
          }

          if ((extraManaThisTurn > 5) ||
              (extraManaThisTurn > 3 &&
                  (gameState.hand.contains("Songs of the Damned") ||
                      gameState.deck.contains("Songs of the Damned"))) ||
              (extraManaThisTurn == 3 &&
                  (gameState.hand.contains("Lotus Petal") ||
                      gameState.deck.contains("Lotus Petal")) &&
                  (gameState.hand.contains("Songs of the Damned") ||
                      gameState.deck.contains("Songs of the Damned")))) {
            // play all your reaping the graves
            extraManaThisTurn = extraManaThisTurn - 3;
            gameState.storm = gameState.storm + 1;
            moveCardFromTo(
                "Reaping the Graves", gameState.hand, gameState.graveyard);

            playMade = true;

            int returnAmountOfCards = min(
                countCardInList(gameState.graveyard, "Cycling Card"),
                gameState.storm);
            if (gameLogging) {
              print("Reaping the storm for x cards: " +
                  returnAmountOfCards.toString());
            }

            for (int index = 0; index < returnAmountOfCards; index++) {
              moveCardFromTo(
                  "Cycling Card", gameState.graveyard, gameState.hand);
            }
          }
        }
      }

      // play restless dreams, you don't have anything to cycle anymore
      if (gameState.hand.contains("Lotus Petal") &&
          gameState.hand.contains("Restless Dreams") &&
          countCardInList(gameState.graveyard, "Cycling Card") > 2) {
        if (!playMade) {
          if (gameLogging) {
            print("playing Restless Dreams");
          }
          moveCardFromTo("Lotus Petal", gameState.hand, gameState.graveyard);
          moveCardFromTo(
              "Restless Dreams", gameState.hand, gameState.graveyard);

          while (gameState.hand.contains("Fluctuator") &&
              gameState.graveyard.contains("Cycling Card")) {
            moveCardFromTo("Fluctuator", gameState.hand, gameState.graveyard);
            moveCardFromTo("Cycling Card", gameState.graveyard, gameState.hand);
            extraManaThisTurn = 0;
          }

          drawACard(gameState.deck, gameState.hand);
          playMade = true;
        }
      }
    }

    if ((countCardInList(gameState.battlefield, "Fluctuator") == 0 &&
        (countCardInList(gameState.battlefield, "Cycling Land") +
                countCardInList(
                    gameState.battlefield, "Untapped Cycling Land") +
                countCardInList(gameState.battlefield, "Dromar's Cavern") +
                extraManaThisTurn) ==
            1)) {
      // play a lotus petal if you have a spare to play a fluctuator
      if (gameState.hand.contains("Lotus Petal") &&
          countCardInList(gameState.hand, "Lotus Petal") +
                  countCardInList(gameState.deck, "Lotus Petal") >
              1) {
        moveCardFromTo("Lotus Petal", gameState.hand, gameState.graveyard);
        gameState.storm = gameState.storm + 1;
        extraManaThisTurn = extraManaThisTurn + 1;
      }
    }

    if (countCardInList(gameState.battlefield, "Fluctuator") == 0 &&
        (countCardInList(gameState.battlefield, "Cycling Land") +
                countCardInList(
                    gameState.battlefield, "Untapped Cycling Land") +
                countCardInList(gameState.battlefield, "Dromar's Cavern") +
                extraManaThisTurn) >
            1) {
      if (countCardInList(gameState.hand, "Fluctuator") > 0) {
        // play fluctuator
        if (!playMade) {
          if (gameLogging) {
            print("play Fluctuator");
          }
          gameState.storm = gameState.storm + 1;
          moveCardFromTo("Fluctuator", gameState.hand, gameState.battlefield);
          playMade = true;
        }
      } else {
        // cycle a card
        var cardCycled = false;
        if (gameState.hand.contains("Cycling Card")) {
          if (!playMade) {
            if (gameLogging) {
              print("cycle a cycling card");
            }
            moveCardFromTo("Cycling Card", gameState.hand, gameState.graveyard);
            drawACard(gameState.deck, gameState.hand);
            extraManaThisTurn = 0;
            cardCycled = true;
          }
        }

        if (gameState.hand.contains("Cycling Card - Sideboard Card")) {
          if (!playMade) {
            if (gameLogging) {
              print("cycle a cycling card");
            }
            moveCardFromTo("Cycling Card - Sideboard Card", gameState.hand,
                gameState.graveyard);
            drawACard(gameState.deck, gameState.hand);
            extraManaThisTurn = 0;
            cardCycled = true;
          }
        }

        // cycle a card
        if (gameState.hand.contains("Cycling Land")) {
          if (!playMade && !cardCycled) {
            if (gameLogging) {
              print("cycle a cycling land");
            }
            moveCardFromTo("Cycling Land", gameState.hand, gameState.graveyard);
            drawACard(gameState.deck, gameState.hand);
            extraManaThisTurn = 0;
            cardCycled = true;
          }
        }
        // cycle a card
        if (gameState.hand.contains("Untapped Cycling Land")) {
          if (!playMade && !cardCycled) {
            if (gameLogging) {
              print("cycle a cycling land");
            }
            moveCardFromTo(
                "Untapped Cycling Land", gameState.hand, gameState.graveyard);
            drawACard(gameState.deck, gameState.hand);
          }
        }
      }
    } else if (gameState.hand.contains("Untapped Cycling Land")) {
      // play land
      if (!playMade && !playedALand) {
        // do not set play made, we need to go to new turn after playing land
        if (gameLogging) {
          print("play a untapped land");
        }
        moveCardFromTo(
            "Untapped Cycling Land", gameState.hand, gameState.battlefield);
        playedALand = true;
        playMade = true;
      }
    } else if (gameState.hand.contains("Dromar's Cavern") &&
        (gameState.battlefield.contains("Cycling Land") ||
            gameState.battlefield.contains("Untapped Cycling Land"))) {
      // play land
      if (!playMade && !playedALand) {
        // do not set play made, we need to go to new turn after playing land
        if (gameLogging) {
          print("play a Dromar's Cavern land");
        }
        moveCardFromTo(
            "Dromar's Cavern", gameState.hand, gameState.battlefield);
        if (gameState.battlefield.contains("Untapped Cycling Land")) {
          moveCardFromTo(
              "Untapped Cycling Land", gameState.battlefield, gameState.hand);
        } else {
          moveCardFromTo("Cycling Land", gameState.battlefield, gameState.hand);
        }
        playedALand = true;
        playMade = true;
        extraManaThisTurn = 1;
      }
    } else if (gameState.hand.contains("Cycling Land")) {
      // play land
      if (!playMade && !playedALand) {
        // do not set play made, we need to go to new turn after playing land
        if (gameLogging) {
          print("play a land");
        }
        playedALand = true;
        moveCardFromTo("Cycling Land", gameState.hand, gameState.battlefield);
      }
    }

    if (!playMade) {
      // take an extra turn
      if (gameLogging) {
        print("take a turn, this hand has not plays:");
        print(gameState.hand);
      }
      playedALand = false;
      extraManaThisTurn = 0;
      gameState.turn = gameState.turn + 1;
      gameState.storm = 0;
      drawACard(gameState.deck, gameState.hand);
    }

    if (gameState.turn > 10) {
      gameState.turn = 99;
      return gameState;
    }

    return makePlay(
        gameState: gameState,
        playedALand: playedALand,
        extraManaThisTurn: extraManaThisTurn);
  }

  void londonMulliganHand(hand, deck, handsize) {
    List<String> mulliganedCards = [];

    // first determine which cards to mulligan
    while (hand.length > handsize) {
      if (countCardInList(hand, "Fluctuator") > 1) {
        putCardFromHandOnBottomOfDeck("Fluctuator", hand, mulliganedCards);
      } else if (countCardInList(hand, "Reaping the Graves") > 1) {
        putCardFromHandOnBottomOfDeck(
            "Reaping the Graves", hand, mulliganedCards);
      } else if (countCardInList(hand, "Songs of the Damned") > 1) {
        putCardFromHandOnBottomOfDeck(
            "Songs of the Damned", hand, mulliganedCards);
      } else if (countCardInList(hand, "Lotus Petal") > 1) {
        putCardFromHandOnBottomOfDeck("Lotus Petal", hand, mulliganedCards);
      } else if (hand.contains("Haunting Misery")) {
        putCardFromHandOnBottomOfDeck("Haunting Misery", hand, mulliganedCards);
      } else if (hand.contains("Restless Dreams")) {
        putCardFromHandOnBottomOfDeck("Restless Dreams", hand, mulliganedCards);
      } else if (hand.contains("Misdirection")) {
        putCardFromHandOnBottomOfDeck("Misdirection", hand, mulliganedCards);
      } else if (hand.contains("Cycling Card")) {
        putCardFromHandOnBottomOfDeck("Cycling Card", hand, mulliganedCards);
      } else if (hand.contains("Cycling Card - Sideboard Card")) {
        putCardFromHandOnBottomOfDeck(
            "Cycling Card - Sideboard Card", hand, mulliganedCards);
      } else if (hand.contains("Cycling Land")) {
        putCardFromHandOnBottomOfDeck("Cycling Land", hand, mulliganedCards);
      } else if (hand.contains("Untapped Cycling Land")) {
        putCardFromHandOnBottomOfDeck(
            "Untapped Cycling Land", hand, mulliganedCards);
      } else if (hand.contains("Reaping the Graves")) {
        putCardFromHandOnBottomOfDeck(
            "Reaping the Graves", hand, mulliganedCards);
      } else if (hand.contains("Songs of the Damned")) {
        putCardFromHandOnBottomOfDeck(
            "Songs of the Damned", hand, mulliganedCards);
      } else if (hand.contains("Lotus Petal")) {
        putCardFromHandOnBottomOfDeck("Lotus Petal", hand, mulliganedCards);
      } else {
        putCardFromHandOnBottomOfDeck(
            getRandomCardFrom(hand), hand, mulliganedCards);
      }
    }

    // then put them back in a good order
    while (mulliganedCards.length > 0) {
      if (mulliganedCards.contains("Cycling Card - Sideboard Card")) {
        putCardFromHandOnBottomOfDeck(
            "Cycling Card - Sideboard Card", mulliganedCards, deck);
      } else if (mulliganedCards.contains("Cycling Land")) {
        putCardFromHandOnBottomOfDeck("Cycling Land", mulliganedCards, deck);
      } else if (mulliganedCards.contains("Untapped Cycling Land")) {
        putCardFromHandOnBottomOfDeck(
            "Untapped Cycling Land", mulliganedCards, deck);
      } else if (mulliganedCards.contains("Cycling Card")) {
        putCardFromHandOnBottomOfDeck("Cycling Card", mulliganedCards, deck);
      } else if (mulliganedCards.contains("Lotus Petal")) {
        putCardFromHandOnBottomOfDeck("Lotus Petal", mulliganedCards, deck);
      } else if (mulliganedCards.contains("Haunting Misery")) {
        putCardFromHandOnBottomOfDeck("Haunting Misery", mulliganedCards, deck);
      } else if (mulliganedCards.contains("Songs of the Damned")) {
        putCardFromHandOnBottomOfDeck(
            "Songs of the Damned", mulliganedCards, deck);
      } else if (mulliganedCards.contains("Restless Dreams")) {
        putCardFromHandOnBottomOfDeck("Restless Dreams", mulliganedCards, deck);
      } else if (mulliganedCards.contains("Fluctuator")) {
        putCardFromHandOnBottomOfDeck("Fluctuator", mulliganedCards, deck);
      } else if (mulliganedCards.contains("Misdirection")) {
        putCardFromHandOnBottomOfDeck("Misdirection", mulliganedCards, deck);
      } else {
        putCardFromHandOnBottomOfDeck(
            getRandomCardFrom(hand), mulliganedCards, deck);
      }
    }
  }

  bool isHandPlayable(hand) {
    // snap-keep every hand with fluctuator and lands
    if (hand.contains("Fluctuator") &&
        (hand.contains("Untapped Cycling Land") ||
            hand.contains("Cycling Land"))) {
      return true;
    }
    // keep every 6-er with a fluctuator, you'll draw lands
    if (hand.length < 7 && hand.contains("Fluctuator")) {
      return true;
    }
    // keep every 3-er with lands, you need some cards in hand to combo
    if (hand.length < 6 &&
        (hand.contains("Untapped Cycling Land") ||
            hand.contains("Cycling Land"))) {
      return true;
    }
    // going lower then 4 will cost you combo turns, so always keep after 4.
    if (hand.length < 5) {
      return true;
    }
    return false;
  }

  GameState mulligan(size, onTheDraw, returnDecklistFunction) {
    GameState gameState = GameState(
        deck: returnDecklistFunction(),
        hand: [],
        battlefield: [],
        graveyard: []);

    for (int i = 0; i < 7; i++) {
      drawACard(gameState.deck, gameState.hand);
    }

    londonMulliganHand(gameState.hand, gameState.deck, size);

    if (isHandPlayable(gameState.hand)) {
      gameState.startingHand = size;
      if (onTheDraw) {
        drawACard(gameState.deck, gameState.hand);
      }
      return makePlay(gameState: gameState);
    } else {
      return mulligan(size - 1, onTheDraw, returnDecklistFunction);
    }
  }

  List<String> returnDecklist(tappedCyclingLands, sideboardCyclers,
      sideboardCards, killconditions, petals, rituals, reapingTheGraves) {
    List<String> deck = [];

    deck.add("Fluctuator");
    deck.add("Fluctuator");
    deck.add("Fluctuator");
    deck.add("Fluctuator");

    deck.add("Untapped Cycling Land");
    deck.add("Untapped Cycling Land");
    deck.add("Untapped Cycling Land");
    deck.add("Untapped Cycling Land");
    deck.add("Dromar's Cavern");

    for (int i = 0; i < killconditions; i++) {
      deck.add("Haunting Misery");
    }

    for (int i = 0; i < petals; i++) {
      deck.add("Lotus Petal");
    }

    for (int i = 0; i < rituals; i++) {
      deck.add("Songs of the Damned");
    }

    for (int i = 0; i < reapingTheGraves; i++) {
      deck.add("Reaping the Graves");
    }

    for (int i = 0; i < tappedCyclingLands; i++) {
      deck.add("Cycling Land");
    }

    for (int i = 0; i < sideboardCyclers; i++) {
      deck.add("Cycling Card - Sideboard Card");
    }

    for (int i = 0; i < sideboardCards; i++) {
      deck.add("Misdirection");
    }

    var creatures = 60 - deck.length;
    for (int i = 0; i < creatures; i++) {
      deck.add("Cycling Card");
    }

    return shuffle(deck);
  }
}
