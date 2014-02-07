import 'dart:async' show Timer;
import 'gameoflife_algorithm.dart';


final Duration sleepDuration = new Duration(milliseconds:300);

const int WORLD_X = 128;
const int WORLD_Y = 32;

Timer timer;

GameOfLife game = new GameOfLife(WORLD_X, WORLD_Y);

main() {
	timer = new Timer.periodic(sleepDuration, (t) {
		print("\x1B[2J\x1B[0;0H");
		game.recalculateWorld();
		print(game.toString());
	});
}
