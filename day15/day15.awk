#!/usr/bin/awk -f

BEGIN {
    BOX = "O"
    EMPTY = "."
    ME = "@"
    WALL = "#"
}

#Map line
/^#/ {
    split($0, row, "")
    for (col in row) {
        cell = row[col]
        map[NR][col] = cell
        if (cell == BOX) {
            boxes[NR][col] = 1
        } else if (cell == ME) {
            myRow = NR
            myCol = col
        }
    }
    next
}

# Empty line
/^$/ {
    GRID_HEIGHT = NR - 1
    next;
}

# List of movements line
{
    split($0, moves,"")
    for (m in moves) {
        move = moves[m]
        moveIfPossible(myRow, myCol, move)
    }
}

END {
    for (R in map) {
        for (C in map[R]) {
            cell = map[R][C]
            if (cell == BOX) {
                sum += 100*(R-1) + C-1
            }
        }
    }
    print sum
}

function moveIfPossible(startRow, startCol, move,   newR, newC) {
     # Reached empty tile; nothing to move & objects behind can move
    if (map[startRow][startCol] == EMPTY) {
        return 1
    }
    newR = startRow + getRowMove(move)
    newC = startCol + getColMove(move)

    # OOB, no moving here
    if (isOob(newR, newC)) { 
        return 0
    }
    # target tile is either empty or movable
    if (moveIfPossible(newR, newC, move)) {
        pieceToMove = map[startRow][startCol]
        map[newR][newC] = pieceToMove
        map[startRow][startCol] = EMPTY
        if (pieceToMove == ME) {
            myRow = newR
            myCol = newC
        }
        return 1
    }
}

function isOob(r, c) {
    return ((r <=1 ) || (c <= 1) || (r >= GRID_HEIGHT) || (c >= length($0)) || map[r][c] == WALL)
}


function getRowMove(move) {
    if (move =="^") {return -1}
    if (move ==">") {return 0}
    if (move =="<") {return 0}
    if (move =="v") {return 1}
    print "BROKEN - INVALID MOVE"
}

function getColMove(move) {
    if (move =="^") {return 0}
    if (move ==">") {return 1}
    if (move =="<") {return -1}
    if (move =="v") {return 0}
    print "BROKEN - INVALID MOVE"
}