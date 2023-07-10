# conwaysgameoflife

A Dart code implementation of Conway's Game of Life. This version only prints every 100 generations in favor of speed.

1. The code begins with importing the necessary libraries: `dart:io` for input/output operations and `dart:convert` for character encoding and decoding.

2. Next, a class named `GameOfLife` is defined, representing the Game of Life simulation. It has the following properties:
   - `height` and `width`: The dimensions of the grid.
   - `grid`: A 2D list representing the current state of the grid.
   - `newGrid`: A 2D list used for computing the next generation.

3. The `GameOfLife` class also has several methods:
   - `initialize()`: Reads the initial state of the grid from a file called "output.txt" and initializes the `grid` property.
   - `_mapCharacterToCellValue(int c)`: Maps the ASCII value of a character to a cell value (1 for 'o', 0 otherwise).
   - `countLiveNeighbours(int i, int j)`: Counts the number of live neighbors for a given cell at position (i, j).
   - `clearTerminal()`, `moveCursorToTopLeft()`, `moveCursorToSecondLine()`, `clearLine()`: Utility methods for terminal manipulation to display the grid.
   - `showFirstGeneration()`: Clears the terminal, displays the initial generation, and waits for user input to proceed.
   - `showLastGeneration()`: Clears the terminal, displays the first generation, and runs the game until it reaches a stable state. Then displays the final generation and waits for user input.
   - `startGame()`: Initializes the grid and starts the game.
   - `play()`: Runs the game simulation until a stable state is reached. Prints the generations every 100 iterations.
   - `cloneGrid(List<List<int>> originalGrid)`: Creates a deep copy of the grid.
   - `gridsAreEqual(List<List<int>> grid1, List<List<int>> grid2)`: Checks if two grids are equal.
   - `update()`: Updates the grid to the next generation based on the rules of the Game of Life.
   - `isEmptyGrid()`: Checks if the grid is empty (all cells are dead).
   - `printGrid()`: Prints the grid to the console, using Unicode block characters to represent live and dead cells.

4. The `main()` function is where the execution starts. It creates an instance of the `GameOfLife` class, initializes the grid, shows the first generation, and starts the game.

Overall, this code implements Conway's Game of Life and provides methods to initialize, simulate, and display the generations of the game. The `showLastGeneration()` method specifically focuses on displaying the stable state of the game.
