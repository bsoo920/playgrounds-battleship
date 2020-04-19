## My 56-turn-average solution to Swift Playgrounds' Battleship challenge
<img src='https://i.imgur.com/AoDYf7B.gif' title='44-turn game' width='' alt='gif of a 44-turn game' />

### Background
Apple Swift Playgrounds' Battleship challege \[[1](#notes)\] comes pre-loaded with three solutions of varying complexity and performance (number of turns needed to finish game on average).  Here's a comparison:

Solution    | Average turns per game | # lines of code \[[2](#notes)\]
---------------------- | --- | ---
pre-loaded _Sinking a Ship_       | 92 | 21
pre-loaded _Locatig Ships_        | 69 | 48
pre-loaded _An Example Algorithm_ | 62 | 148
**_My Solution_**        | **_56_** | **_116_**

### Concept of my solution
In this write-up, I will use the term _hit_ and _fire at_ interchangeably, e.g. hitting a tile or firing at a tile.  When I refer to _a ship being "hit"_ I will put quotes around **_"hit"_**.

The concept is fairly simple:
1. Efficiently scan the grid for long ships.
2. Whenever a ship is found, fire at neighboring tiles in all four directions until there's a miss in each direction.
3. When #1 is complete, scan again for smaller ships, performing #2 each time there's a "hit".

#### 1. Efficiently Scan the grid for long ships
I've chosen to start scanning by firing at every 5th tile, i.e. skipping 3 tiles after each firing.  This guarantees that all 4- and 5-tile ships will sustain hits and therefore be identified.

<img src='https://i.imgur.com/FEiS2jg.png' title='26-turn scan' width='' alt='image of a 26-turn scan' />

You will notice the above took 26 turns.  There are a 100 tiles total, and I am hitting 1 out of every 4 tiles (after a hit, I skip the next 3).  So you'd think only 25 tiles will be hit after this scan.  As it turns out, there are several possible configurations of this scan pattern.  Here's what I found to require only 24 turns, and thus the most efficient 1-out-of-every-4-tile scan:

<img src='https://i.imgur.com/jwQ1rBO.png' title='24-turn scan' width='' alt='image of a 24-turn scan' />

Conceptually, this scan is more efficient because at the corners it's taking advantage of the grid boundaries to "corner" any ship that might be there.

#### 2. Fire at neighboring tiles in all directions
Whenever a scanned tile is a "hit", I proceed to scan its neighboring tiles in a "+" pattern (I call this "Star Search" in the code).  In this example I started the "star" with the tile near the center:

<img src='https://i.imgur.com/cHSWLqR.png' title='star search scan' width='' alt='image of a star search scan' />

You will notice that when scanning leftward, I did not stop at the previously hit-but-missed tile


One way to guarantee that every ship will at least be partially hit is to fire at every other tile, since the shortest ship is only two tiles long.  But that means  you can easily make 50 turns



##### Notes
1. It's really Apple Swift Playgrounds' Battleship **_Playground_**, but, really?
2. Includes comments
