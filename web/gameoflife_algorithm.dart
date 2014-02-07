library gameoflife_algorithm;

import 'dart:math' show Random;

/**
 * http://de.wikipedia.org/wiki/Conways_Spiel_des_Lebens
 * */
class GameOfLife {

	int _WORLD_X;
	int _WORLD_Y;

	List<List<bool>> _world;
	List<List<bool>> _tempWorld;

	GameOfLife(this._WORLD_X, this._WORLD_Y) {
		_world = createWorld(_WORLD_X,  _WORLD_Y);
		_tempWorld = createWorld(_WORLD_X, _WORLD_Y, 0, true);
	}

	GameOfLife.myWorld(List<List<bool>> myWorld) {
		_world = myWorld;
		_WORLD_Y = _world.length;
		_WORLD_X = _world[0].length;
		_tempWorld = createWorld(_WORLD_X, _WORLD_Y, 0, true);
	}

	List<List<bool>> get world => _world;

	recalculateWorld() {
	  	for (int y = 0; y < _world.length; y++) {
	    	for (int x = 0; x < _world[y].length; x++) {
	      		_tempWorld[y][x] = _calculateNewState(y, x, _world[y][x]);
	    	}
	  	}

		var tmp = _world;
		_world = _tempWorld;
		_tempWorld = tmp;
	}

	bool _calculateNewState(int y, int x, bool currentState) {
		final int livingNeighbor = _countLivingNeighbor(y, x);

		if (currentState)
		  return livingNeighbor == 2 || livingNeighbor == 3;
		else
		  	return livingNeighbor == 3;
	}

	/*
	 *  + xxx -->
	 * | y
	 * | y
	 * v y                 N
	 *   #######           ^
	 *   #O#O#O#           |
	 *   #O###O#      W <-----> O
	 *   #O#O#O#           |
	 *   #######           v
	 *                     S
	 * */
	int _countLivingNeighbor(final int y, final int x) {
	  	final int max_y = _world.length - 1;
	  	final int max_x = _world[y].length - 1;

	  	// borders are dead zone
		final int n = y > 0 ? _toInt(_world[y-1][x]) : 0;
		final int s = y < max_y ? _toInt(_world[y+1][x]) : 0;
		final int o = x < max_x ? _toInt(_world[y][x+1]) : 0;
		final int w = x > 0 ? _toInt(_world[y][x-1]) : 0;
		final int no = y > 0 && x < max_x ? _toInt(_world[y-1][x+1]) : 0;
		final int so = y < max_y && x < max_x ? _toInt(_world[y+1][x+1]) : 0;
		final int sw = y < max_y && x > 0 ? _toInt(_world[y+1][x-1]) : 0;
		final int nw = y > 0 && x > 0 ? _toInt(_world[y-1][x-1]) : 0;

	  	return n + nw + w + sw + s + so + o + no;
	}

	int _toInt(bool b) {
	  return b ? 1 : 0;
	}

	@override
	String toString() {
		final StringBuffer sb = new StringBuffer();

		for (int y = 0; y < _world.length; y++) {
	    	for (int x = 0; x < _world[y].length; x++) {
	    		sb.write(_world[y][x] ? '@' : '-');
	    	}

	    	sb.write('\n');
	  	}

		return sb.toString();
	}
}

final Random shaker = new Random();

List<List<bool>> createWorld(int x, int y, [int random_activations = 30, bool createEmptyWorld = false]) {
	return new List<List<bool>>
		.generate(y, (int y_idx) {
			if (createEmptyWorld)
				return new List<bool>.filled(x, false);
			else
				return new List<bool>.generate(x,
					(int x_idx) => shaker.nextInt(100) < random_activations);
		});
}
