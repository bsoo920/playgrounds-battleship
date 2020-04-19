    let stepSize = 4
    var offset = 0
    var keyTile = Tile()
    var starDirections = [Direction]()
    let startCol = 2
    var nextRow = 0
    var nextCol = 0
    
    func firstCoordinate() -> Coordinate {
        nextRow = 0
        nextCol = startCol
        return Coordinate(column: nextCol, row: nextRow)
    }
    
    func nextCoordinate(previousTile: Tile) -> Coordinate {
        
        // If starDirections.isEmpty and previousTile != hit, continue regular scan (skip starSearch).
        // Else CALL starSearch(previousTile)
        //  - if   starDirections.isEmpty and previousTile == hit, then a new star search will be done.
        //  - Elif starDirections is not empty, then starSearch is in progress and will continue.
        
        // If after starSearch, starDirections.isEmpty, then starSearch finished with no more tiles found.  Resume regular scan.
        // else return starSearch result.
        
        var nextCoord = Coordinate( column: 0, row: 0)  // arbitrary
        
        if starDirections.isEmpty && previousTile.state != .hit {
            nextCoord = nextScanCoordinate()
            
        } else {
            nextCoord = starSearch(previousTile: previousTile).coordinate
            
            if starDirections.isEmpty {
                nextCoord = nextScanCoordinate()
            }
        }
        
        return nextCoord
    }
    
    func starSearch(previousTile: Tile) -> Tile {
        // previousTile MUST be an explored, tried and true tile.
        
        // 1. If starDirections.isEmpty, then START starSearch from PREVIOUSTILE.
        // 2. Elif previousTile is a hit, continue search direction from PREVIOUSTILE.
        // 3. Else, i.e. previousTile is a Miss, then use NEW search direction from KEYTILE.
        
        var nextTile = Tile()
        if starDirections.isEmpty {
            keyTile = previousTile
            nextTile = previousTile
            starDirections = Direction.allCases
            
        } else if previousTile.state == .hit {
            nextTile = previousTile
            
        } else {  // an explored miss
            starDirections.removeFirst()
            
            if starDirections.isEmpty { return keyTile}  //search finished (previousTile was last tile of starSearch)
            
            nextTile = keyTile  // search continues with new direction from keyTile
        } 
        
        // Search Loop:
        // nextTile = next tile in direction
        // If hit, loop to top.
        // elif unexplored, RETURN nextTile.
        // ELSE, i.e. explored miss or off grid, remove direction and:
        //   - if no directions left, RETURN keyTile.  (starSearch finished)
        //   - else start new direction from keyTile.
        
        var directionToFollow = starDirections[0]
        
        while nextTile.state != .unexplored {
            nextTile = grid.tileAt(nextTile.coordinate.advanced(by: 1, inDirection: directionToFollow)) 
            
            if nextTile.state == .hit {
                // loop to top, keep looking
                
            } else if nextTile.state == .unexplored {
                return nextTile
                
            } else {
                starDirections.removeFirst()
                
                if starDirections.isEmpty {
                    return keyTile
                } else {
                    directionToFollow = starDirections[0]
                    nextTile = keyTile
                }
            }
        }
        return nextTile  // should never execute
    }
    
    
    func nextScanCoordinate() -> Coordinate {
        
        nextCol += stepSize
        
        if nextCol > 9 {
            nextRow += 1
            if nextRow > 9 { 
                nextRow = 0
                offset += 2
            }
            nextCol = nextRow + startCol + offset
            if nextCol >= stepSize { nextCol = nextCol % stepSize}
        }
        
        return Coordinate(column: nextCol, row: nextRow)
    }
    
