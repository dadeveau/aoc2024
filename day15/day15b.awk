#!/usr/bin/awk -f

BEGIN {
    BOXL = "["
    BOXR = "]"
    EMPTY = "."
    ME = "@"
    MOVE_UP = "^"
    MOVE_DOWN = "v"
    MOVE_LEFT = "<"
    MOVE_RIGHT = ">"
    WALL = "#"
}

#Map line
/^#/ {
    singleRow = doubleWide($0)
    split(singleRow, row, "")
    GRID_WIDTH = length(singleRow)
    for (col in row) {
        cell = row[col]
        map[NR][col] = cell
        if (cell == ME) {
            myRow = NR
            myCol = col
        }
    }
    next
}

# Empty line
/^$/ {
    GRID_HEIGHT = NR - 1
}

# List of movements line
{
    split($0, moves,"")
    for (m in moves) {
        move = moves[m]
        if (possibleToMove(myRow, myCol, move)) {
            actuallyMove(myRow, myCol, move)
        }
    }
}

END {
    for (R in map) {
        for (C in map[R]) {
            cell = map[R][C]
            if (cell == BOXL) {
                sum += 100*(R-1) + C-1
            }
        }
    }
    print sum
}

function doubleWide(str) { 
    result = ""
    split(str,strArr,"")
    for (charInd in strArr) {
        char = strArr[charInd]
        if (char == WALL) {
            result = result WALL WALL
        } else if (char == "O") {
            result = result BOXL BOXR
        } else if (char == EMPTY) {
            result = result EMPTY EMPTY
        } else if (char == ME) {
            result = result ME EMPTY
        } else {
            print "BROKEN - INVALID CELL"
        }
    }
    return result
}


function possibleToMove(startRow, startCol, move,   newR, newC) {
    pieceToMove = map[startRow][startCol]
    newR = startRow + getRowMove(move)
    newC = startCol + getColMove(move)

    if (pieceToMove == EMPTY) {
        return 1
    }

    if (pieceToMove == WALL) { 
        return 0
    }
    # target tile is either empty or movable
    if (pieceToMove == BOXL && (move == MOVE_UP || move == MOVE_DOWN)) {
        return (possibleToMove(newR, newC, move) && possibleToMove(newR, newC+1, move))
    } else if (pieceToMove == BOXR && (move == MOVE_UP || move == MOVE_DOWN)) {
        return (possibleToMove(newR, newC, move) && possibleToMove(newR, newC-1, move))
    } else {
        return (possibleToMove(newR, newC, move))
    }
}

function actuallyMove(startRow, startCol, move,isBox2,   newR, newC, pieceToMove) {
    pieceToMove = map[startRow][startCol]
    newR = startRow + getRowMove(move)
    newC = startCol + getColMove(move)

    if (pieceToMove == EMPTY || pieceToMove == WALL) {
        return
    }

    actuallyMove(newR, newC, move)
    if (pieceToMove == BOXL && (move == MOVE_UP || move == MOVE_DOWN) && ! isBox2) {
        actuallyMove(startRow, startCol+1, move, 1)
    } else if (pieceToMove == BOXR && (move == MOVE_UP || move == MOVE_DOWN) && ! isBox2) {
        actuallyMove(startRow, startCol-1, move, 1)
    }

    #Everyone has moved in front; finally move self
    map[newR][newC] = pieceToMove
    map[startRow][startCol] = EMPTY
    if (pieceToMove == ME) {
        myRow = newR
        myCol = newC
    }
}

function getRowMove(move) {
    if (move == MOVE_UP) {return -1}
    if (move == MOVE_LEFT) {return 0}
    if (move == MOVE_RIGHT) {return 0}
    if (move == MOVE_DOWN) {return 1}
    print "BROKEN - INVALID MOVE"
}

function getColMove(move) {
    if (move == MOVE_UP) {return 0}
    if (move == MOVE_RIGHT) {return 1}
    if (move == MOVE_LEFT) {return -1}
    if (move == MOVE_DOWN) {return 0}
    print "BROKEN - INVALID MOVE"
}