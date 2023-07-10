import 'dart:io';
import 'dart:convert';

class GameOfLife {
  final int height = 200;
  final int width = 270;
  List<List<int>> grid;
  List<List<int>> newGrid;

  GameOfLife() {
    grid = List.generate(height, (_) => List.filled(width, 0), growable: false);
    newGrid = List.generate(height, (_) => List.filled(width, 0), growable: false);
  }

  Future<void> initialize() async {
    var file = File('output.txt');
    var lines = file.openRead();

    int i = 0;
    await for (var line in lines.transform(utf8.decoder).transform(LineSplitter())) {
      if (line.isNotEmpty) {
        grid[i] = line.codeUnits.map((c) => _mapCharacterToCellValue(c)).toList();
      }
      i++;
    }
  }

  int _mapCharacterToCellValue(int c) {
    return c == 111 ? 1 : 0; // Set 'o' characters to 1 (live cell)
  }

  int countLiveNeighbours(int i, int j) {
    var liveNeighbours = 0;

    for (var x = -1; x <= 1; x++) {
      for (var y = -1; y <= 1; y++) {
        if (x == 0 && y == 0) continue;

        final ni = (i + x + height) % height;
        final nj = (j + y + width) % width;
        liveNeighbours += grid[ni][nj];

        if (liveNeighbours > 3) {
          break;
        }
      }

      if (liveNeighbours > 3) {
        break;
      }
    }

    return liveNeighbours;
  }

  void clearTerminal() {
    stdout.write('\x1B[2J\x1B[0;0H');
  }

  void moveCursorToTopLeft() {
    stdout.write('\x1B[0;0H');
  }

  void moveCursorToSecondLine() {
    stdout.write('\x1B[1;0H');
  }

  void clearLine() {
    stdout.write('\x1B[2K');
  }

  void showFirstGeneration() {
    clearTerminal();
    moveCursorToTopLeft();
    stdout.write('Generation: 0\n');
    printGrid();
    stdin.readLineSync(); // Wait for user to press enter
  }

  void showLastGeneration() async {
    clearTerminal();
    moveCursorToTopLeft();
    stdout.write('Generation: 1\n');
    await play(); // This will stop at the last stable generation
    printGrid();
    stdin.readLineSync(); // Wait for user to press enter
  }

  Future<void> startGame() async {
    await initialize();
    play();
  }

  Future<void> play() async {
    var generationCount = 2;
    List<List<int>> previousGrid;

    while (!isEmptyGrid()) {
      previousGrid = cloneGrid(grid);
      update();

      if (gridsAreEqual(grid, previousGrid)) {
        break;
      }

      if (generationCount % 100 == 0) {  // Only update terminal every 100 generations
        clearTerminal();
        moveCursorToTopLeft();
        stdout.write('Generation: $generationCount\n');
        printGrid();
      }

      generationCount++;
    }

    // Print final state
    clearTerminal();
    moveCursorToTopLeft();
    stdout.write('Generation: ${generationCount - 1}\n');
    printGrid();
    stdout.write('Game finished after ${generationCount - 1} generations.\n');
    stdout.writeln();
  }

  List<List<int>> cloneGrid(List<List<int>> originalGrid) {
    return originalGrid.map((row) => List<int>.from(row)).toList();
  }

  bool gridsAreEqual(List<List<int>> grid1, List<List<int>> grid2) {
    for (var i = 0; i < height; i++) {
      for (var j = 0; j < width; j++) {
        if (grid1[i][j] != grid2[i][j]) {
          return false;
        }
      }
    }
    return true;
  }

  void update() {
    for (var i = 0; i < height; i++) {
      for (var j = 0; j < width; j++) {
        final liveNeighbours = countLiveNeighbours(i, j);
        final cellState = grid[i][j];

        if (cellState == 1) {
          if (liveNeighbours < 2 || liveNeighbours > 3) {
            newGrid[i][j] = 0; // live cell dies
          } else {
            newGrid[i][j] = 1; // live cell survives
          }
        } else {
          if (liveNeighbours == 3) {
            newGrid[i][j] = 1; // dead cell comes to life
          } else {
            newGrid[i][j] = 0; // dead cell remains dead
          }
        }
      }
    }

    var temp = grid;
    grid = newGrid;
    newGrid = temp;
  }

  bool isEmptyGrid() {
    for (var i = 0; i < height; i++) {
      for (var j = 0; j < width; j++) {
        if (grid[i][j] != 0) {
          return false;
        }
      }
    }
    return true;
  }

  void printGrid() {
    for (var i = 0; i < height; i++) {
      for (var j = 0; j < width; j++) {
        stdout.write(grid[i][j] == 1 ? '\u2588' : '\u2591');
      }
      stdout.writeln();
    }
  }
}

void main() async {
  final game = GameOfLife();
  await game.initialize();
  game.showFirstGeneration();
  await game.startGame();
}
