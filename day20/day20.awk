#!/usr/bin/awk -f
BEGIN {
    pathCell = "."
    wallCell = "#"
    startCell = "S"
    endCell = "E"
    pathMoves[-1,0] = 1; pathMoves[1,0] = 1; pathMoves[0,-1] = 1; pathMoves[0,1] = 1
    cheatMoves[-1,-1] = 1; cheatMoves[-1,1] = 1; cheatMoves[1,-1] = 1; cheatMoves[1,1] = 1
    cheatMoves[-2,0] = 1; cheatMoves[2,0] = 1; cheatMoves[0,-2] = 1; cheatMoves[0,2] = 1
    CHEAT_SAVE_THRESHOLD = 100
}

{
    split($0, row, "")
    for (c in row) {
        cell = row[c]
        map[NR, c] = cell
        if (cell == startCell) {
            startRow = NR
            startCol = c
        } else if (cell == endCell) {
            endRow = NR
            endCol = c
        }
    }
}

END {
    split("",path,"")

    traverseMap(path)
    sumA = traverseWithCheats(path, 2, CHEAT_SAVE_THRESHOLD)    
    print "20a: " sumA
    sumB = traverseWithCheats(path, 20, CHEAT_SAVE_THRESHOLD)    
    print "20b: " sumB
}

function traverseWithCheats(path, maxCheatDistance, cheatThreshold) {
    count = 0
    for (cell in path) {
        startSteps = path[cell]
        split(cell,xy,SUBSEP)
        currRow = xy[1]
        currCol = xy[2]
        for (dR = -maxCheatDistance; dR<=maxCheatDistance; dR++) {
            for (dC = -maxCheatDistance; dC<=maxCheatDistance; dC++) {
                cheatLen = abs(dR) + abs(dC)
                if (abs(dR) + abs(dC) > maxCheatDistance) {
                    continue;
                }
                testRow = currRow + dR
                testCol = currCol + dC
                if ((testRow, testCol) in path) {
                    skipLocationSteps = path[testRow, testCol]
                    cheatSave = skipLocationSteps - startSteps - cheatLen
                    if (cheatSave >= cheatThreshold) {
                        count += 1
                    }
                }
            }
        }
    }
    return count
}

function traverseMap(path) {
    currRow = startRow
    currCol = startCol
    stepCount = 0
    path[currRow, currCol] = stepCount
    while (! (currRow == endRow && currCol == endCol)) {
        stepCount += 1
        for (move in pathMoves) {
            split(move,deltas,SUBSEP)
            dR = deltas[1]
            dC = deltas[2]
            testRow = currRow + dR
            testCol = currCol + dC
            if (!(testRow, testCol) in path) {
                if (map[testRow, testCol] == pathCell || map[testRow, testCol] == endCell) {
                    currRow = testRow
                    currCol = testCol
                    break
                }
            }
        }
        path[currRow, currCol] = stepCount
    }
}

function abs(n) { 
    if (n < 0) {
        return -n
    } else {
        return n
    }
}