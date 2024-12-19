#!/usr/bin/awk -f

BEGIN {
    BOUNDARY = "#"
    CONTINUE_SCORE = 1
    TURN_SCORE = 1000
    START = "S"
    BEST_SCORE = 143564
}

{
    split($0, row, "")
    for (col in row) {
        cell = row[col]
        map[NR,col] = cell
        if (cell == START ) {
            startRow = NR
            startCol = col
        } else if (cell == "E") {
            endRow = NR
            endCol = col
        }
    }
}


END {
    traverseMap(startRow, startCol, 0, "R")
    print minScores[endRow, endCol]
    print length(bestVisited)
}


function traverseMap(myRow, myCol, score, lastMove, visited) {
    if (map[myRow, myCol] == BOUNDARY) {
        return
    }
    if ((myRow, myCol) in minScores && ((minScores[myRow,myCol]+TURN_SCORE < score && minScoreLastMove[myRow,myCol] != lastMove) || ((minScores[myRow,myCol] < score && minScoreLastMove[myRow,myCol] == lastMove)))) {
        return
    } else {
        minScores[myRow, myCol] = score
        minScoreLastMove[myRow, myCol] = lastMove
    }

    if (map[myRow, myCol] == "E") {
        if (score == BEST_SCORE) {
            split(visited, visitedCoords, " ")
            for (i=1; i<length(visitedCoords); i+=2) { 
                bestVisited[visitedCoords[i],visitedCoords[i+1]] = 1
            }
            bestVisited[myRow, myCol] = 1
        }
        return
    }

    if (lastMove == "U") {
        traverseMap(myRow-1, myCol, score+CONTINUE_SCORE, "U", visited" "myRow" "myCol)
        traverseMap(myRow, myCol-1, score+TURN_SCORE+CONTINUE_SCORE, "L", visited" "myRow" "myCol)
        traverseMap(myRow, myCol+1, score+TURN_SCORE+CONTINUE_SCORE, "R", visited" "myRow" "myCol)
    } else if (lastMove == "D") {
        traverseMap(myRow+1, myCol, score+CONTINUE_SCORE, "D", visited" "myRow" "myCol)
        traverseMap(myRow, myCol-1, score+TURN_SCORE+CONTINUE_SCORE, "L", visited" "myRow" "myCol)
        traverseMap(myRow, myCol+1, score+TURN_SCORE+CONTINUE_SCORE, "R", visited" "myRow" "myCol)
    } else if (lastMove == "L") {
        traverseMap(myRow-1, myCol, score+TURN_SCORE+CONTINUE_SCORE, "U", visited" "myRow" "myCol)
        traverseMap(myRow+1, myCol, score+TURN_SCORE+CONTINUE_SCORE, "D", visited" "myRow" "myCol)
        traverseMap(myRow, myCol-1, score+CONTINUE_SCORE, "L", visited" "myRow" "myCol)
    } else if (lastMove == "R") {
        traverseMap(myRow-1, myCol, score+TURN_SCORE+CONTINUE_SCORE, "U", visited" "myRow" "myCol)
        traverseMap(myRow+1, myCol, score+TURN_SCORE+CONTINUE_SCORE, "D", visited" "myRow" "myCol)
        traverseMap(myRow, myCol+1, score+CONTINUE_SCORE, "R", visited" "myRow" "myCol)
    }
}