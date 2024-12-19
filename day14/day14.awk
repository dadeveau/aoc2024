#!/usr/bin/awk -f

BEGIN {
    maxX = 100
    maxY = 102
    midX = maxX/2
    midY = maxY/2
    indexFirstDigit = 3
}

{
    indexFirstComma = index($0, ",")
    indexFirstSpace = index($0, " ")

    # ID robots by their row number NR
    robotX[NR] = substr($0, indexFirstDigit, indexFirstComma - indexFirstDigit)
    robotY[NR] = substr($0, indexFirstComma + 1, indexFirstSpace - indexFirstComma - 1)

    velocity = substr($0, indexFirstSpace+1)
    indexSecondComma = index(velocity, ",")
    dX[NR] = substr(velocity, indexFirstDigit, indexSecondComma - indexFirstDigit)
    dY[NR] = substr(velocity, indexSecondComma + 1)
}


END {


    for (s=1;s<=10000;s++) {
        for (robotId in robotX) {
            moveRobot(robotId)
        }

        delete quadrants
        for (robotId in robotX) {
            addQuadrant(robotX[robotId], robotY[robotId])
        }
        sum = 1
        for (q in quadrants) {
            sum = sum * quadrants[q]
        }
        if (s==100) {
            print "14a: " sum " danger after 100"
        }
        #print sum" danger after "s 
        #if (s==6587) {
        #    print "ROBOTS AFTER "s"MOVES"
        #    printRobots()
        #}
    }
}

function addQuadrant(X, Y) {
    if (X < midX && Y < midY) { 
        quadrants[1] += 1
    } else if (X < midX && Y > midY) {
        quadrants[2] += 1
    } else if (X > midX && Y < midY) {
        quadrants[3] += 1
    } else if (X > midX && Y > midY) {
        quadrants[4] += 1
    }
}

function moveRobot(id) {
    newX = robotX[id] + dX[id]
    newY = robotY[id] + dY[id]

    if (newX < 0) { 
        newX = maxX + newX + 1
    } else if (newX > maxX) { 
        newX = newX - maxX  - 1
    }

    if (newY < 0) { 
        newY = maxY + newY + 1
    } else if (newY > maxY) { 
        newY = newY - maxY - 1
    }

    robotX[id] = newX
    robotY[id] = newY
}


function printRobots() {
    for (x = 0; x <= maxX; x++) {
        row=""
        for (y =0; y <= maxY; y++) {
            hasRobot = 0
            for (id in robotX) {
                if (x==robotX[id] && y==robotY[id]) { 
                    row = row"*"
                    hasRobot = 1
                    break
                }
            }
            if (!hasRobot) {
                row = row"."
            }
        }
        print row
    }
}