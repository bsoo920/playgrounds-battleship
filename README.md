## My 56-turn-average solution to Swift Playgrounds' Battleship challenge
<img src='https://i.imgur.com/AoDYf7B.gif' title='44-turn game' width='' alt='gif of a 44-turn game' />

## Background
Apple Swift Playgrounds' Battleship challenge \[[1](#notes)\] comes pre-loaded with three solutions of varying complexity and performance (number of turns needed to finish game on average).  Here's a comparison:

Solution    | Average turns per game | # lines of code \[[2](#notes)\]
---------------------- | --- | ---
pre-loaded _Sinking a Ship_       | 92 | 13
pre-loaded _Locating Ships_        | 69 | 30
pre-loaded _An Example Algorithm_ | 62 | 95
**_My Solution_**        | **_56_** | **_68_**

## Concept of my solution
In this write-up, I will use the term _hit_ and _fire at_ interchangeably, e.g. hitting a tile or firing at a tile.  When I refer to _a ship being "hit"_ I will put quotes around **_"hit"_**.

The concept is fairly simple:
1. Efficiently scan the grid for long ships.
2. Whenever a ship is found, fire at neighboring tiles in all four directions until there's a miss in each direction.
3. When #1 is complete, scan again for smaller ships, performing #2 each time there's a "hit".

Note that this simple yet efficient strategic does not involve any of the following:
- examining the "inventory" of sunk/floating ships
- probability calculation
- randomizing what tiles to hit

### 1. Efficiently Scan the grid for long ships
I've chosen to start scanning by firing at every 5th tile, i.e. skipping 3 tiles after each firing.  **This guarantees that all 4- and 5-tile ships will sustain "hits" and therefore be identified.**

<img src='https://i.imgur.com/lKuYQL5.png' title='26-turn scan' width='' alt='image of a 26-turn scan' />

You will notice the above took 26 turns.  There are a 100 tiles total, and I am hitting 1 out of every 4 tiles (after a hit, I skip the next 3).  So you'd think only 25 tiles will be hit after this scan.  As it turns out, there are several possible configurations of this scan pattern.  Here's what I found to require only 24 turns, and thus the most efficient 1-out-of-every-4-tile scan:

<img src='https://i.imgur.com/8n4vWQX.png' title='24-turn scan' width='' alt='image of a 24-turn scan' />

Conceptually, this scan is more efficient because at the corners it's taking advantage of the grid boundaries to "corner" any ship that might be there.

### 2. "Star Search" - fire at neighboring tiles in all directions
Whenever a scanned tile is a "hit", I proceed to scan its neighboring tiles in a "+" pattern (I call this "Star Search" in the code).  Below screenshot shows two examples of this Star Search starting at the tiles highlighted with red squares:

<img src='https://i.imgur.com/skbSUqX.png' title='star search scan' width='' alt='image of a star search scan' />

The tile at the bottom only has 3 directions to scan (right, up, left), and in each direction, it only stops when there is a miss.  It found two more "hits" to the right.  The next highlighted tile near center right has all 4 directions to scan, and in the process found one "hit" to the right, one above.

The next screenshot shows the next Star Search that started at the red-highlighted tile.  Note that when scanning down and to the left, it skipped a previously "hit" tile and proceeded to the next one (white-highlighted tiles).  Algorithmically this is because the scan only stops when it encounters a miss or grid boundary.  Conceptually, we want to keep exploring any contiguous line of "hit" tiles to explore the length of the ship (though it could actually be multiple ships parked parallel).

<img src='https://i.imgur.com/qgClWjy.png' title='star search scan 2' width='' alt='image of a star search scan 2' />

And here is the next Star Search from the initial grid scan (#1).  (Please ignore the black-highlighted tile - I clicked on it accidentally.  Yeah I did this manually to illustrate, since the code does things in a differnet order.)

<img src='https://i.imgur.com/sWdctZm.png' title='star search scan 3' width='' alt='image of a star search scan 3' />

Oftem times the game will be finished before you get to #3!  But if not...

### 3. Scan again for smaller ships
This is actually the same scan as #1 but offset by two tiles.  This complements #1, and together they effectively become an every-other-tile scan of the grid, which guarantees "hitting" _all_ ships.  Conceptually this is what the second scan looks like (shown mid-progress to illustrate):

<img src='https://i.imgur.com/wRVCEE5.png' title='second grid scan' width='' alt='image of second grid scan' />

Whenever a "hit" occurs, #2 is applied.

These three steps will find and "hit" all ships, often under 50 turns!

## Actual code execution
The code executes the steps in a different order, but adhering to the same concept.  It basically performs #1 but also #2 each time a ship is "hit".  (When Star Search encounters a new "hit", the new "hit" does not start another Star Search.)  When it finishes a Star Search, it proceeds to the next tile of the scan.

When scanning encounters a tile that is already "hit" (from a previous Star Search), it will perform another Star Search from there.

If the initial scan #1 finishes and the game is still at play, then it proceeds to #3, again performing a Star Search each time it "hits" a ship during scanning.

<img src='https://i.imgur.com/en95goZ.gif' title='56-turn game' width='' alt='gif of a 56-turn game' />

##### Notes
1. It's really Apple Swift Playgrounds' Battleship **_Playground_**, but, really?
2. Excludes comments and blank lines.
