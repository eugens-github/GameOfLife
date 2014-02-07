import 'dart:html';
import 'dart:svg' as SVG;
import 'dart:async' show Timer;
import 'gameoflife_algorithm.dart';


final Duration sleepDuration = new Duration(milliseconds:200);

const int STEPS = 1000;
const int CELL_SIZE = 10;
const int RANDOM_ACTIVATIONS = 30; // in %

const String ID_PREFIX = "id";
const String ON = "#0000FF";
const String OFF = "#00FFFF";

final Map<String, SVG.RectElement> worldCellMap = new Map();

const int WORLD_X = 100;
const int WORLD_Y = 60;

bool mouseDown = false;
HtmlElement statusElement;
Timer timer;

GameOfLife game = new GameOfLife(WORLD_X, WORLD_Y);

main() {
	statusElement = querySelector("#status");

	var svg_world = querySelector("#svg_world");

	querySelector("#start").onClick.listen((e) => startGame());
	querySelector("#stop").onClick.listen((e) => timer != null ? timer.cancel() : "");
	querySelector("#step").onClick.listen((e) => rebuildWorld());

	querySelector("#new").onClick.listen((e) {
		if (timer != null)
			timer.cancel();

		game = new GameOfLife(WORLD_X, WORLD_Y);
		initWorldView(svg_world);
		status = "Random World is Ready";
	} );

	querySelector("#new_empty").onClick.listen((e) {
		if (timer != null)
			timer.cancel();

		game = new GameOfLife.myWorld(createWorld(WORLD_X, WORLD_Y, 0, true));
		initWorldView(svg_world);
		status = "Empty World is Ready";
	} );

	initWorldView(svg_world);
}

set status(var status){
	statusElement.innerHtml = status;
}

startGame() {
	status = "Game started ...";
	int i = 0;

	timer = new Timer.periodic(sleepDuration, (t) {
		if (!mouseDown) {
			rebuildWorld();

			if (i++ > STEPS) {
				t.cancel();
				status = "... Finished";
			}
		}
	});

}

rebuildWorld() {
	game.recalculateWorld();
	refreshWorldView();
}

initWorldView(Element svgWorld) {
	int x_on_svg = 0;
	int y_on_svg = 0;

	for (int _y = 0; _y < WORLD_Y; _y++) {
		for (int _x = 0; _x < WORLD_X; _x++) {
			var r = new SVG.RectElement();

			r.id = "$ID_PREFIX${_x}_$_y";
			r.attributes["x"] = "$x_on_svg";
			r.attributes["y"] = "$y_on_svg";
			r.attributes["height"] = "$CELL_SIZE";
			r.attributes["width"] = "$CELL_SIZE";
			r.attributes["stroke"] = "lightgray";
			r.attributes["fill"] = game.world[_y][_x] ? ON : OFF;

			r.onMouseDown.listen((e) => editWorld(e));
			r.onMouseUp.listen((e) => mouseDown = false);
			r.onMouseOver.listen((e) =>  mouseDown ? editWorld(e) : "");

			worldCellMap[r.id] = r;

			svgWorld.append(r);
			x_on_svg += CELL_SIZE;
		}

		x_on_svg = 0;
		y_on_svg += CELL_SIZE;
	}
}

refreshWorldView() {
	final int y = game.world.length;
	final int x = game.world[0].length;

	for (int _y = 0; _y < y; _y++) {
		for (int _x = 0; _x < x; _x++) {
			final cell_id = "$ID_PREFIX${_x}_$_y";
			final cell = worldCellMap[cell_id];

			cell.attributes["fill"] = game.world[_y][_x] ? ON : OFF;
		}
	}
}

editWorld(var e) {
	mouseDown = true;

	status = "Edit cell: ${e.currentTarget.id}";

	final split = e.currentTarget.id.split("_");

	final w_x = int.parse(split[0].substring(ID_PREFIX.length));
	final w_y = int.parse(split[1]);

	game.world[w_y][w_x] = !game.world[w_y][w_x];
	e.currentTarget.attributes["fill"] = game.world[w_y][w_x] ? ON : OFF;
}
